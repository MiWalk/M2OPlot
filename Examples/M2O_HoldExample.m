% A hold command can be used to plot multiple data sets into one figure
% (using the same axes). This is very similar to the MATLAB hold command
% but also takes the PlotName into account. 
% If a plot already exists with that name and hold is on it will plot into
% that one

M2O = M2OPlot_YOURFORMAT();

x = 1:10;
y = 2*x;

% Hold is off by default

M2O.PlotScatter(x,y,'PlotName1','red');
M2O.yComment('Data 1');
M2O.HideActiveWkBk();

% Turn Hold on
M2O.HoldOn;

% This graph will plot into the same figure as previous or if it already
% exists in to the plot called 'PlotName2'
M2O.PlotScatter(x,2*y,'PlotName2','blue');
M2O.yComment('Data 2');
M2O.HideActiveWkBk();

% Turn off hold
M2O.HoldOff;

%This graph will plot into a new figure
M2O.PlotScatter(x,y,'PlotName3','green');
M2O.yComment('Data 3');
M2O.HideActiveWkBk();


% More adavanced example using PlotName to be added

M2O.Disconnect;