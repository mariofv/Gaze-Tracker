%% Cleans console and Workspace

clc;
clear;

%% Extracts images with eyes and images without them from raw images

imagesNames = dir ('..\data\classifierConstructorDataset\*.pgm');
imagesEyesCoordinates = dir ('..\data\classifierConstructorDataset\*.eye');
numImages = length(imagesNames);

for i=1:70
    %% Gets raw image dimensions
    
    imName = imagesNames(i).name;
    im = imread(strcat('..\data\classifierConstructorDataset\', imName));
    subplot(7,10,i); imshow(im,[]);
end
