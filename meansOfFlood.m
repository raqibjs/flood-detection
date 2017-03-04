function [red, green, blue] = meansOfFlood()
    % Get meansOfFlood as red green and blue channels %
    % means of all training image files from this test directory

    Dir = 'training\';
    % Read images from Images folder
    Imgs = dir(fullfile(Dir, '*.jpg'));
    for i=1:length(Imgs)
        Img = imread(fullfile(Dir, Imgs(i).name));  % Read image

        Img = double(Img);

        redMeans(i) = mean( reshape( Img(:,:,1), [], 1 ));
        greenMeans(i) = mean( reshape( Img(:,:,2), [], 1 ));
        blueMeans(i) = mean( reshape( Img(:,:,3), [], 1 ));

    end

    red = mean(redMeans);
    green = mean(greenMeans);
    blue = mean(blueMeans);
    
end
