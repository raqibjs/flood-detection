function [ x, y ] = Udemy( im )
    %UNTITLED Summary of this function goes here
    % Detailed explanation goes here
    [row col byt] = size(im); %taking size of image according to rows and coloumns (note)
    a = im(:,:,1);% allocating only Red components
    b = im(:,:,2);% allocating only Green components
    c = im(:,:,3);% allocating only Blue components
    a = double(a); %changing data type
    b = double(b); % REMOVE and SEE the DIFFERENCE
    c = double(c);
    for x = 1:1:row % till end of rows)
        for y = 1:1:col %till end of Coloumns
            new(x,y) = (a(x,y)+b(x,y)+c(x,y))/3; % diving each pixel value with 3
            new1(x,y) = 0.3*a(x,y)+0.59*b(x,y)+0.11*c(x,y); %for Conversion Standard Format
        end
    end
    x = uint8(new);
    y = uint8(new1);
end