% Eye classifier, tells us whether an image contains and eye or not.
classdef eyeClassifier
    
   properties(SetAccess = private)
      Model
      FeatureExtractor
   end
   
   methods
      function obj = eyeClassifier(model, featureExtractor)
         obj.Model = model;
         obj.FeatureExtractor = featureExtractor;
      end
      
      % Given an array of images it returns an array indicatin whether
      % there is an eye on the image (TRUE) or not (FALSE)
      function prediction = classify(obj,images)
        features = obj.FeatureExtractor.extractFeatures(images);
        [labels, ~] = predict(obj.Model, features);
        [~,~,sz] = size(labels);
        prediction = false(sz, 1);
        prediction(labels=='E') = true;
      end
   end
end