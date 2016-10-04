M2O = M2OPlot_YOURFORMAT();

x = 0:0.1:2*pi;
y = sin(x);


M2O.PlotLine(x,y,'Plot 1','green');
%Set both the x and y axis manually
M2O.xaxis( 0 , pi );
M2O.yaxis( -1.1 , 1.1 );
M2O.HideActiveWkBk();

M2O.PlotLine(x,2*y,'Plot 2','red');
%Set the x axis manually to a sub section and rescale y to fit data
M2O.xaxis( 0 , pi/2 );
M2O.yrescale();
M2O.HideActiveWkBk();

M2O.PlotLine(2*x,y,'Plot 3','red');
%Rescale to show all
M2O.rescale();
M2O.HideActiveWkBk();

%Set the y axis manually to a sub section and rescale x to fit data
M2O.PlotLine(3*x,y,'Plot 4','red');
M2O.yaxis(-0.5 , 0.5 );
M2O.xrescale();
M2O.HideActiveWkBk();

M2O.Disconnect;
