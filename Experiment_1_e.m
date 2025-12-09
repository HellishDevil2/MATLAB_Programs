% 2D Filtering;
clc;
clear;
close all;

image = imread("cameraman.jpg");

fft_image = fft2(image);

fk = fspecial('disk',5); % a flat circular filter
filtered_image = imfilter(image,fk,'replicate');
downsampled_filtered_image = filtered_image(1:2:end,1:2:end);
figure(1);
imshow(downsampled_filtered_image);
output_1 = mat2gray(log(1+abs(fftshift(fft2(downsampled_filtered_image)))));
figure(2);
imshow(output_1);


down_sampled_image = image(1:2:end,1:2:end);
output_2 = mat2gray(log(1+abs(fftshift(fft2(down_sampled_image)))));
figure(3)
imshow(down_sampled_image);
figure(4);
imshow(output_2);
