function [features] = featureSetExtractor(images)
    [~,~,imagesSize] = size(images);
    features = zeros([imagesSize,128+144+128]); %sum row/colum + HOG + diag

    for i = 1:imagesSize
        imageMean = sum(sum(images(:,:,i)))/4096;
        HOGFeatures = extractHOGFeatures(images(1:64,1:64,i),'CellSize',[16 16],'BlockSize',[4 4]);
        diagonal = [diag(fliplr(images(1:64,1:64,i)))',diag(images(1:64,1:64,i))'];
        diagonal = diagonal/min(min(diagonal));
        features(i,:) = [sum(images(:,:,i)) - imageMean, sum(images(:,:,i),2)' - imageMean,HOGFeatures,diagonal];    
    end
end

