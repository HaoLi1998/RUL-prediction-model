function lgraph=Netcreate(s)
%  NETCREATE 
% 
% 
%The function of this function is to create a network structure
lgraph = layerGraph();
tempLayers = [
    sequenceInputLayer(s,"Name","sequence")
    sequenceFoldingLayer("Name","seqfold")];
lgraph = addLayers(lgraph,tempLayers);
tempLayers = [
    %%%%%
    convolution2dLayer([10 3],10,"Name","conv_1","Padding","same","Stride",[10,3])
    batchNormalizationLayer("Name","batchnorm_1")
    reluLayer("Name","relu_1")
    
    maxPooling2dLayer([5 5],"Name","avgpool2d_1","Padding","same")
    %%%%%
    convolution2dLayer([3 3],10,"Name","conv_2","Padding","same")
    batchNormalizationLayer("Name","batchnorm_2")
    reluLayer("Name","relu_2")
    
    maxPooling2dLayer([5 5],"Name","avgpool2d_2","Padding","same")
    %%%%%
    convolution2dLayer([5 5],10,"Name","conv_3","Padding","same")
    batchNormalizationLayer("Name","batchnorm_3")
    reluLayer("Name","relu_3")
    
    maxPooling2dLayer([5 5],"Name","avgpool2d_3","Padding","same")
    
    
    %%%%%
    Channel_attentionLayer("cha_att",10,2)
    Spatial_attentionLayer("spl_att")
    convolution2dLayer([3 3],1,"Name","conv_4","Padding","same")
    sigmoidLayer("Name","softmax")
    %%%%%
    ];
lgraph = addLayers(lgraph,tempLayers);
tempLayers = multiplicationLayer(2,"Name","multiplication");
lgraph = addLayers(lgraph,tempLayers);
tempLayers = [
    batchNormalizationLayer("Name","batchnorm_4")
    sequenceUnfoldingLayer("Name","sequnfold")
    flattenLayer("Name","flatten")
    lstmLayer(128,"Name","lstm")
    
    sigmoidLayer("Name","sigmoid")
    fullyConnectedLayer(1,"Name","fc_4")
    regressionLayer("Name","regressionoutput")];
lgraph = addLayers(lgraph,tempLayers);
clear tempLayers;
lgraph = connectLayers(lgraph,"seqfold/out","conv_1");
lgraph = connectLayers(lgraph,"seqfold/miniBatchSize","sequnfold/miniBatchSize");
lgraph = connectLayers(lgraph,"cha_att","multiplication/in2");
lgraph = connectLayers(lgraph,"softmax","multiplication/in1");
lgraph = connectLayers(lgraph,"multiplication","batchnorm_4");