clc;
clear all;
close all;

[redMean, greenMean, blueMean] = meansOfFlood();

im = imread('test/flood6.jpg');
[row col dim] = size(im);
im = double(im);

red = im(:, :, 1);
green = im(:, :, 2);
blue = im(:, :, 3);

for x=1:1:row
    for y=1:1:col
        redVal = red(x,y)/redMean;
        greenVal = green(x,y)/greenMean;
        blueVal = blue(x,y)/blueMean;
        if((redVal>0.8 && redVal<1.2) && (greenVal>0.8 && greenVal<1.2) && (blueVal>0.8 && blueVal<1.2))
            newIm(x,y) = 1;
        else
            newIm(x,y) = 0;
        end
    end
end

subplot(1,2,1);
imshow(uint8(im));
subplot(1,2,2);
imshow(newIm);
