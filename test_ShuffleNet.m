close all; 
clear; 
clc;

load net

I = imread('C:\Users\mlghost\Documents\MATLAB\final_project\PR-Dataset#2\IMG_0283 (11-7-2019 10-23-40 AM)\img\IMG_0283 151.jpg');
I = I(280:1920 - 560,:,:);
I = im2double(imresize(I,[input_dim,input_dim]));
disp(net);
YPredicted = predict(net,I);

x = zeros(1,13);
y = zeros(1,13);

for i=1:13
  y(i) = YPredicted(2*i);
  x(i) = YPredicted(2*i-1);
 
end

imshow(I);
hold on
scatter(x,y);
