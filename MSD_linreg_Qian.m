function out=MSD_linreg_Qian(MSD_std,tlag)

numofregressions=5;
fitend_lin=2;

options=optimset('TolFun',1e-10,'MaxFunEvals',1e5,'MaxIter',1e5,'Display','off');
fun=inline('para(1)+para(2)*xdata','para','xdata');
for j_reg=1:numofregressions
    for k_fit=1:fitend_lin
        points_Qian(k_fit)=normrnd(MSD_std(k_fit,1),MSD_std(k_fit,3));
    end
    a=lsqcurvefit(fun,[0,0],[1:fitend_lin]*tlag,points_Qian,[-inf,-inf],[inf,inf],options);
    linreg_k=a(2);
    D_linreg_Qian(j_reg)=linreg_k/4;
    linreg_d=a(1);
    PA(j_reg)=linreg_d;
end
D=mean(D_linreg_Qian);
dD=std(D_linreg_Qian);
PA=mean(PA);

out=[D,dD,PA];