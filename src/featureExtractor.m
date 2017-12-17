% Features extractor, extracts features from given images.
classdef featureExtractor
       
   methods
      function obj = featureExtractor()
      end
      
      % Given an array of images it returns an array with the features of
      % that images
      function features = extractFeatures(obj,images)
        [rows,cols,numImages] = size(images);
        features = zeros([numImages, rows+cols+1764]);
        for i = 1:numImages
            imageMean = sum(sum(images(:,:,i)))/(rows*cols);
            features(i,:) = [sum(images(:,:,i)) - imageMean, sum(images(:,:,i),2)' - imageMean, extractHOGFeatures(images(:,:,i))];    
        end
      end
   end
end
