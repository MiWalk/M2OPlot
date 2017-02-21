x = 0:0.1:2*pi;
y = sin(x);

M2O = M2OPlot_YOURFORMAT();

M2O.PlotLine(x,y,'Plot 1','red');
M2O.xlabel('X Label','x units');
M2O.ylabel('Y Label','y units');
M2O.title('New graph Title');
M2O.yComment('sin(x)');
M2O.HideActiveWkBk();

%This is an annotation in carteisan space
M2O.AddAnnotation('Text on graph', 1,1)
%This is a text addition by pixel value in the page area
M2O.AddText('Text on page', 200,200)

M2O.Disconnect;