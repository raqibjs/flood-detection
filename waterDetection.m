clc;
clear all;
close all;

[redMean, greenMean, blueMean] = meansOfFlood();

trafficObj = VideoReader('water4.mp4');

nframes = get(trafficObj, 'NumberOfFrames');
I = read(trafficObj, 1);
results = zeros([size(I,1) size(I,2) 3 nframes], class(I));

for k = 1 : nframes
    img = read(trafficObj, k);
    [row col dim] = size(img);

    im = double(img);

    imGray = rgb2gray(img);
    edgeIm = edge(imGray, 'canny');

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

%     sedisk = strel('disk',2);
%     closedIm = imclose(biIm, sedisk);

    numberOfPixels = numel(biIm);
    removeTh = round(numberOfPixels - numberOfPixels * 90 / 100); % remove when pixel number 20% less than total pixel;
    filteredIm = bwareaopen(biIm, removeTh);

    for x=1:1:row
        for y=1:1:col
            if(filteredIm(x,y) > 0)
                red(x,y) = red(x,y);
                green(x,y) = green(x,y);
                blue(x,y) = blue(x,y);
            else
                red(x,y) = 0;
                green(x,y) = 0;
                blue(x,y) = 0;
            end
        end
    end
    newIm = cat(3, red, green, blue);
     
     
     results(:,:,:,k) = newIm;
end

frameRate = get(trafficObj,'FrameRate');
implay(results,frameRate);