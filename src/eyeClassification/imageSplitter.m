% Splits and image into square subimages of specified size
classdef imageSplitter
    
   properties(SetAccess = private)
      ImagesDimension
      SampleFrequency
   end
   
   methods
      function obj = imageSplitter(imagesDimension, sampleFrequency)
         obj.ImagesDimension = imagesDimension;
         obj.SampleFrequency = sampleFrequency;
      end
      
    function subimage = splitSubimage(obj, coord, image)
        j = coord(1)-floor(obj.ImagesDimension/2);
        i = coord(2)-floor(obj.ImagesDimension/2);
     	up = i; 
        left = j;
        down = i+obj.ImagesDimension-1;
        right = j+obj.ImagesDimension-1;
        subimage = imresize(image(up:down, left:right), [64,64]);
    end
      
      % Given an image it returns a set of images extracted from it and
      % their coordinates in the original image. Coordinates represent the
      % indices of the center pixel of the subimage in the original image.
      function [splittedImages, imageCoord] = split(obj,image)
        [rows, cols] = size(image);
        first = 1;
        for i=1:obj.SampleFrequency:(rows-obj.ImagesDimension)  
            for j=1:obj.SampleFrequency:(cols-obj.ImagesDimension)
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