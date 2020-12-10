% bending_analyis for apoptotic fragment phagocytosis
%##########################################################################
% Input:    xy positions of recorded apoptotic fragments
%           example: heart line
%
% Method:   read (or create) xy data points
%           spline through the data (if you like)
%           calculate the curvature
%           check concave/convex (if you like)
%           average the bending values (if you like)
%
%Output:    plot the raw data xxx/yyy
%           plot the spline data xx/yy
%           plot the line vectors
%           plot the bending 
%
%author:    Stefan and Verena 18.05.2019 
%##########################################################################

function bending_analysis



%SETTINGS:
%--------------------------------------------------------------------------
Tension=0;
n=20
pixelsize=1
num=10


% load the data: 
% example: heart curve
%--------------------------------------------------------------------------
t = linspace(-pi,pi, 60);
xxx=   t .* sin( pi * .872*sin(t)./t);
yyy= -abs(t) .* cos(pi * sin(t)./t);
figure;plot(xxx,yyy,'r+')


% spline through the descrete point (if necessary):
%--------------------------------------------------------------------------
x=xxx';y=yyy';
Px=[x(1);x;x(1);x(1)];
Py=[y(1);y;y(1);y(1)];axis equal % Note first/last points are repeated, so that spline passes through all the control points
xx=[];
yy=[];
for k=1:length(Px)-3
    [XiYi]=crdatnplusoneval([Px(k),Py(k)],[Px(k+1),Py(k+1)],[Px(k+2),Py(k+2)],[Px(k+3),Py(k+3)],Tension,n);
    xx=[xx;XiYi(1,:)'];
    yy=[yy;XiYi(2,:)'];
end
figure;plot(xxx,yyy,'ro');hold on
plot (xx,yy,'b.'),axis equal


% caclculate the curvature:
%--------------------------------------------------------------------------
X = [xx,yy];
[L,R,K] = curvature(X);


%vector plot:
%-------------
xx=xx.*pixelsize;
yy=yy.*pixelsize;
figure;
h = plot(xx,yy,'LineWidth', 5); grid on; axis equal
set(h,'marker','.');
xlabel x; ylabel y
title('2D curve with curvature vectors');hold on
scale=10;
quiver(xx,yy,-K(:,1),-K(:,2),scale,'LineWidth',1);hold on


%convex/concave plot:
%-------------------
xq=xx-K(:,1);
yq=yy-K(:,2);
[in,on] = inpolygon(xq,yq,xx,yy);
%in=in*2-1;


% bending scatter plot:
%------------------
bending=sqrt(K(:,1).^2+K(:,2).^2);
bending_value(1:4)=nanmean(bending(1:5));
for i=num:length(bending)-num
    bending_value(i)=nanmean(bending(i-num+1:i+num));
end
bending_value(end:end+num)=max(bending(end-num/2:end));
figure;plot(bending_value)
figure;scatter(xx,yy,[],bending_value,'fill');axis equal;caxis([0,1.5])









