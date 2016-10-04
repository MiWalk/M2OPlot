%Create the M2O object - note its recommeneded to do this from the derived
%version of the class where you can set your own formatting
M2O = M2OPlot_YOURFORMAT();

x = 1:10;
y = 2*x;

M2O.PlotScatter(x,y,'PlotName','green');
M2O.xlabel('X Label','x units');
M2O.ylabel('Y Label','y units');
M2O.title('New graph Title');
M2O.yComment('Line Data');
M2O.HideActiveWkBk();

M2O.Disconnect;