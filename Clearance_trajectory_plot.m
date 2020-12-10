% Clearance track plot
%##########################################################################
% Input:    excel file: 3 colomns ... [trackID  posx   posy]
%
%Output:    plot the tracks ..x/y
%
%author:    Stefan and Verena 18.05.2019 
%##########################################################################

function Clearance_trajectory_plot

% create exemplary track data [trackID  posx   posy]:
%---------------------------------------------------
steps=30
D=1
tlag=1
numoftraces=200
min_trace_l=1
max_trace_l=1e5
A(1:steps*numoftraces,1:3)=0;
for i=1:numoftraces
    A((i-1)*steps+1:(i-1)*steps+steps,1)=i;
    A((i-1)*steps+1:(i-1)*steps+steps,2)=cumsum(normrnd(0,sqrt(2*D*tlag),steps,1));
    A((i-1)*steps+1:(i-1)*steps+steps,3)=cumsum(normrnd(0,sqrt(2*D*tlag),steps,1));
end


% load the xy data from excel file and plot the tracks:
%------------------------------------------------------
%A=xlsread('excel_ID_xy_cell_track_data');
numoftraces=max(A(:,1))
figure
counter=0;
for i=1:numoftraces
    finder=find(A(:,1)==i);
    trace_l=length(finder);
    if trace_l>=min_trace_l & trace_l<max_trace_l
        counter=counter+1;
        plot(A(finder,2),A(finder,3));hold on;axis equal
        vecx=A(finder(end),2)-A(finder(1),2);
        vecy=A(finder(end),3)-A(finder(1),3);
        angle(counter)=atan2(vecy,vecx);
    end
end

figure
polarhistogram(angle,15,'FaceColor',[0.8 0.2 0.2])
