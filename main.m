clear
load Data.mat

s=[400,42,1];
net=Netcreate(s);
maxEpochs =450;
miniBatchSize =6;
options = trainingOptions('adam', ...
    "MaxEpochs",maxEpochs,...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',0.02, ...
    'GradientThreshold',2, ...
    'Shuffle',"once", ...
    'Verbose',0 ,...
    'Plots','training-progress' ,...
    'ExecutionEnvironment',"cpu", ...
    'WorkerLoad',0.1);


%%
trainednet = trainNetwork(XTrain,YTrain,net,options);
%%
t=3
    YPredicted=[];
    YPredicted = predict(trainednet,XTest{t});
sum((YPredicted-YTest{t}))
figure
plot(YPredicted)
hold on
plot(YTest{t})