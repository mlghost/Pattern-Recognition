close all; 
clear; 
clc;

fname = 'C:\Users\mlghost\Documents\MATLAB\final_project\PR-Dataset#2\IMG_0283 (11-7-2019 10-23-40 AM)\ann\*.json'; 
pos = read_json(fname);


function pos = read_json(path)
  filenames = dir(path);
  disp(filenames);
  pos = cell(1,length(filenames));
  order = py.dict(pyargs('Head',1,'Left Hand',2,'Left Elbow',3,'Left Shoulder',4,'Chest',5,'Right Shoulder',6,'Right Elbow',7,'Right Hand',8,'Stomach',9,'Left Knee',10,'Right Knee',11, 'Left Foot', 12,'Right Foot',13));

  for i=1:length(filenames)
    
    fname = strcat(strcat(filenames(i).folder,'\'), filenames(i).name); 
    fid = fopen(fname); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    val = jsondecode(str);
    n = val.objects;
    
    vector = cell(1,26);
    for j = 1:13
      vector{order{n(j).classTitle}*2 -1} = n(j).points.exterior(1);
      vector{order{n(j).classTitle}*2} = n(j).points.exterior(2);

    end
    pos{i} = vector;
  end
end