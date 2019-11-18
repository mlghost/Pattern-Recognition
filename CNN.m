close all; 
clear; 
clc;

% ---------------------  Preparing Input Data  ---------------------

img_dir = 'C:\Users\mlghost\Documents\MATLAB\final_project\PR-Dataset#2\IMG_0283 (11-7-2019 10-23-40 AM)\img\';
ann_dir = 'C:\Users\mlghost\Documents\MATLAB\final_project\PR-Dataset#2\IMG_0283 (11-7-2019 10-23-40 AM)\ann\';
input_dim = 224;

im_names = dir(strcat(img_dir,'*.jpg'));

X = zeros(input_dim,input_dim,3,length(im_names));
Y = zeros(length(im_names),26);

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
  
  X(:,:,:,i) = I;
  Y(i,:) = vector;
end

XTrain = X(:,:,:,1:140);
XValidation = X(:,:,:,141:end);

YTrain = Y(1:140,:);
YValidation = Y(141:end,:);


% ------------- Defining the Convolutional Neural Network -------------

net = shufflenet();

NUM_OUTPUT = 26;
layers = net.Layers;

layers = [
    layers(1:168)
    fullyConnectedLayer(NUM_OUTPUT,'Name','fc')
    regressionLayer('Name','reg_output')];

lgraph = layerGraph;

for i=1:170
  lgraph = addLayers(lgraph,layers(i));
end 

for i=1:183
  t = net.Connections(i,:);
  source = t{1,1};
  destination = t{1,2};
  disp(class(destination));
  lgraph = connectLayers(lgraph, source{1}, destination{1});
end
lgraph = connectLayers(lgraph, 'node_199', 'fc');
lgraph = connectLayers(lgraph, 'fc', 'reg_output');

  
miniBatchSize = 32;

validationFrequency = floor(numel(YTrain)/miniBatchSize);

options = trainingOptions('adam',...
                          'ExecutionEnvironment','gpu',...
                          'MaxEpochs',1000, ...
                          'InitialLearnRate',0.0001, ...
                          'ValidationData',{XValidation,YValidation},...
                          'Plots','training-progress',...
                          'Verbose',false...
                          );
                        
net = trainNetwork(XTrain,YTrain,lgraph,options);
YPred = predict(net,XValidation);
predictionError = YValidation - YPred;
thr = 1;
numCorrect = sum(abs(predictionError) < thr);
numImagesValidation = numel(YValidation);
accuracy = numCorrect/numImagesValidation;
rmse = sqrt(mean(predictionError.^2));

save net

