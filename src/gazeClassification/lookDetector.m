classdef lookDetector
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess = private)
        ClassifierTree
        Splitter
    end
    
    methods
        function obj = lookDetector(classifier)
            obj.ClassifierTree = classifier;
        end
        
        function lookPos = detect(obj,img,unclassifiedLookingPos)
            lenght = size(unclassifiedLookingPos);
            dist = 32/2;
            [y,x] = size(img);
            lookPos = [];
            featureExtractor = featureExtractorLook();
            for i=1:lenght(1)
                left = max(1, unclassifiedLookingPos(i,1) - dist); 
                right = min(x, unclassifiedLookingPos(i,1) + dist);
                up = max(1, unclassifiedLookingPos(i,2) - dist); 
                down = min(y, unclassifiedLookingPos(i,2) + dist);
                
                imageWithEyes = imresize(img(up:down, left:right), [64,64]);
                imageFeatures = featureExtractor.extractFeaturesHOG(imageWithEyes);
                prediction = cell2mat(predict(obj.ClassifierTree,imageFeatures));
                if prediction == 'E'
                    lookPos = [lookPos;unclassifiedLookingPos(i,:)];
                end
            end
        end
    end
end

