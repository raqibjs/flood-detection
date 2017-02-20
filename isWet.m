function [z] = isWet( onePix )
%% This is our function%%

% Get list of all BMP files in this directory
% DIR returns as a structure array.  You will need to use () and . to get
% the file names.

imagefiles = dir('\test\*.jpg');

nfiles = length(imagefiles);    % Number of files found

z = 0;
for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   im = imread(currentfilename);
   
   [row col] = size(im);
    
    for x=1:1:row
        for y=1:1:col
            if(im(x, y) == onePix)
                z=1;
                break;
            else
                z=0;
            end
        end
    end
    
    if(z==1)
        break;
    end
end