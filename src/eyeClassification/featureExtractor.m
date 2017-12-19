% Features extractor, extracts features from given images.
classdef featureExtractor
       
   methods
      function obj = featureExtractor()
      end
      
      % Given an array of images it returns an array with the features of
      % that images
      function features = extractFeatures(obj,images)
        [rows,cols,numImages] = size(images);
        features = zeros([numImages, rows+cols+192]);
        for i = 1:numImages
            imageMean = sum(sum(images(:,:,i)))/(rows*cols);
            
            % This feature is the substraction of the sum of 
            % every row of the image with the mean of the whole image.
            rowMeanFeatures = sum(images(:,:,i)) - imageMean;
            
            % This feature is the substraction of the sum of 
            % every column of the image with the mean of the whole image.
            colMeanFeatures = sum(images(:,:,i),2)' - imageMean;
            
            % HOG features
            HOGFeatures = extractHOGFeatures(images(1:64,1:64,i),'CellSize',[16 16],'BlockSize',[4 4],'NumBins',12);
            
            
            features(i,:) = [rowMeanFeatures, colMeanFeatures, HOGFeatures];    
        end
      end
   end
end
