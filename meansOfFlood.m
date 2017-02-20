function [red, green, blue] = meansOfFlood()
    % Get meansOfFlood as red green and blue channels %
    % means of all training image files from this test directory

    Dir = 'training\';
    % Read images from Images folder
    Imgs = dir(fullfile(Dir, '*.jpg'));
    for j=1:length(Imgs)
        Img = imread(fullfile(Dir, Imgs(j).name));  % Read image

        Img = double(Img);

        redMeans(j) = mean( reshape( Img(:,:,1), [], 1 ));
        greenMeans(j) = mean( reshape( Img(:,:,2), [], 1 ));
        blueMeans(j) = mean( reshape( Img(:,:,3), [], 1 ));

    end

    red = mean(redMeans);
    green = mean(greenMeans);
    blue = mean(blueMeans);
    
end
