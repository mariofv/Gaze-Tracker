% Splits and image into square subimages of specified size
classdef imageSplitter
    
   properties(SetAccess = private)
      ImagesDimension
   end
   
   methods
      function obj = imageSplitter(imagesDimension)
         obj.ImagesDimension = imagesDimension;
      end
      
      % Given an image it returns a set of images extracted from it and
      % their coordinates in the original image. Coordinates represent the
      % indices of the center pixel of the subimage in the original image.
      function [splittedImages, imageCoord] = split(obj,image)
        [rows, cols] = size(image);
        splittedImages = zeros([...
            obj.ImagesDimension,...
            obj.ImagesDimension,...
            (rows-obj.ImagesDimension)*(cols-obj.ImagesDimension) ...
        ]);
        imageCoord = zeros([(rows-obj.ImagesDimension)*(cols-obj.ImagesDimension), 2]);
        k = 1;
        for i=1:(rows-obj.ImagesDimension)  
            for j=1:(cols-obj.ImagesDimension)
                up = i; 
                left = j;
                down = i+obj.ImagesDimension-1;
                right = j+obj.ImagesDimension-1;
                splittedImages(:,:, k) = image(up:down, left:right);
                imageCoord(k,:) = [floor((down-up)/2)+up, floor((right-left)/2)+left];
                k = k + 1;
            end
        end
      
      end
   end
end