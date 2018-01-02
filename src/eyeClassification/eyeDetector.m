% Used to detect the pressence of eyes in an image
classdef eyeDetector
    
    properties(SetAccess = private)
        EyeClassifier
        Splitter
    end
   
    methods
        function obj = eyeDetector(classifier, splitter)
            obj.EyeClassifier = classifier;
            obj.Splitter = splitter;
        end
              
        % Given an image it returns -1 if there is no eyes on it or their
        % position otherwise.
        function eyesPos = detect(obj,image)
            [splittedImages, imageCoord] = obj.Splitter.split(image);
            prediction = obj.EyeClassifier.classify(splittedImages);
            possibleEyesPos = imageCoord(prediction,:);

            % Divides possible eyes positions into clusters using hiearerchical
            % clustering and finds the num of clusters.
            Y = pdist(possibleEyesPos); % Distance information
            Z = linkage(Y); % Linkage
            k = max(cluster(Z,'cutoff',5,'criterion','distance')); % Gets the number of clusters

            % Finds clusters centroids
            [~,clusterCentroids] = kmeans(possibleEyesPos, k);
            clusterCentroids = round(clusterCentroids);

            % Gets the most two horizontal aligned clusters
            anglesCentroids = zeros(size(clusterCentroids,1));
            anglesCentroids(:,:) = 180; % Cause not all angles are being computated, initializes them to a impossible value

            for i=1:size(clusterCentroids,1)
                for j=i+1:size(clusterCentroids,1)
                    point1 = clusterCentroids(i,:);
                    point2 = clusterCentroids(j,:);

                    p = polyfit([point1(1), point2(1)], [point1(2), point2(2)], 1); % Line between 2 centroids
                    slope = p(1); % Gets slope of the line
                    anglesCentroids(i,j) = abs(rad2deg(atan(slope))); % Gets the angle of the line
                end
            end

            minimumAngle = min(min(anglesCentroids));
            
            if minimumAngle == 180
               eyesPos = -1;
               return
            end
            
            [i,j] = find(anglesCentroids == minimumAngle);
            
            eyesPos = [clusterCentroids(i,:); clusterCentroids(j,:)];
        end
        
    end
end