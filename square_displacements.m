% all SD with differences
%--------------------------------------------------------------------------
%Call:      square_displacements     
%Input:     diff       
%Output:    SD vector 
%author:    Stefan Wieser	6.1.2006 
%--------------------------------------------------------------------------

function out=square_displacements(diff);

steps=max(size(diff));SD_ALL=[];
for i=1:steps
    quadriert=diff{i}.^2;
    a=[];
    a(:,2)=quadriert(:,1)+quadriert(:,2);
    a(:,1)=i;
    SD_ALL=[SD_ALL;a];
end

out=SD_ALL;