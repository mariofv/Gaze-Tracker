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
        first = 1;
        for i=1:4:(rows-obj.ImagesDimension)  
            for j=1:4:(cols-obj.ImagesDimension)
                up = i; 
                left = j;
                down = i+obj.ImagesDimension-1;
                right = j+obj.ImagesDimension-1;
                if (first == 1) 
                    splittedImages = imresize(image(up:down, left:right), [64,64]);
                    imageCoord =  [floor((right-left)/2)+left, floor((down-up)/2)+up];
                    first = 0;
                else
                    splittedImages = cat(3, splittedImages, imresize(image(up:down, left:right), [64, 64]));
                    imageCoord = cat(1, imageCoord, [floor((right-left)/2)+left, floor((down-up)/2)+up]);
                end 
            end
        end
      
      end
   end
end