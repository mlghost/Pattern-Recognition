image_names = dir('C:\Users\mlghost\Documents\MATLAB\final_project\PR-Dataset#2\IMG_0283 (11-7-2019 10-23-40 AM)\img\*.jpg');
for i=1:length(image_names)
  name = image_names(i);
  path = strcat(strcat(image_names(i).folder,'\'), image_names(i).name);
  I = imread(path);
  I = I(280:1920 - 560,:,:);
  imshow(I);
  
end