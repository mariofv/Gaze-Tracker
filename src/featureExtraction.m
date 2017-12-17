%% Cleans console and Workspace

clc;
clear;

%% Extracts images with eyes and images without them from raw images

imagesNames = dir ('..\data\classifierConstructorDataset\*.pgm');
imagesEyesCoordinates = dir ('..\data\classifierConstructorDataset\*.eye');
numImagesWithEyes = 2*length(imagesNames);
numImagesWithoutEyes = 9*numImagesWithEyes;

imagesWithEyes = zeros([64,64,numImagesWithEyes]);
imagesWithoutEyes = zeros([64,64,numImagesWithoutEyes]);
imagesDist = zeros([numImages,1]);

for i=1:numImages
    % Gets raw image dimensions
    
    imName = imagesNames(i).name;
    im = imread(strcat('..\data\classifierConstructorDataset\', imName));
    [y,x] = size(im);
    
    % Gets eye coordinates
    
    eyesCoordinatesName = imagesEyesCoordinates(i).name;
    eyesCoordinatesFile = fopen(strcat('..\data\classifierConstructorDataset\', eyesCoordinatesName));
    
    textscan(eyesCoordinatesFile,'%s %s %s %s', 1); % Needed in order to discard the headers of eyes coordinates file
    
    imCoord = textscan(eyesCoordinatesFile,'%d %d %d %d',1); 
    imCoord = double(cell2mat(imCoord));
    
    fclose(eyesCoordinatesFile);
    
    % Extraction of images with eyes 
    
    dist = uint16(abs(imCoord(3)-imCoord(1))*0.325);
    imagesDist(i) = dist*2;
    
    % Eye 1 
    left = max(1, imCoord(1) - dist); 
    right = min(x, imCoord(1) + dist);
    up = max(1, imCoord(2) - dist); 
    down = min(y, imCoord(2) + dist);
    imagesWithEyes(:,:, i*2-1) = imresize(im(up:down, left:right), [64,64]);
%   figure; imshow(imagesWithEyes(:,:, i*2-1), []); % Used in debuging purposes
    
    % Eye 2
    left = max(1, imCoord(3) - dist); 
    right = min(x, imCoord(3) + dist);
    up = max(1, imCoord(4) - dist); 
    down = min(y, imCoord(4) + dist);
    imagesWithEyes(:,:, i*2) = imresize(im(up:down, left:right), [64,64]);
%   figure; imshow(imagesWithEyes(:,:, i*2), []); % Used in debuging purposes
    
    % Extraction of images without eyes
    
    j = 0;
    while j < 18 
        % Gets a random center for a image without eyes
        r_x = randi([17,368], 1);
        r_y = randi([17,270], 1);
        % Gets the distance from the random center to the eyes
        dist_1 = sqrt(((imCoord(1)-r_x)^2)+((imCoord(2)-r_y)^2));
        dist_2 = sqrt(((imCoord(3)-r_x)^2)+((imCoord(4)-r_y)^2));
        
        if (dist_1 > dist*2 && dist_2 > dist*2) 
                left = max(1, r_x - dist);
                right = min(x, r_x + dist);
                up = max(1, r_y - dist); 
                down = min(y, r_y + dist);
                imagesWithoutEyes(:,:,i*18-j) = imresize(im(up:down, left:right), [64,64]);
%               figure; imshow(imagesWithoutEyes(:, :, i*18-j), []); % Used in debuging purposes
                j = j + 1;          
        end
    end
end

%% Splits the images in training dataset and testing dataset

% Randomize the sample

eyesIndex = randsample(numImagesWithEyes, numImagesWithEyes);
noEyesIndex = randsample(numImagesWithoutEyes, numImagesWithoutEyes);

% Training and testing dataset

numTrainingEyesImages = floor(numImagesWithEyes*7/10);
numTrainingNoEyesImages = floor(numImagesWithoutEyes*7/10);

trainingDataset = cat(3,imagesWithEyes(:,:,eyesIndex(1:numTrainingEyesImages)), imagesWithoutEyes(:,:,noEyesIndex(1:numTrainingNoEyesImages)));
testingDataset = cat(3,imagesWithEyes(:,:,eyesIndex(numTrainingEyesImages+1:end)), imagesWithoutEyes(:,:,noEyesIndex(numTrainingNoEyesImages+1:end)));

%% Feature extraction

% Creates the training feature matrix

[~,~,trainingSize] = size(trainingDataset);
trainingFeatures = zeros([trainingSize, 128+1764]);

for i = 1:trainingSize
    imageMean = sum(sum(trainingDataset(:,:,i)))/4096;
    HOGFeatures = extractHOGFeatures(trainingDataset(:,:,i));
    trainingFeatures(i,:) = [sum(trainingDataset(:,:,i)) - imageMean, sum(trainingDataset(:,:,i),2)' - imageMean,HOGFeatures];    
end

% Creates the training classes vector

trainingClasses = [repmat('E',1,numTrainingEyesImages), repmat('N',1,numTrainingNoEyesImages)]';

% Creates the testing feature matrix

[~,~,testingSize] = size(testingDataset);
testingFeatures = zeros([testingSize, 128+1764]);

for i = 1:testingSize
    imageMean = sum(sum(testingDataset(:,:,i)))/4096;
    HOGFeatures = extractHOGFeatures(testingDataset(:,:,i));
    testingFeatures(i,:) = [sum(testingDataset(:,:,i)) - imageMean, sum(testingDataset(:,:,i),2)' - imageMean,HOGFeatures];    
end

% Creates the testing classes vector

numTestingEyesImages = numImagesWithEyes - numTrainingEyesImages;
numTestingNoEyesImages = numImagesWithoutEyes - numTrainingNoEyesImages;

testingClasses = [repmat('E',1,numTestingEyesImages), repmat('N',1,numTestingNoEyesImages)]';

%% Saves the features and classes of training and testing datasets

save('../data/datasetFeatures.mat', 'trainingFeatures', 'trainingClasses', 'testingFeatures', 'testingClasses'); 
    