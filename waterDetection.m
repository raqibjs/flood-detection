clc;
clear all;
close all;

%% Calculate mean from traing water images

[redMean, greenMean, blueMean] = meansOfFlood();

%% Get video sequences
videoObj = VideoReader('water3.mp4');

%% Get all frame from the video object

nframes = get(videoObj, 'NumberOfFrames');

%% Take one frame to make a result container
I = read(videoObj, 1);

%% Result container
results = zeros([size(I,1) size(I,2) 3 nframes], class(I));

%% For every frame
for k = 1 : nframes
    tic;
    img = read(videoObj, k);
    [row col dim] = size(img);
    im = double(img);
    
    red = im(:, :, 1);
    green = im(:, :, 2);
    blue = im(:, :, 3);
    
    %% Color analysis
    for x=1:1:row
        for y=1:1:col
            redVal = abs(red(x,y) - redMean);
            greenVal = abs(green(x,y) - greenMean);
            blueVal = abs(blue(x,y) - blueMean);
            sd = 48;
            if((redVal <= sd) && (greenVal <= sd) && (blueVal <= sd))
                biIm(x,y) = 1;
            else
                biIm(x,y) = 0;
            end
        end
    end

    %% Remove noise effect and narrow connection
    sedisk = strel('disk',2);
    openedIm = imopen(biIm, sedisk);

    %% Filling small holes inside detected region
    closedIm = imclose(openedIm, sedisk);
    
    %% Delete small objects

    numberOfPixels = numel(biIm);
    removeTh = round(numberOfPixels - numberOfPixels * 90 / 100); % remove when pixel number 8% less than total pixel; 
    filteredIm = bwareaopen(closedIm, removeTh);

    %% If water logged area found
    numberOfTruePixels = sum(filteredIm(:));
    
    if(numberOfTruePixels > 0)
        disp('Warning: Water logged area! ');
        % Making output image if it marking water region
        for x=1:1:row
            for y=1:1:col
                if(filteredIm(x,y) > 0)
                    red(x,y) = 255;
                    green(x,y) = 0;
                    blue(x,y) = 0;
                else
                    red(x,y) = red(x,y);
                    green(x,y) = green(x,y);
                    blue(x,y) = blue(x,y);
                end
            end
        end
        

        % Make RGB image from individual R, G, B plane
        newIm = cat(3, red, green, blue);
        
        % Store processed image into result container
        results(:,:,:,k) = newIm;

    %% No water logged area
    else
        disp('No Water');
        % Store input image into result container
        results(:,:,:,k) = img;
    end
    toc;
end

frameRate = get(videoObj,'FrameRate');
implay(results,frameRate);
