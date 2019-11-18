net = shufflenet();
analyzeNetwork(net);
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
figure;
plot(lgraph)
for i=1:183
  t = net.Connections(i,:);
  source = t{1,1};
  destination = t{1,2};
  disp(class(destination));
  lgraph = connectLayers(lgraph, source{1}, destination{1});
end
lgraph = connectLayers(lgraph, 'node_199', 'fc');
lgraph = connectLayers(lgraph, 'fc', 'reg_output');
figure
plot(lgraph)