classdef gazeDetector
    
    properties(SetAccess = private)
        GazeClassifier
    end
    
    methods
        function obj = gazeDetector(classifier)
            obj.GazeClassifier = classifier;
        end
        
        function [personIsLooking, eyesAreLooking] = detect(obj,images)
            eyesAreLooking =  obj.GazeClassifier.classify(images);
            personIsLooking = all(eyesAreLooking);
        end
        
    end
end

