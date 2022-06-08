load Ds02.mat
D=[Traindata;Testdata];
D(:,5:46)=normalize(D(:,5:46),'range');
trainunit=[2,5,10,16,18,20];
testunit=[11,14,15];
XTrain=cell(1,1);
YTrain=cell(1,1);
XTest=cell(1,1);
YTest=cell(1,1);
splitnum=400;


%%
for n = 1:6
    i = trainunit(n);
    c = max(D{D.unit==i,2});
    for j=1:1:c
        ll=D(D.unit==i,:);
        nn=ll(ll.cycle==j,:);
        t = numel(nn.unit);
        s = fix(linspace(1,t,splitnum));
        f = nn{s,5:46};
        XTrain{n,1}(:,:,1,j) = f;
    end
     YTrain{n,1}  = c-1:-1:0;
end
%%
for n = 1:3
    i = testunit(n);
    c = max(D{D.unit==i,2});
    
    for j=1:1:c
        ll=D(D.unit==i,:);
        nn=ll(ll.cycle==j,:);
        t = numel(nn.unit);
        s = fix(linspace(1,t,400));
        f = nn{s,5:46};
        XTest{n,1}(:,:,:,j) = f;
    end
     YTest{n,1}  = c-1:-1:0;
end
%%
save Data YTrain XTrain YTest XTest s