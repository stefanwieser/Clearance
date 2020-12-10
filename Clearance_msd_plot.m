% simple msdplot (FIT to persistent random walk and x^2 function)
%##########################################################################
%Input:     [trackID  x  y] data from tracks
%
%programs:  differences; 
%           square_displacements(diff)
%           MSD_sigma_many_traces
%           catch_trajectories(min_trace_length,pixel size)
%           function_for_hopfit
%
%Output:    MSD-t plot
%           various FITs to the msd-t plot 
%           linear, quadratic, persistent and combinations
%
%author:    Stefan Wieser and Verena Ruprecht	10.5.2019 
%##########################################################################

function Clearance_msd_plot



%SETTINGS:
%--------------------------------------------------------------------------
tlag=38/60 %38s/frame
min_trace_l=3
max_trace_l=5000
pixelsize=1 %already in um
till=4e-3
plot_end=18
 
   
     
% read the files:
%--------------------------------------------------------------------------
%A=xlsread('data_from_cells');
temp=load('examplary_data.mat')
A=temp.XX


% load the trajectories:
%--------------------------------------------------------------------------
numoftraces=max(A(:,1));
k=0;
for i=1:numoftraces
    finder=find(A(:,1)==i)
    trace_l=length(finder)
    if trace_l>=min_trace_l & trace_l<max_trace_l
        k=k+1;
        trajectories{k}=[A(finder,2).*pixelsize,A(finder,3).*pixelsize];
    end
end
num_traces_used=k


% mean square displacement (msd) to time plot:
%--------------------------------------------------------------------------
SD_all=[];D_all=[];
hold on
xpos=[];ypos=[];
for k=1:num_traces_used      %k...num of loaded (selected) tracks
    diffs=differences(trajectories{k}(:,1:2));
    N(k)=length(diffs);
    SD=square_displacements(diffs);
    SD_all=[SD_all;SD];
    %D_trace(k)=mean(SD(:,2)./(4*SD(:,1)*tlag));
    %D_trace(k)=(mean(SD(find(SD(:,1)==2),2))-mean(SD(find(SD(:,1)==1),2)))/(4*tlag);
    %D_all=[D_all;D_trace(k)];
    hh=trajectories{k};
    plot(hh(:,1),-hh(:,2),'k');hold on;axis equal
end
MSD_std=MSD_sigma_many_traces(SD_all,numoftraces*mean(N)*2,till);
MSD_all=MSD_std(:,1)'
s_Qian_all=MSD_std(:,3)';
figure;errorbar([1:plot_end]*tlag,MSD_all(1:plot_end),s_Qian_all(1:plot_end),'ro','MarkerSize',6,'LineWidth',2);hold on


% fit with linear function (random walk model):
%--------------------------------------------------------------------------
out=MSD_linreg_Qian(MSD_std,tlag);
D_linreg=out(1)
dD_Qian=out(2);
PA_Qian=out(3)
plot(0:1e-5:(plot_end)*tlag,4*D_linreg.*[0:1e-5:plot_end*tlag]+PA_Qian,'r')
 
 
%fit quadratic function:
%--------------------------------------------------------------------------
xdata=[1:plot_end]*tlag;
ydata=MSD_all(1:plot_end);
figure;errorbar(xdata,ydata,s_Qian_all(1:plot_end),'ko');hold on
coeff = lsqcurvefit(@quadratic,[0],xdata,ydata)
xx=linspace(0,xdata(end),5000);
plot(xx,quadratic(coeff,xx),'k')
v_in_min=coeff(1)*60
 
 
% fit Fuerth:
%--------------------------------------------------------------------------
xdata=[1:plot_end]*tlag;
ydata=MSD_all(1:plot_end);
figure;errorbar([1:plot_end]*tlag,MSD_all(1:plot_end),s_Qian_all(1:plot_end),'go','MarkerSize',6,'LineWidth',2);hold on
options=optimset('MaxFunEvals',500,'MaxIter',1e4,'TolFun',1e-12,'TolX',1e-12);%,'Display','off');
LB=[0,0];
UB=[100,1000];
x=lsqcurvefit(@Furth,[0 0],xdata,ydata,LB,UB,options);
Dt=x(1)
Pt=x(2)
RMSt=sqrt(2*Dt/Pt);
xx=linspace(0,plot_end*tlag,500);
yfit=Furth(x,xx);
plot(xx,yfit,'g')
 
 
% fit Fuerth plus velocity drag:
%--------------------------------------------------------------------------
xdata=[1:plot_end]*tlag;
ydata=MSD_all(1:plot_end);
figure;plot(xdata,ydata,'b*');hold on
options=optimset('MaxFunEvals',500,'MaxIter',1e4,'TolFun',1e-12,'TolX',1e-12);%,'Display','off');
LB=[0,0,0];
UB=[100,1000,10];
para=lsqcurvefit(@Furth_v,[0 0 0],xdata,ydata,LB,UB,options);
Dt=para(1)
Pt=para(2)
vt=para(3)
xx=linspace(0,plot_end*tlag,500);
yfit=Furth_v(para,xx);
plot(xx,yfit,'b')
 
 
% fit diffusion plus velocity drag:
%--------------------------------------------------------------------------
xdata=[1:plot_end]*tlag
ydata=MSD_all(1:plot_end)
xx=xdata'
yy=ydata'
figure;plot(xdata,ydata,'c*');hold on
options=optimset('MaxFunEvals',1e5,'MaxIter',1e6,'TolFun',1e-16,'TolX',1e-16);%,'Display','off');
LB=[0,0,0];
UB=[1,10,10];
para=lsqcurvefit(@diffusion_v,[0.5 2 0.1],xdata,ydata,LB,UB,options);
alpha=para(1)
v_in_min=para(2)
D=para(3)
xx=linspace(0,plot_end*tlag,500);
yfit=diffusion_v(para,xx);
plot(xx,yfit,'c')
 
 



% FIt functions:
%--------------------------------------------------------------------------
    function F = Furth(x,xdata)
        F=4*x(1)*(xdata-x(2)*(1-exp(-xdata/x(2))));
        
        function F = Furth_v(para,xdata)
            F=4*para(1)*(xdata-para(2)*(1-exp(-xdata/para(2))))+para(3).^2*xdata.^2;
            
            
            function F = quadratic(coeff,xdata)
                F=coeff(1).^2*xdata.^2;
                
                function F = diffusion_v(coeff,xdata)
                    F=coeff(1)*coeff(2).^2*xdata.^2+(1-coeff(1))*4*coeff(3).*xdata;
