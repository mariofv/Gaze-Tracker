clc;
clear;
%% RECOGIDA DE OJOS
imD = dir ('G:\UNI\VC\Project\Images\*.pgm');
imE = dir ('G:\UNI\VC\Project\Images\*.eye');
n = length(imD);
imOjos = zeros([64,64,2*n]);
imNoOjos = zeros([64,64,18*n]);
for i=1:n
    name = imD(i).name;
    im = imread(strcat('G:\UNI\VC\Project\Images\', name));
    [y,x] = size(im);
    
    name = imE(i).name
    fid = fopen(strcat('G:\UNI\VC\Project\Images\', name));
    textscan(fid,'%s %s %s %s',1); %tratamos la 1a linea de caracteres
    imCoord = textscan(fid,'%d %d %d %d',1); %tratamos la 2a linea de caracteres
    imCoord = double(cell2mat(imCoord));
    fclose(fid);
    
    %OJOS ---------------------------------------------------
    d = uint16(abs(imCoord(3)-imCoord(1))*0.325);
    left_1 = max(1,imCoord(1)-d); right_1 = min(x,imCoord(1)+d);
    up_1 = max(1,imCoord(2)-d); down_1 = min(y,imCoord(2)+d);
    imOjos(:,:,i*2-1) = imresize(im(up_1:down_1,left_1:right_1),[64,64]);
    %figure; imshow(imOjos(:,:,i*2-1),[]); %reducir el bucle a i=1:4 para usar
    left_2 = max(1,imCoord(3)-d); right_2 = min(x,imCoord(3)+d);
    up_2 = max(1,imCoord(4)-d); down_2 = min(y,imCoord(4)+d);
    imOjos(:,:,i*2) = imresize(im(up_2:down_2,left_2:right_2),[64,64]);
    %figure;imshow(imOjos(:,:,i*2),[]); %reducir el bucle a i=1:4 para usar
    
    %NO OJOS ------------------------------------------------
    j = 0;
    while j < 18
        r_x = randi([33,352],1);
        r_y = randi([33,254],1);
        if r_x > right_1 || r_x < left_1  && r_x > right_2 || r_x < left_2 
            if r_y > down_1 || r_y < up_1  && r_y > down_2 || r_y < up_2 
                x1 = max(1,r_x-d); x2 = min(x,r_x+d);
                y1 = max(1,r_y-d); y2 = min(y,r_y+d);
                imNoOjos(:,:,i*18-j) = imresize(im(y1:y2,x1:x2),[64,64]);
                %figure;imshow(imNoOjos(:,:,i*18-j),[]); %reducir el bucle a i=1:4 para usar
                j = j + 1;
            end
        end
    end
end