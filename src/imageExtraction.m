%% Cleans console and Workspace

clc;
clear;

%% Extracts images with eyes and images without them from raw images

imagesNames = dir ('..\data\*.pgm');
imagesEyesCoordinates = dir ('..\data\*.eye');
numImages = length(imagesNames);

imagesWithEyes = zeros([64,64,2*numImages]);
imagesWithoutEyes = zeros([64,64,18*numImages]);

for i=1:numImages
    %% Gets raw image dimensions
    
    imName = imagesNames(i).name;
    im = imread(strcat('..\data\', imName));
    [y,x] = size(im);
    
    %% Gets eye coordinates
    
    eyesCoordinatesName = imagesEyesCoordinates(i).name;
    eyesCoordinatesFile = fopen(strcat('..\data\', eyesCoordinatesName));
    
    textscan(eyesCoordinatesFile,'%s %s %s %s', 1); % Needed in order to discard the headers of eyes coordinates file
    
    imCoord = textscan(eyesCoordinatesFile,'%d %d %d %d',1); 
    imCoord = double(cell2mat(imCoord));
    
    fclose(eyesCoordinatesFile);
    
    %% Extraction of images with eyes 
    
    % Eye 1 
    dist = uint16(abs(imCoord(3)-imCoord(1))*0.325);
    left_1 = max(1, imCoord(1) - dist); 
    right_1 = min(x, imCoord(1) + dist);
    up_1 = max(1, imCoord(2) - dist); 
    down_1 = min(y, imCoord(2) + dist);
    imagesWithEyes(:,:, i*2-1) = imresize(im(up_1:down_1, left_1:right_1), [64,64]);
%   figure; imshow(imagesWithEyes(:,:, i*2-1), []); % Used in debuging purposes
    
    % Eye 2
    left_2 = max(1, imCoord(3) - dist); 
    right_2 = min(x, imCoord(3) + dist);
    up_2 = max(1, imCoord(4) - dist); 
    down_2 = min(y, imCoord(4) + dist);
    imagesWithEyes(:,:, i*2) = imresize(im(up_2:down_2, left_2:right_2), [64,64]);
%   figure; imshow(imagesWithEyes(:,:, i*2), []); % Used in debuging purposes
    
    %% Extraction of images without eyes
    
    j = 0;
    while j < 18 
        % Gets a random center for a image without eyes
        r_x = randi([33,352], 1);
        r_y = randi([33,254], 1);
        if (r_x > right_1 || r_x < left_1  && r_x > right_2 || r_x < left_2) && (r_y > down_1 || r_y < up_1  && r_y > down_2 || r_y < up_2) 
                x1 = max(1, r_x - dist);
                x2 = min(x, r_x + dist);
                y1 = max(1, r_y - dist); 
                y2 = min(y, r_y + dist);
                imagesWithoutEyes(:,:,i*18-j) = imresize(im(y1:y2, x1:x2), [64,64]);
%               figure; imshow(imagesWithoutEyes(:, :, i*18-j), []); % Used in debuging purposes
                j = j + 1;          
        end
    end
end