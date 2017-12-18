% Features extractor, extracts features from given images.
classdef featureExtractor
       
   methods
      function obj = featureExtractor()
      end
      
      % Given an array of images it returns an array with the features of
      % that images
      function features = extractFeatures(obj,images)
        [rows,cols,numImages] = size(images);
        features = zeros([numImages, 2*(rows+cols)+144]);
        for i = 1:numImages
            imageMean = sum(sum(images(:,:,i)))/(rows*cols);
            HOGFeatures = extractHOGFeatures(images(1:64,1:64,i),'CellSize',[16 16],'BlockSize',[4 4]);
            diagonal = [diag(fliplr(images(1:64,1:64,i)))',diag(images(1:64,1:64,i))'];
            diagonal = diagonal/min(min(diagonal));
            features(i,:) = [sum(images(:,:,i)) - imageMean, sum(images(:,:,i),2)' - imageMean, HOGFeatures, diagonal];    
        end
      end
   end
end
