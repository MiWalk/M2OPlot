M2O = M2OPlot_YOURFORMAT();

x = 1:5
y = [4 6 7 3 5];

%Historgram Example
H = [1 1 3 4 5 5 5 5 6 6 7 7 7 8 8  1 3 4];
M2O.plotHist(H,'Histogram','red');
M2O.HideActiveWkBk();

%Bar Chart Example
M2O.PlotBar(x,y,'Bar Example','Pink');
M2O.HideActiveWkBk();

%Column Chart Example
M2O.PlotColumn(x,y,'Column Example','cyan');
M2O.HideActiveWkBk();

M2O.Disconnect;