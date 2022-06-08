%Import the data
% A    :units cycle Fc-flight class hs- health state
% X_s  :Measurements  
% X_v  :Virtual Sensors 
% W    :Scenario descriptors 
% T:   :Model Health Parameters


l=[0.0, 0.0, 0.0, 0.0, 1.0, 4.0, 4.0, 4.0, 1.7, 1.7, 0.0]*10000;% flight alt (ft)
x=[0.0, 0.2, 0.4, 0.6, 0.8, 0.8, 0.6, 0.4, 0.2, 0.0, 0.0] ;     % mach number
plot(x,l);
xlim([0.0, 1])
ylim([0, 50000]) 
%%
filename='N-CMAPSS_DS02-006.h5';
Info=h5info(filename);
%Development set
W_dev = double(h5read(filename,'/W_dev'));           
X_s_dev = double(h5read(filename,'/X_s_dev'));       
X_v_dev = double(h5read(filename,'/X_v_dev'));         
T_dev = double(h5read(filename,'/T_dev'));             
RUL_dev = double(h5read(filename,'/Y_dev'));             
A_dev = double(h5read(filename,'/A_dev'));     

% Test set
W_test = double(h5read(filename,'/W_test'));
X_s_test = double(h5read(filename,'/X_s_test'));
X_v_test = double(h5read(filename,'/X_v_test'));
T_test = double(h5read(filename,'/T_test'));
RUL_test = double(h5read(filename,'/Y_test'));    
A_test = double(h5read(filename,'/A_test')); 

% Varnams
W_var = h5read(filename,'/W_var');
X_s_var = h5read(filename,'/X_s_var'); 
X_v_var = h5read(filename,'/X_v_var'); 
T_var = h5read(filename,'/T_var');
A_var = h5read(filename,'/A_var');
%%
U_train=unique(A_dev(1,:))
U_test=unique(A_test(1,:))
load var.mat
trainingdata = [A_dev; X_s_dev; X_v_dev; W_dev; T_dev; RUL_dev];
testdata = [A_test; X_s_test; X_v_test; W_test; T_test; RUL_test];
%%
Testdata=array2table(testdata');
Testdata.Properties.VariableNames = var;
Traindata=array2table(trainingdata');
Traindata.Properties.VariableNames = var;
save Ds02 Testdata Traindata