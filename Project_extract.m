clc;
clear;
%% RECOGIDA DE OJOS
imD = dir ('G:\UNI\VC\Project\Images\*.pgm');
imE = dir ('G:\UNI\VC\Project\Images\*.eye');
n = length(imD);
imOjos = zeros([64,64,n*2]);
for i=1:n
    name = imD(i).name;
    im = imread(strcat('G:\UNI\VC\Project\Images\', name));
    
    name = imE(i).name
    fid = fopen(strcat('G:\UNI\VC\Project\Images\', name));
    textscan(fid,'%s %s %s %s',1);
    imCoord = textscan(fid,'%d %d %d %d',1);
    imCoord = double(cell2mat(imCoord));
    fclose(fid);

    d = uint16(abs(imCoord(3)-imCoord(1))*0.325);
    x1 = imCoord(1)-d; x2 = imCoord(1)+d;
    y1 = max(1,imCoord(2)-d); y2 = imCoord(2)+d;
    imOjos(:,:,i*2-1) = imresize(im(y1:y2,x1:x2),[64,64]);
    %figure;imshow(imOjos(:,:,i*2-1),[]);
    x1 = imCoord(3)-d; x2 = imCoord(3)+d;
    y1 = max(1,imCoord(4)-d); y2 = imCoord(4)+d;
    imOjos(:,:,i*2) = imresize(im(y1:y2,x1:x2),[64,64]);
    %figure;imshow(imOjos(:,:,i*2),[]);
end