% Eye classifier, tells us whether an image contains and eye or not.
classdef eyeClassifier
    
   properties(SetAccess = private)
      Model
   end
   
   methods
      function obj = eyeClassifier(model)
         obj.Model = model;
      end
      
      % Given an array of images it returns an array indicatin whether
      % there is an eye on the image (TRUE) or not (FALSE)
      function prediction = classify(obj,images)
        [labels, ~] = predict(obj.Model, images);
        [~,~,sz] = size(labels);
        prediction = false(sz, 1);
        prediction(labels=='E') = TRUE;
      end
   end
end