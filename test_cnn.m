close all; 
clear; 
clc;
load digitsNet
% ---------------------  Preparing Input Data  ---------------------

% TODO-List
% X,Y
% X-train , X-test , Y-train, Y-test, X-validation, Y-Validation

img_dir = 'C:\Users\mlghost\Documents\MATLAB\final_project\PR-Dataset#2\IMG_0283 (11-7-2019 10-23-40 AM)\img\';
ann_dir = 'C:\Users\mlghost\Documents\MATLAB\final_project\PR-Dataset#2\IMG_0283 (11-7-2019 10-23-40 AM)\ann\';
input_dim = 224;

im_names = dir(strcat(img_dir,'*.jpg'));

%X = cell(1,length(im_names));
X = zeros(input_dim,input_dim,3,length(im_names));
%Y = cell(1,length(im_names));
Y = zeros(26,length(im_names));


order = py.dict(pyargs('Head',1,'Left Hand',2,'Left Elbow',3,'Left Shoulder',4,'Chest',5,'Right Shoulder',6,'Right Elbow',7,'Right Hand',8,'Stomach',9,'Left Knee',10,'Right Knee',11, 'Left Foot', 12,'Right Foot',13));

for i=1:length(im_names)
  
  name = im_names(i);
  image_name = strcat(strcat(img_dir,'\'),name.name);
  json_name = strcat(strcat(ann_dir,'\'), strcat(name.name,'.json'));

  I = imread(image_name);
  I = I(280:1920 - 560,:,:);
  I = im2double(imresize(I,[input_dim,input_dim]));
  
  fid = fopen(json_name); 
  raw = fread(fid,inf); 
  str = char(raw'); 
  fclose(fid);
  val = jsondecode(str);
  n = val.objects;

  vector = zeros(1,26);
  for j = 1:13
    vector(order{n(j).classTitle}*2 -1) = (n(j).points.exterior(1)) * input_dim/1080;
    vector(order{n(j).classTitle}*2) = (n(j).points.exterior(2) - 280) * input_dim/1080;
  end
  %X{i} = I;
  %Y{i} = vector;
  X(:,:,:,i) = I;
  Y(:,i) = vector;
end

XTrain = X(:,:,:,1:140);
XValidation = X(:,:,:,141:end);

YTrain = Y(:,1:140);
YValidation = Y(:,141:end);

disp(size(XValidation));
disp(size(YValidation));


% ------------- Defining the Convolutional Neural Network -------------


layers = net.Layers;
[XTrain,~,~] = digitTrain4DArrayData;
[XValidation,~,~] = digitTest4DArrayData;
numResponses = 26;
analyzeNetwork(net);
layers = [
    layers(1:12)
    fullyConnectedLayer(numResponses)
    regressionLayer];
  
%layers(1:12) = freezeWeights(layers(1:12));

options = trainingOptions('adam',...
    'InitialLearnRate',0.001, ...
    'ValidationData',{XValidation,YValidation},...
    'Plots','training-progress',...
    'Verbose',false);
net = trainNetwork(XTrain,YTrain,layers,options);









