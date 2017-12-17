% Used to detect the pressence of eyes in an image
classdef eyesDetector
    
   properties(SetAccess = private)
      EyeClassifier
      Splitter
   end
   
   methods
      function obj = eyesDetector(classifier, splitter)
         obj.EyeClassifier = classifier;
         obj.Splitter = splitter;
      end
      
      % Given an image it returns -1 if there is no eyes on it or their
      % position otherwise.
      function eyesPos = detect(obj,image)
         [splittedImages, imageCoord] = obj.Splitter.split(image);
         prediction = obj.EyeClassifier.classify(splittedImages);
         eyesPos = imageCoord(prediction,:);
      end
      
   end
end