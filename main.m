%% Main function for water logged area detection %%
%%

clc;
clear all;
close all;
% Read mean from training images
[redMean, greenMean, blueMean] = meansOfFlood();

tic;

img = imread('no-water2.png');
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
disp('Water Found!');
toc;

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

subplot(1,2,1);
imshow(uint8(img));
title('Input');
subplot(1,2,2);
imshow(uint8(newIm));
title('Output');

