% MSD and sigma: Qian sigma (independence problem)
%##########################################################################
%Call:      MSD_sigma      
%Input:     out of square_displacements(diff)
%Output:    MSD
%           classical sigma and Qian_sigma (see Qian_sigma_test 
%author:    Stefan Wieser	6.1.2007 
%##########################################################################
function out=MSD_sigma_many_traces(SD_all,numofindependent_total,till);

steps=max(SD_all(:,1))
N=numofindependent_total

for i=1:2
    index=find(SD_all(:,1)==i);
    SD_all_index=SD_all(index,:);
    mu(i)=mean(SD_all_index(:,2));
end
vorfaktor=mu(2)-mu(1);
D_vorfaktor=vorfaktor/4;
goulian_term=-4/3*D_vorfaktor*till;
PA=mu(1)-vorfaktor-goulian_term;

clear mu
for i=1:steps
    index=find(SD_all(:,1)==i);
    SD_all_index=SD_all(index,:);
    mu(i)=mean(SD_all_index(:,2));
    m=length(index);
    s=std(SD_all_index(:,2));
    sigma_class(i)=s/sqrt(m);
    n=i;
    Qian_term=(2*n.^2+1)./(3*n.*(N-n+1));
    sigma_Qian(i)=sqrt((vorfaktor*i.*sqrt(Qian_term)).^2+PA.^2/m);
end

out=[mu',sigma_class',sigma_Qian'];