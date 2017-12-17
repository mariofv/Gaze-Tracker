% Eye classifier, tells us whether an image contains and eye or not.
classdef eyeClassifier
    
   properties(SetAccess = private)
      Model
      FeatureExtractor
      EyesImages
      Labels
      Scores
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
        [obj.Labels, obj.Scores] = predict(obj.Model, features);
        prediction = cell2mat(obj.Labels)=='E';
        
        obj.EyesImages = images(:,:,prediction);
      end
      
      function eyesImages = getEyesImages(obj)
        eyesImages = obj.getEyesImages;
      end
   end
   
end