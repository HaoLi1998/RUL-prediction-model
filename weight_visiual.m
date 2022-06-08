load weight.mat
load goodnet4.mat
load Data.mat XTest
load Ds02.mat

plot(trainednet)
%%
layer="softmax";
act = activations(trainednet,XTest{1},layer);
fig12=figure('Units',"centimeters","Position",[9,5,20,10]);
tiledlayout(2,3,'TileSpacing',"tight")
for t=[5,15,25,35,45,55]
    nexttile
    C=act(:,:,1,t);
    J = imresize(C, [400,42],'bilinear');
    image(J,'CDataMapping','scaled')
    a=gca;
    a.FontName='Times New Roman';
    a.FontSize=8;
    xticks([])
    yticks([])
    xlabel('Variables',"FontName",'Times New Roman',"FontSize",8)
    ylabel('Time',"FontName",'Times New Roman',"FontSize",8)
    title('\bf cycle='+string(t),"FontSize",8,'FontName','Times News Roman')
    colorbar
end

%%
load var
fig13=figure('Units',"centimeters","Position",[9,5,20,10]);
tiledlayout(2,2,'TileSpacing',"tight")
c=lines(6);
for s=43:46
    nexttile
    U=unique(Traindata.unit);
    for i=1:6
        rows=Traindata.unit==U(i);
        plot(Traindata{rows,s},'Color',c(i,:),"LineWidth",1.5)
        hold on
    end
    hold off
    xlabel('Time/s',"FontName",'Times New Roman',"FontSize",10,'Interpreter',"none")
    ylabel(var(s),"FontName",'Times New Roman',"FontSize",10,'Interpreter',"none")
    a=gca;
    a.FontName='Times New Roman';
    a.FontSize=8; 
end
L=legend('Unit '+string(U));
L.FontName='Times New Roman';
L.FontSize=10;
L.Layout.Tile = "east";