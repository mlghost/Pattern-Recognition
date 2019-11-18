
image_dir = 'C:\Users\mlghost\Documents\MATLAB\final_project\PR-Dataset#2\IMG_0283 (11-7-2019 10-23-40 AM)\img\';
annotation_dir = 'C:\Users\mlghost\Documents\MATLAB\final_project\PR-Dataset#2\IMG_0283 (11-7-2019 10-23-40 AM)\ann\';

im_names = dir(strcat(image_dir,'*.jpg'));

for i=1:length(im_names)
  
  name = im_names(i);
  image_name = strcat(strcat(image_dir,'\'),name.name);
  json_name = strcat(strcat(annotation_dir,'\'), strcat(name.name,'.json'));

  I = imread(image_name);
  I = I(280:1920 - 560,:,:);
  
  
  fid = fopen(json_name); 
  raw = fread(fid,inf); 
  str = char(raw'); 
  fclose(fid);
  val = jsondecode(str);
  n = val.objects;
  
  x = zeros(1,13);
  y = zeros(1,13);
  for j = 1:13
    x(j) = (n(j).points.exterior(1)) * 227/1080;
    y(j) = (n(j).points.exterior(2) - 280) * 227/1080;
    
  end
  imshow(im2double(imresize(I,[224,224])));
  hold on
  scatter(x,y);
  hold off
  pause(0.01)
end