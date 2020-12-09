%============================================================
%Input:     steps ... number of steps
%           D ... diffusion constant in um2/s
%           tlag ... time interval
%------------------------------------------------------------
%method:    calculate x/y using normaldistributed steplenghts
%           calculate the distances for each tlag
%------------------------------------------------------------
%Output:    figure(1) trace: plot x/y
%           figure(2) steplength distribution
%           figure(3) mean square displacement to time plot
%============================================================
%author:    Stefan Wieser	15.1.2020 


function two_D_random_walk_MSD

%Input:
%------
steps=1e4
D=1
tlag=1
num_MSD_points=10

% random walk:
%-------------
x=cumsum(normrnd(0,sqrt(2*D*tlag),steps,1));
y=cumsum(normrnd(0,sqrt(2*D*tlag),steps,1));
for i=1:num_MSD_points
    xx=x(1:i:end);
    yy=y(1:i:end);
    diffx=diff(xx);
    diffy=diff(yy);
    sd=diffx.^2+diffy.^2;
    MSD(i)=mean(sd);
end
    

%Output: 
%-------
figure(1);plot(x,y);axis equal
%
figure(2);histogram(diffx,'Normalization','pdf');hold on
[meanfit,sigmafit] = normfit(diffx);
xx=[-(meanfit+5*sigmafit):0.01:meanfit+5*sigmafit];
yy=normpdf(xx,meanfit,sigmafit);
plot(xx,yy,'r.')
%
figure(3);plot([0:num_MSD_points],[0,MSD],'ro');hold on
plot([0:1e-3:num_MSD_points],4*D*tlag.*[0:1e-3:num_MSD_points])

