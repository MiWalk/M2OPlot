M2O = M2OPlot_YOURFORMAT();

x = 1:10;
y = 2*x;

M2O.PlotScatter(x,y,'PlotName','green');
M2O.xlabel('Voltage','mV');
M2O.ylabel('Current','nA');
M2O.title('New graph Title');
M2O.yComment('Line Data');
M2O.HideActiveWkBk();

%Set the increment for x
M2O.xlabelincrement(2);

%But for y set the number of major ticks
M2O.ylabelMajorTicks(6);

%Set first tick
M2O.yfirsttick(1);

% Add annotation
M2O.AddText('Created using M2O Plot');

M2O.Disconnect;