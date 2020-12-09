%============================================================
%Input:     steps ... number of steps
%           D ... diffusion constant in um2/s
%           tlag ... time interval
%------------------------------------------------------------
%method:    calculate x/y using normaldistributed steplenghts
%------------------------------------------------------------
%Output:    plot x/y
%============================================================
%author:    Stefan Wieser	15.1.2020 


function two_D_random_walk

%Input:
%------
steps=1e5
D=1
tlag=1

% random walk:
%-------------
x=cumsum(normrnd(0,sqrt(2*D*tlag),steps,1));
y=cumsum(normrnd(0,sqrt(2*D*tlag),steps,1));

%Output:
%-------
figure;plot(x,y);axis equal
