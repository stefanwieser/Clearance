% differences (like eval_dif_fast)
%--------------------------------------------------------------------------
%Call:      differences     
%Input:     only one trajectory
%method:    [x0  y0         [0   0        [------------
%            x1  y1          x0  y0        x1-x0  y1-y0
%            x2  y2     -    x1  y1   =    x2-x1  y2-y1
%            0   0           x2  y2        ------------
%            0   0]          0   0 ]       ------------]  ..... 
%Output:    difference matrices{i} i...number of possible differences
%author:    Stefan Wieser	6.1.2006 
%--------------------------------------------------------------------------
function out=differences(Trajectory);

l=size(Trajectory,1);
diff0_counter=0;
if l==0
    diff=[];
    diff0_counter=diff0_counter+1;
end
for i=1:l
    Verschubmatrix(1:2*l-1,1:2)=0;
    Verschubmatrix(i:l+i-1,1:2)=Trajectory(1:l,1:2);
    Verschub{i}=Verschubmatrix;
end
for i=1:l-1
    difference=Verschub{1}-Verschub{i+1};
    diff{i}=difference(i+1:l,:);
end

if diff0_counter~=0
    diff0_counter
end
out=diff;