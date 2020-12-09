% Clearance simulation for apoptotic fragments
%##########################################################################
% Input:    num_EVL_cells ... number of EVL cells
%           EVL_cell_size ... size in um
%           L ... simulation area in um
%           Nmax ... max. uptake of fragments into one EVL cell
%           Nfag ... number of fragments to be uptaken
%           toff ... average pushing time (=simulation tlag) in minutes
%           v ... velocity of fragment pushing in um/min
%           pv ... probability for pushing event
%           p_up ... probability of uptake
%
% Method:   posx records the 1D lateral fragment postion in time
%           with probablity pv (pushing event) change actual position
%           50/50 left-right with stepsize toff*v 
%           posy records the information of either free or uptaken
%           posy is always 0 until uptake occurs 
%           set posy to 1, just to record the uptake
%           uptake only possible if rand>pv and rand<p_up
%
%Output:    create a Kymograph for visualization
%
%author:    Stefan and Verena 18.05.2019 
%##########################################################################

function Clearance_Efficiency_Kymograph


%settings:
%------------------
num_EVL_cells=40
EVL_cell_size=20
L=num_EVL_cells*EVL_cell_size
Nmax=5
Nfrag=50
start_posx=normrnd(L/2,EVL_cell_size*0.5,1,Nfrag)
toff=1
v=20
pv=0.5
persistence_l=toff*v
p_up=0.5


% simulation of the fragment pushing and search:
%-----------------------------------------------
EVL_cell(1:num_EVL_cells)=0;
posx(1:Nfrag,1)=start_posx;
posy(1:Nfrag,1)=0;
counter=1;
while sum(posy)<Nfrag
    counter=counter+1;
    for i=1:Nfrag
        if posy(i,counter-1)==1
            posx(i,counter)=posx(i,counter-1);
            posy(i,counter)=posy(i,counter-1);
        else
            randompv=rand;
            randomup=rand;
            if randompv<pv
                posx(i,counter)=posx(i,counter-1)+(randi(2)*2-3)*persistence_l;
                posy(i,counter)=0;
                if posx(i,counter)<0
                    posx(i,counter)=posx(i,counter-1);
                elseif posx(i,counter)>L
                    posx(i,counter)=posx(i,counter-1);
                end
            end
            if randompv>=pv & randomup<p_up
                index=round(posx(i,counter-1)/EVL_cell_size);
                if EVL_cell(index)<Nmax
                    EVL_cell(index)=EVL_cell(index)+1;
                    posx(i,counter)=posx(i,counter-1);
                    posy(i,counter)=1;
                else
                    posx(i,counter)=posx(i,counter-1);
                    posy(i,counter)=0;
                end
                
            elseif randompv>=pv & randomup>=p_up
                posx(i,counter)=posx(i,counter-1);
                posy(i,counter)=posy(i,counter-1);
            end
        end
    end
end
time_to_uptake_all=counter*toff

% plot the Kymograph for free and uptaken fragments:
%--------------------------------------------
for l=1:counter
    finder_free=find(posy(:,l)<1);
    fragments_free=round((posx(finder_free,l))/EVL_cell_size)-1;
    xbins=0:num_EVL_cells;
    hfree=histogram(fragments_free,xbins);
    Yfree=hfree.Values;
    mat_free(l,1:num_EVL_cells)=Yfree;
    finder_uptake=find(posy(:,l)==1);
    fragments_uptake=round(posx(finder_uptake,l)/EVL_cell_size)-1;
    huptake=histogram(fragments_uptake,xbins);
    Yuptake=huptake.Values;
    mat_uptake(l,1:num_EVL_cells)=Yuptake;
end
figure
clims=[0,Nmax];
imagesc(mat_free,clims);
xlabel('EVL cell #','FontSize',14);
ylabel('time (min)','FontSize',14);
title('Kymograph of free fragments','FontSize',16);
colorbar
figure
clims=[0,Nmax];
imagesc(mat_uptake,clims)
xlabel('EVL cell #','FontSize',14);
ylabel('time (min)','FontSize',14);
title('Kymograph of uptaken fragments','FontSize',16);
colorbar





