%Visualize the experimental results.
load Ds02.mat
load Data.mat
D=[Traindata;Testdata];
warning off
%%
fig9=figure('Units',"centimeters","Position",[9,5,10,5]);

l=[0.0,1.7; 0.0, 1.7; 0.0, 4.0; 0.0, 4.0; 1.0, 4.0-1;]*10000;% flight alt (ft)
x=[0.0, 0.2, 0.4, 0.6, 0.8] ;     % mach number
hold on
for i=1:3
    rows=[];
    rows=D.Fc==(4-i);
    plot(D.Mach(rows),D.alt(rows),"LineWidth",1);
end
a=gca;
a.FontName='Times New Roman';
a.FontSize=8;
xlabel('Mach number',"FontName",'Times New Roman',"FontSize",10)
ylabel('Altitude/ft',"FontName",'Times New Roman',"FontSize",10)

L=legend('Flight class 3','Flight class 2','Flight class 1');
L.Box='off';
L.AutoUpdate='off';
L.FontName='Times New Roman';
L.FontSize=10;
L.Location='bestoutside';
E=area(x,l);
E(2).FaceColor=[0.4660 0.6740 0.1880];
E(2).FaceAlpha=0.4;
E(2).LineStyle='none';
E(1).FaceColor='none';
E(1).LineStyle='none';
xlim([0.0, 1])
ylim([0, 54000]) 
hold off

box on

%%
fig10=figure('Units',"centimeters","Position",[9,5,15,7.5]);
var={'alt', 'Mach', 'TRA', 'T2'};
xl={'Altitude/ft', 'Mach number', 'Throttle Resolver Angle/%', 'Temperature at fan inlet/°R'};
u=unique(D.unit);
c=lines(numel(u));
tiledlayout(2,2,'TileSpacing',"tight")
for i=1:4
    nexttile
    for j=1:numel(u)
    rows=[];
    rows=D.unit==u(j);
    [f,xi] = ksdensity(D.(var{i})(rows)); 
    E=area(xi,f);
    E.FaceAlpha = 0.2;
    E.FaceColor = c(j,:);
    E.EdgeColor = c(j,:);
    E.LineWidth = 1;
    hold on
    end
    hold off
    xlabel(xl{i},"FontName",'Times New Roman',"FontSize",10)
    ylabel('Density',"FontName",'Times New Roman',"FontSize",10)
    a=gca;
    a.FontName='Times New Roman';
    a.FontSize=8;
end


L=legend('Unit '+string(u));
L.FontName='Times New Roman';
L.FontSize=8;
L.Layout.Tile = "east";

clear
%%

load goodnet
warning off
Sc=[];
r=[];
tt=[];
testunit=[11,14,15];
fig11=figure('Units',"centimeters","Position",[9,5,20,6]);
tiledlayout(1,3,'TileSpacing',"tight")
for t=[1 2 3]
    nexttile
    YPredicted=[];
    S=[];
    YPredicted = predict(trainednet,XTest{t});
    
    
    plot(YPredicted,'-b','Marker',".")
    hold on
    plot(YTest{t},'-.r')
    xlabel('Time/cycles',"FontName",'Times New Roman',"FontSize",10)
    ylabel('RUL/cycles',"FontName",'Times New Roman',"FontSize",10)
    a=gca;
    a.FontName='Times New Roman';
    a.FontSize=8;

    S=Score(YPredicted-YTest{t});
    rows=(D.unit==testunit(t));
    T=tabulate(D{rows,"cycle"});
    %%%
    r=[r,YPredicted-YTest{t}];
    tt=[tt;T(:,2)];
    Sc=[Sc,S];
    %%%
    title('Unit '+string(testunit(t)))
    
end
    L=legend('Predicted','True');
    L.FontName='Times New Roman';
    L.FontSize=10;
    %L.Location='northoutside';
%     L.Layout.Tile = "south";
%     L.Orientation ='horizontal';

S1=Sc*tt
S2=sum(Sc)
R1=Rmse1(r,tt)
R2=Rmse2(r)
%%
function S=Score(T)
S=[];
for i=1:numel(T)
    if T(i)<0
        S(i)=exp(-T(i)./13)-1;
    else
        S(i)=exp(T(i)./10)-1;
    end
    
end
end

function R=Rmse1(E,T)
    L=sum(T);   
    E=E.^2;
    E=E*T;
    R=sqrt(E/L); 
end
function R=Rmse2(E)
    L=numel(E);   
    E=E*E';
    R=sqrt(E/L); 
end