a_1 = ones(4,4)

% a_1(sub2ind(size(a_1),2,3))='R'
fid=fopen('/Users/chengpeng/Desktop/课程二/IP/Project/test2.m','wt') 
img1 = imread('images2 2/proj1_1.png');
filter=fspecial('average',5);
flag=imfilter(img1,filter);
YCBCR = rgb2ycbcr(flag);%Convert to YCbcr space

%The threshold value of each channel is used to binarize it
Y_MIN = 0;  Y_MAX = 256;
Cb_MIN = 100;   Cb_MAX = 127;
Cr_MIN = 138;   Cr_MAX = 170;
threshold=roicolor(YCBCR(:,:,1),Y_MIN,Y_MAX)&roicolor(YCBCR(:,:,2),Cb_MIN,Cb_MAX)&roicolor(YCBCR(:,:,3),Cr_MIN,Cr_MAX);

%Morphological treatment: corrosion, expansion, cavity filling
erodeElement = strel('square', 3) ;
dilateElement=strel('square', 8) ;
threshold = imerode(threshold,erodeElement);%corrosion
threshold=imdilate(threshold, dilateElement);%expansion
threshold=imfill(threshold,'holes');%cavity filling


%Selection of connected regions
gray_img = rgb2gray(flag);
T = graythresh(gray_img); %You get a threshold
bw_img = im2bw(gray_img, T); %Convert it to a binary image
img_reg = regionprops(bw_img,  'area', 'boundingbox');
areas = [img_reg.Area];%The total number of pixels in each area
rects = cat(1,  img_reg.BoundingBox);%The smallest rectangle of each part
subplot(2,3,1);
imshow(flag);
for i = 1:size(rects, 1)     %Get number of rows
    rectangle('position', rects(i, :), 'EdgeColor', 'r');
end

flag_hsv = rgb2hsv(flag); % Convert the image's RGB color space to HSV color space 
flag_new1 = 255*ones(size(flag));% Create a white image and extract the specific color here
flag_new_hsv1 = rgb2hsv(flag_new1);% Transfer this image to the HSV color space
flag_new2 = 255*ones(size(flag));
flag_new_hsv2 = rgb2hsv(flag_new2);
flag_new3 = 255*ones(size(flag));
flag_new_hsv3 = rgb2hsv(flag_new3);
flag_new4 = 255*ones(size(flag));
flag_new_hsv4 = rgb2hsv(flag_new4);

%Extract the red part
[row, col] = ind2sub(size(flag_hsv),find((flag_hsv(:,:,1)>0.00...
& flag_hsv(:,:,1)< 0.03) |( flag_hsv(:,:,1)>0.95 & flag_hsv(:,:,1)<1)&flag_hsv(:,:,2)>0.16 & flag_hsv(:,:,3)>0.18));
% if row>31||row<33 && col>31||col<33

% Find the red pixel of the image
% Copy the red pixels from the image to the white image you just created
for i = 1 : length(row)
    flag_new_hsv1(row(i),col(i),:) = flag_hsv(row(i),col(i),:);
%     a(row(i),col(i)) = 'R';
%      a_1(sub2ind(size(a_1),row(i)/256,col(i)/256))= 2
%     M = mode(row(i)) 
%     disp(row(M))

% if row(i)==32 && col(i)==96x
%     a_1(sub2ind(size(a_1),1,2))=2
% end
% if row(i)==32 && col(i)==160
%     a_1(sub2ind(size(a_1),1,3))=2
% end
% if row(i)==32 && col(i)==224
%     a_1(sub2ind(size(a_1),1,4))=2
% end

end

flag_red = hsv2rgb(flag_new_hsv1);% The extracted red color will be transformed into RGB space for display
subplot(2,3,2);
imshow(flag_red);title('Red');

%Extract the yellow part
[row, col] = ind2sub(size(flag_hsv),find(flag_hsv(:,:,1)>0.11...
& flag_hsv(:,:,1)< 0.20 & flag_hsv(:,:,2)>0.16 & flag_hsv(:,:,3)>0.18));
% Find the yellow pixel of the image
% Copy the yellow pixels from the image to the white image you just created
for i = 1 : length(row)
    flag_new_hsv2(row(i),col(i),:) = flag_hsv(row(i),col(i),:);
%     if row(i)>31||row(i)<33 && col(i)>31||col(i)<33
%         a_1(sub2ind(size(a_1),1,1))=2
%     end
end
flag_yellow = hsv2rgb(flag_new_hsv2);% The extracted yellow color will be transformed into RGB space for display
subplot(2,3,3);
imshow(flag_yellow);title('Yellow');

%Extract the green part
[row, col] = ind2sub(size(flag_hsv),find(flag_hsv(:,:,1)>0.20...
& flag_hsv(:,:,1)< 0.48 & flag_hsv(:,:,2)>0.16 & flag_hsv(:,:,3)>0.18));
% Find the green pixel of the image
% Copy the green pixels from the image to the white image you just created
for i = 1 : length(row)
    flag_new_hsv3(row(i),col(i),:) = flag_hsv(row(i),col(i),:);
end
flag_green = hsv2rgb(flag_new_hsv3);% The extracted green color will be transformed into RGB space for display
subplot(2,3,4);
imshow(flag_green);title('Green');

%Extract the blue part
[row, col] = ind2sub(size(flag_hsv),find((flag_hsv(:,:,1)>0.50...
& flag_hsv(:,:,1)< 0.80)&flag_hsv(:,:,2)>0.16 & flag_hsv(:,:,3)>0.18));
% Find the blue pixel of the image
% Copy the blue pixels from the image to the white image you just created
for i = 1 : length(row)
    flag_new_hsv4(row(i),col(i),:) = flag_hsv(row(i),col(i),:);
end
flag_blue = hsv2rgb(flag_new_hsv4);% The extracted blue color will be transformed into RGB space for display
subplot(2,3,5);
imshow(flag_blue);title('Blue');
%%%%%%%

flag_hsv = rgb2hsv(flag); % Convert the image's RGB color space to HSV color space    
flag_new = 255*ones(size(flag));% Create a white image and extract the specific color here
flag_new_hsv = rgb2hsv(flag_new);% Transfer this image to the HSV color space

[row, col] = ind2sub(size(flag_hsv),find( flag_hsv(:,:,3)<0.32));% Find the green pixel in the image
for i = 1 : length(row)
    flag_new_hsv(row(i),col(i),:) = flag_hsv(row(i),col(i),:);
end
flag_black = hsv2rgb(flag_new_hsv);

gray_black = rgb2gray(flag_black);
T = graythresh(gray_black); % You get a threshold
bw_black = im2bw(gray_black, T); % Convert it to a binary image
dbw_black=imcomplement(bw_black);%The binary image is inverted

img_reg = regionprops(dbw_black,  'basic');
areas = [img_reg.Area];%The total number of pixels in each area
rects = cat(1,  img_reg.BoundingBox);%The smallest rectangle of each part

subplot(2,3,6);
imshow(flag);
for i = 1:size(rects, 1)     %Get number of rows
    rectangle('position', rects(i, :), 'EdgeColor', 'b');
end
text(0,0, 'black','color','blue','FontSize',16);

% matrixplot(a_1);

 fprintf(fid,'%d %d %d\n',a_1') 


