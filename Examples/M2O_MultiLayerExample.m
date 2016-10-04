t = 0:0.1:2*pi;

M2O = M2OPlot_YOURFORMAT();

M2O.PlotLine(t,sin(t),'Plot 1', 'red' );
M2O.HideActiveWkBk;

M2O.HoldOn;

%Create a new layer on the plot  - with x linked
M2O.NewLayer(1,0);

M2O.PlotLine(t,cos(t),'Plot 1' , 'blue' );
M2O.HideActiveWkBk;

M2O.Disconnect;