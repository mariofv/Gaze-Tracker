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
              
        function [eyesPos, clusterCentroids] = clusterMethod(obj,possibleEyesPos)
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
            
            if minimumAngle >= 20
               eyesPos = -1;
               return
            end
            
            [i,j] = find(anglesCentroids == minimumAngle);
            
            eyesPos = [clusterCentroids(i,:); clusterCentroids(j,:)];
        end


        function [eyesPos, clusterCentroids] = votingMethod(obj,possibleEyesPos, imageSize)
            x = imageSize(1);
            y = imageSize(2);
            A = zeros(x, y);
%           M = strel('disk',7);
%           M = bwdist(~M);
            M = [0 0 0 0 0 1 1 1 1 1 0 0 0 0 0;
                 0 0 0 1 1 2 2 2 2 2 1 1 0 0 0;
                 0 0 1 2 2 3 3 3 3 3 2 2 1 0 0;
                 0 1 2 2 3 4 4 4 4 4 3 2 2 1 0;
                 0 1 2 3 4 4 5 5 5 4 4 3 2 1 0;
                 1 2 3 4 4 5 6 6 6 5 4 4 3 2 1;
                 1 2 3 4 5 6 7 7 7 6 5 4 3 2 1;
                 1 2 3 4 5 6 7 8 7 6 5 4 3 2 1;
                 1 2 3 4 5 6 7 7 7 6 5 4 3 2 1;
                 1 2 3 4 4 5 6 6 6 5 4 4 3 2 1;
                 0 1 2 3 4 4 5 5 5 4 4 3 2 1 0;
                 0 1 2 2 3 4 4 4 4 4 3 2 2 1 0;
                 0 0 1 2 2 3 3 3 3 3 2 2 1 0 0;
                 0 0 0 1 1 2 2 2 2 2 1 1 0 0 0;
                 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0];

           for i = 1:size(possibleEyesPos,1)
                varX = possibleEyesPos(i,1);
             	varY = possibleEyesPos(i,2);
             	A(varX-7:varX+7,varY-7:varY+7) = A(varX-7:varX+7,varY-7:varY+7) + M;
           end
           
           S = struct2cell(regionprops(bwconncomp(A),'Centroid'));
           sS = size(S,2);
           
           clusterCentroids = zeros(sS,2);
           for i=1:sS
               clusterCentroids(i,:) = [round(S{1,i}(2)), round(S{1,i}(1))];
           end

           eyesPos = [];
           for i=1:sS-1
                for j=i+1:sS
                    if (abs(clusterCentroids(i,2) - clusterCentroids(j,2)) < 10)
                        eyesPos = [eyesPos;clusterCentroids(i,:);clusterCentroids(j,:)];
                    end
                end
           end
        end

        % Given an image it returns -1 if there is no eyes on it or their
        % position otherwise.
        function [eyesImages, eyesPos, possibleEyesPos, clusterCentroids] = detect(obj,image,method)
            [splittedImages, imageCoord] = obj.Splitter.split(image);
            prediction = obj.EyeClassifier.classify(splittedImages);
            possibleEyesPos = imageCoord(prediction,:);
            
            if size(possibleEyesPos,1) < 2
               eyesImages = [];
               eyesPos = [];
               clusterCentroids = [];
               return;
            end
            
            if method == "cluster"
                [eyesPos, clusterCentroids] = obj.clusterMethod(possibleEyesPos);
            elseif method == "voting"
                imageSize = size(image);
                [eyesPos, clusterCentroids] = obj.votingMethod(possibleEyesPos, imageSize);
            end

            eyesImages = cat(3,obj.Splitter.splitSubimage(eyesPos(1,:), image),obj.Splitter.splitSubimage(eyesPos(2,:), image));

        end
        
    end
end