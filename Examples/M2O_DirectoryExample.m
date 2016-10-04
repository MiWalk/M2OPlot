% M2OPlot allows you to move around the OriginPro project to put graphs in 
% to folders

M2O = M2OPlot_YOURFORMAT();

% Go to the top level of the project
M2O.cd_TopLevel();

% Make a new dir called NewDir
M2O.mkdir('NewDir')
% Move to the new dir
M2O.cd('NewDir');

%Make a plot in NewDir
M2O.PlotScatter([1 2 3 4],[5 6 7 8],'PlotNewDir','green');

% Make a new dir called NewSubDir and move to it.
M2O.mkdir_cd('NewSubDir');

%Make a plot in NewSubDir
M2O.PlotScatter([1 2 3 4],[5 4 3 2],'PlotNewSubDir','red');

% Move up a level
M2O.cd_up();

%You should now be in NewDir and have a plot in both NewDir and NewSubDir

M2O.Disconnect;