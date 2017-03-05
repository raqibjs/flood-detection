clc;
clear all;
close all;

% Calculate mean from traing water images
[redMean, greenMean, blueMean] = meansOfFlood();

videoObj = VideoReader('no-water2.mp4');

% Get all frame
nframes = get(videoObj, 'NumberOfFrames');

% Take one frame to make a result container
I = read(videoObj, 1);
% Result container
results = zeros([size(I,1) size(I,2) 3 nframes], class(I));

% For every frame
for k = 1 : nframes
    img = read(videoObj, k);
    [row col dim] = size(img);
    im = double(img);

%     imGray = rgb2gray(img);
%     edgeIm = edge(imGray, 'canny');

    red = im(:, :, 1);
    green = im(:, :, 2);
    blue = im(:, :, 3);

    for x=1:1:row
        for y=1:1:col
            redVal = abs(red(x,y) - redMean);
            greenVal = abs(green(x,y) - greenMean);
            blueVal = abs(blue(x,y) - blueMean);
            sd = 50;
            if((redVal <= sd) && (greenVal <= sd) && (blueVal <= sd))
                biIm(x,y) = 1;
            else
                biIm(x,y) = 0;
            end
        end
    end

    % Remove noise effect and narrow connection
    numberOfPixels = numel(biIm);
    
    sedisk = strel('disk',2);
    openedIm = imopen(biIm, sedisk);
    
    % Filling small holes for better result
    closedIm = imclose(openedIm, sedisk);
    
    % Delete small objects
    removeTh = round(numberOfPixels - numberOfPixels * 92 / 100); % remove when pixel number 8% less than total pixel; 
    filteredIm = bwareaopen(closedIm, removeTh);

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
end

frameRate = get(videoObj,'FrameRate');
implay(results,frameRate);
