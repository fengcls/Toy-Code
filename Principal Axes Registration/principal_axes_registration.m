function [] = principal_axes_registration() % in case you need to specify any inputs
% some code to get you started. 
close all;clear;clc
image = im2bw(imread('tree_outline.jpg'),0);
image = abs(image - 1) * 255;

[x_i,y_i]=size(image);


%% transform
temp_rand = rand(3,4);
rotation_angle = temp_rand(1) * 360; %rotation from 0 - 360
rotation_flag = 1;
if (rotation_angle>180)
   rotation_flag = 0;
end;
scaling_factor = temp_rand(2) * 0.2 + 0.4; %scaling from 0.4 - 0.6
x_translation = floor((temp_rand(3)) * size(image,1)*1/8) %translation from -0.125 to +0.125
y_translation = floor((temp_rand(4)) * size(image,2)*1/8) %translation from -0.125 to +0.125
% to make sure that x and y translations aren't too large

resized_image = imresize(image, scaling_factor);
rotated_image = imrotate(resized_image, rotation_angle, 'bilinear');
new_image = zeros( 3 * size(image));
start_x = x_translation + size(image,1) + 1;
start_y = y_translation + size(image,2) + 1;
new_image(start_x:start_x + size(rotated_image,1) - 1,start_y:start_y + size(rotated_image,2) - 1) = rotated_image;
new_image = new_image(size(image,1) + 1: 2 * size(image,1), size(image,2) + 1: 2 * size(image,2));


%% centroid and inertia matrix
centroid_image1 = centroid_calculate(image);
centroid_image2 = centroid_calculate(new_image);

[x_mg1,y_mg1]=meshgrid(1:size(image,2),1:size(image,1));

Ixx1 = sum(sum(((y_mg1-centroid_image1(2)).^2.*image)));
Iyy1 = sum(sum(((x_mg1-centroid_image1(1)).^2.*image)));
Ixy1 = sum(sum(((x_mg1-centroid_image1(1)).*(y_mg1-centroid_image1(2)).*image)));

% I1 = [Iyy1 -Ixy1;-Ixy1 Ixx1];
I1 = [Ixx1 -Ixy1;-Ixy1 Iyy1];
[pa_1,~] = eig(I1);
% y1 eigenvalue, two principal moments
roots([1,-Ixx1-Iyy1,Ixx1*Iyy1-Ixy1^2])

[x_mg2,y_mg2]=meshgrid(1:size(new_image,2),1:size(new_image,1));

Ixx2 = sum(sum(((y_mg2-centroid_image2(2)).^2.*new_image)));
Iyy2 = sum(sum(((x_mg2-centroid_image2(1)).^2.*new_image)));
Ixy2 = sum(sum(((x_mg2-centroid_image2(1)).*(y_mg2-centroid_image2(2)).*new_image)));

% I2 = [Iyy2 -Ixy2;-Ixy2 Ixx2];
I2 = [Ixx2 -Ixy2;-Ixy2 Iyy2];
[pa_2,~] = eig(I2);


%% rotation angle
pa_tmp = pa_1;
pa_1(1,:)=pa_1(2,:);
pa_1(2,:)=pa_tmp(1,:);

pa_tmp = pa_2;
pa_2(1,:)=pa_2(2,:);
pa_2(2,:)=pa_tmp(1,:);

% angl1 = atan2(pa_1(2),pa_1(4))/pi*180;
% angl2 = atan2(pa_2(2),pa_2(4))/pi*180;

if pa_1(2)<0
   angl1 = -acos(pa_1(1));
else
   angl1 = acos(pa_1(1));
end;
angl1 = angl1/pi*180;

if pa_2(2)<0
   angl2 = -acos(pa_2(1));
else
   angl2 = acos(pa_2(1));
end;
angl2 = angl2/pi*180;


angle_diff = angl1-angl2;
rot_angle = angle_diff;

%% transform back
centroid_calculate(new_image)

% shift the center of the new image to the origin
new_image_shift_mid = circshift(new_image,...
    round(([x_i/2,y_i/2]-[centroid_image2(2),centroid_image2(1)])));
    % centroid_calculate(new_image_shift_mid)-[size(new_image_shift_mid,2) size(new_image_shift_mid,1)]/2

% rotate
new_image_shift_mid_rotate = imrotate(new_image_shift_mid,...
    rotation_flag*180+rot_angle,'bilinear');
    % centroid_calculate(new_image_shift_mid_rotate)-[size(new_image_shift_mid_rotate,2) size(new_image_shift_mid_rotate,1)]/2

% resize
fs = sqrt(sum(image(:))/sum(new_image(:)));
new_image_shift_mid_rotate_resize = imresize(new_image_shift_mid_rotate,fs);

% shift the origin to the center of the original image
new_image_shift_mid_rotate_resize_shift = circshift(...
    new_image_shift_mid_rotate_resize,...
    round((-[x_i/2,y_i/2]+[centroid_image1(2),centroid_image1(1)])));

% crop
[x_r,y_r]=size(new_image_shift_mid_rotate_resize_shift);
new_image_shift_mid_rotate_resize_shift_crop = ...
    new_image_shift_mid_rotate_resize_shift...
    (round((x_r-x_i)/2): round((x_r+x_i)/2), round((y_r-y_i)/2): round((y_r+y_i)/2));

% erode the image to make it thinner
se = strel('disk',3);
new_image_shift_mid_rotate_resize_shift_crop_erode = imerode(new_image_shift_mid_rotate_resize_shift_crop,se);


%% plot
figure;
subplot(241);imshow(image); title('Original')
subplot(242);imshow(new_image);title('Transformed')
subplot(243);imshow(new_image_shift_mid);title('Shifted the center to the origin')
subplot(244);imshow(new_image_shift_mid_rotate);title('Rotate back')
subplot(245);imshow(new_image_shift_mid_rotate_resize);title('Resize')
subplot(246);imshow(new_image_shift_mid_rotate_resize_shift);title('Shift the origin to the center of original image')
subplot(247);imshow(new_image_shift_mid_rotate_resize_shift_crop);title('crop')
subplot(248);imshow(new_image_shift_mid_rotate_resize_shift_crop_erode);title('erode')


function [centroid] = centroid_calculate(input_pics)

x_grid = 1:size(input_pics,2);
x_grid = repmat(x_grid,size(input_pics,1),1);
y_grid = 1:size(input_pics,1);
y_grid = repmat(y_grid',1,size(input_pics,2));

centroid = zeros(1,2);
centroid(1) = sum(sum(x_grid .* input_pics)) / sum(sum(input_pics));
centroid(2) = sum(sum(y_grid .* input_pics)) / sum(sum(input_pics));