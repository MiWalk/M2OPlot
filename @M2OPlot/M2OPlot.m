% ***********************************
% M2OPlot
%   A librabry to plot from MATLAB into Origin.
%   Vers: 0.0.5
%
% MIT License
% 
% Copyright (c) 2016 Michael Walker
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%
%%***********************************

classdef M2OPlot < handle
    % Matlab2OriginPlot Code to plot in Origin from Matlab
    %
    %
    % Matlab2OriginPlot Methods:
    %    PlotLine - Plot XY Line
    %    PlotScatter - Plot XY Scatter
    %    title - Add a title to the plot
    %    xlabel - Set the X label and units
    %    ylabel - Set the Y lable and units
    %    xComment - Set the X comment
    %    yComment - Set the Y Comment  - used for series legend
    %    MatrixToOrigin  -  Transfer a Matrix into an Origin worksheet
    %
    % Colours from the labtalk list of colours: http://www.originlab.com/doc/LabTalk/ref/List-of-Colors
    properties
        ProjectName;
        originObj;
        ActiveWorksheetName;
        ActiveGraphName;
        Hold;
        CurrentLayer;
        NoLayers;
        CurrentPlotNo;
        NoPlots;
        %http://www.originlab.com/doc/LabTalk/ref/List-of-Colors
        colourWheel = {'Black', 'Red','Green','Blue','Cyan','Magenta','Yellow','Dark Yellow','Navy','Purple','Wine','Olive','Dark Cyan','Royal','Orange','Violet','Pink','White','LT Gray','Gray','LT Yellow','LT Cyan','LT Magenta','Dark Gray'}
        typeWheel = {'201','200','200'};
        GraphTemplate = [];
    end
    
    methods
        function obj = M2OPlot(Name)
            if nargin > 0 && ~isempty(Name)
                obj.ProjectName = Name;
                Existing = 0;
            else
                %No Name supplied so can either use existing or offer an
                %option to load
                Existing = 1;
                %Option to load project.
                %[FileName, PathName] = uigetfile({'*.OPJ','All Origin Projects';},'Choose Origin Project');
                %obj.ProjectName = [PathName '\' FileName];
            end
            
            obj.ActiveWorksheetName = 'Worksheet Name';
            obj.Hold = 0;
            obj.CurrentLayer = 1;
            obj.NoLayers = 1;
            obj.CurrentPlotNo = 1;
            obj.NoPlots = 1;
            
            % Obtain Origin COM Server object
            % This will connect to an existing instance of Origin, or create a new one if none exist
            obj.originObj=actxserver('Origin.ApplicationSI');
            
            % Make the Origin session visible  -mc worked for pre 2016 but
            % use -m to work with 2016
            %http://originlab.com/doc/LabTalk/ref/Document-cmd
            invoke(obj.originObj, 'Execute', 'doc -m 1;');
            if Existing == 0
                % Clear "dirty" flag in Origin to suppress prompt for saving current project
                % You may want to replace this with code to handling of saving current project
                invoke(obj.originObj, 'IsModified', 'false');
                
                % Load the custom project CreateOriginPlot.OPJ found in Samples area of Origin installation
                % invoke(obj.originObj, 'Execute', 'syspath$=system.path.program$;');
                %strPath='';
                %strPath = invoke(obj.originObj, 'LTStr', 'syspath$');
                invoke(obj.originObj, 'Load', obj.ProjectName);
            end
        end
        
        plotName = plotXY(obj,X,Y,E,type,plotName,colour)
        plotName = plotHist(obj,Y,plotName,colour)
        [error, Xout, Yout, nRows, nX,nY] = CheckVectors(obj, Xin, Yin)
        
        function WksName = CreateWorkSheet(obj, Name)
            if nargin > 1
                WksName = invoke(obj.originObj, 'CreatePage', 2, Name);
            else
                WksName = invoke(obj.originObj, 'CreatePage', 2);
            end
            obj.ActiveWorksheetName = WksName;
        end
        function MatrixToOrigin(obj, mdata, WorksheetName)
            if nargin > 2
                obj.CreateWorkSheet(WorksheetName)
            else
                %Need to either create an unamed work sheet or use the
                %active worksheet.
                %Will use the active worksheet  - assuming one is set.
                %The plot code all currently do the creation them selves  -
                %though should get rid of this to improve.
            end
            invoke(obj.originObj, 'PutWorksheet', obj.ActiveWorksheetName, mdata);
            %See here for label row showing: http://www.originlab.com/doc/LabTalk/ref/Column-Label-Row-Characters
            obj.ExecuteLabTalk('wks.labels(LUC);' );
        end
        function CopyGraph(obj)
            invoke(obj.originObj, 'CopyPage', 'Graph1');
        end
        function plotName = PlotScatter(obj,X,Y, plotName, colour)
            if nargin < 5
                colour = ColourPicker(obj);
            end
            plotName = plotXY(obj,X,Y,0,'201',plotName, colour);
        end
        function plotName = PlotScatterError(obj,X,Y,E, plotName, colour)
            if nargin < 6
                colour = ColourPicker(obj);
            end
            plotName = plotXY(obj,X,Y,E,'201',plotName, colour);
        end
        function plotName = PlotScatterXYError(obj,X,X_Err,Y,Y_Err, plotName, colour)
            if nargin < 7
                colour = ColourPicker(obj);
            end
            plotName = plotXY(obj,X,Y,0,'201',plotName, colour);
        end
        function plotName = PlotLine(obj,X,Y,plotName,colour)
            if nargin < 5
                colour = ColourPicker(obj);
            end
            plotName = plotXY(obj,X,Y,0,'200',plotName,colour);
        end
        function plotName = PlotLineError(obj,X,Y,E, plotName, colour)
            if nargin < 6
                colour = ColourPicker(obj);
            end
            plotName = plotXY(obj,X,Y,E,'200',plotName, colour);
        end
        function plotName = PlotBar(obj,X,Y,plotName,colour)
            if nargin < 5
                colour = ColourPicker(obj);
            end
            plotName = plotXY(obj,X,Y,0,'215',plotName,colour);
        end
        function plotName = PlotColumn(obj,X,Y,plotName,colour)
            if nargin < 5
                colour = ColourPicker(obj);
            end
            plotName = plotXY(obj,X,Y,0,'203',plotName,colour);
        end
        function plotName = PlotColumnError(obj,X,Y,E,plotName,colour)
            if nargin < 5
                colour = ColourPicker(obj);
            end
            plotName = plotXY(obj,X,Y,E,'203',plotName,colour);
        end
        function xlabel(obj,Name,Units)
            obj.ActivatePage(obj.ActiveWorksheetName);
            obj.ExecuteLabTalk(['wks.col1.lname$ = "' Name '";wks.col1.unit$ = "' Units '";'] );
            obj.ActivatePage( obj.ActiveGraphName );
            obj.ExecuteLabTalk('page.active = 1; layer - a;');
        end
        function ylabel(obj,Name,Units)
            obj.ActivatePage(obj.ActiveWorksheetName );
            obj.ExecuteLabTalk(['wks.col2.lname$ = "' Name '";wks.col2.unit$ = "' Units '";'] );
            obj.ActivatePage(obj.ActiveGraphName)
            obj.ExecuteLabTalk('page.active = 1; layer - a;');
        end
        function title(obj, Name)
            obj.ActivatePage(obj.ActiveGraphName );
            obj.ExecuteLabTalk(['page.longname$ = "' Name '"']);
        end
        function xComment(obj,Comment)
            obj.ActivatePage(obj.ActiveWorksheetName )
            obj.ExecuteLabTalk(['wks.col1.comment$ = "' Comment '";'] );
            obj.ActivatePage( obj.ActiveGraphName);
        end
        function yComment(obj,Comment)
            obj.ActivatePage(obj.ActiveWorksheetName )
            obj.ExecuteLabTalk(['wks.col2.comment$ = "' Comment '";'] );
            obj.ActivatePage( obj.ActiveGraphName);
        end
       
 
        function  ExecuteLabTalk(obj, script)
            invoke(obj.originObj, 'Execute', script);
        end
        
        function FormatGraph(obj)
           %This function is to be overidden to apply user/Organisation
           %specific formats
        end
        function HoldOn(obj)
            obj.Hold = 1;
        end
        function HoldOff(obj)
            obj.Hold = 0;
            %Not sure if I do want to reset all of these here?
            obj.NoPlots = 0;
            obj.CurrentPlotNo = 0;
            obj.CurrentLayer = 1;
            obj.NoLayers = 1;
        end
        function ActivatePage(obj, PageName)
            obj.ExecuteLabTalk(['win -a ' PageName ' ']);
        end
        function exist = ActivateGraphPage(obj, plotName)
            
            %need to correct plotNo
            GL = invoke(obj.originObj, 'FindGraphLayer',plotName);
            if ~isempty(GL)
                obj.ActivatePage(plotName);
                obj.ActiveGraphName = plotName;
                DL = GL.invoke('DataPlots');
                n = DL.invoke('Count');
                obj.NoPlots = n;
                obj.CurrentPlotNo = n;
                
                %Neeed to set layer numbers
                %obj.CurrentLayer = 1;
                %obj.NoLayers = 1;
                exist = 1;
            else
                %This plot doesn't exist so plot into currently active graph
                disp(['Plot Doesn''t exist so as hold is on plotting into ' obj.ActiveGraphName]);
                exist = false;
                %DO NOT CREATE NEW PAGE HERE - Figure Command will do so
            end
        end
        
        function CreateGraphPage(obj, plotName)
            obj.ActiveGraphName = invoke(obj.originObj, 'CreatePage', 3,plotName,obj.GraphTemplate);
            obj.NoPlots = 0;
            obj.CurrentPlotNo = 0;
            obj.CurrentLayer = 1;
            obj.NoLayers = 1;
        end
        function [plotName] = Figure(obj, plotName)
            %Turn to Requested plot - but create if it doesn't exist -
            %regardless of hold condition
            if obj.ActivateGraphPage(plotName) == 0
                obj.CreateGraphPage(plotName)
            else
                if obj.Hold == 0
                    %Page Exists but as hold is off should create a new
                    %page anyway!
                end
            end
            plotName = obj.ActiveGraphName;
        end
        function CopyPage(obj, GraphName)
            if nargin > 1
                invoke(obj.originObj, 'CopyPage', GraphName);
            else
                invoke(obj.originObj, 'CopyPage', obj.ActiveGraphName);
            end
        end
        function AddText(obj,Text, XPos, YPos)
            %add a label to the chart area using pixel coordinates
            if nargin < 3
                XPos = 500;
                YPos = 200;
            end
            obj.ActivatePage(obj.ActiveGraphName);
            obj.ExecuteLabTalk(['label -s -d ' num2str(XPos) ' ' num2str(YPos) ' ' Text ';']);
        end
        function AddAnnotation(obj,Text, XPos, YPos)
            %add a label to the graph area using the graph coordinates
            if nargin < 3
                XPos = 0;
                YPos = 0;
            end
            obj.ActivatePage(obj.ActiveGraphName);
            obj.ExecuteLabTalk(['label -s -a ' num2str(XPos) ' ' num2str(YPos) ' ' Text ';']);
        end
    
          
        function plotName = plotMultiY_inBuilt(obj,X,Y,E,plotName,colour)
            %Plot all Y columns against the same X  - if they are different
            %X's then use multiple plots creating a new layer for each - ie
            %set so that only X is linked.
            NoCols = size(Y',2);
            %Reshape and check sizes here.
            
            Wks = CreateWorkSheet(obj,[plotName ' Data']);
            %Put Data into Worksheet
            if size(E) == size(Y)
                obj. MatrixToOrigin([X',Y',E']);
                e = 1;
            else
                obj.MatrixToOrigin( [X',Y']);
                e = 0;
            end
            obj.ExecuteLabTalk( 'wks.col1.type=4;' )
            for i = 1:NoCols
                obj.ExecuteLabTalk( ['wks.col' num2str(i+1) '.type=1;'] );
                if e == 1
                    obj.ExecuteLabTalk([' wks.col3.type=' num2str(i+1+NoCols) ';'] );
                end
            end
            %Create a Graph Page;
            if obj.Hold == 0
                obj.CreateGraphPage(plotName);
            else
                %Adding to a plot so implement plot no  - if we were goign
                %Increasing the layer is done by a separat func
                %obj.CurrentPlotNo = obj.NoPlots + 1;
                %obj.NoPlots = obj.NoPlots + 1;
                if nargin > 5
                    ActivateGraphPage(obj, plotName)
                end
            end
            %plotmyaxes iy:=((3),(4),(5),(7)) plottype:=line axiscolor:=1;
            str = ['plotmyaxes iy:=[' Wks ']Sheet1!('];
            for i = 1:NoCols
                if e == 0
                    %str = strcat(str ,',(', num2str(i+1), ')');
                    str = strcat(str ,'(1,', num2str(i+1), ')');
                    if i< NoCols
                        str = strcat(str,',');
                    end
                else
                    %Add Error Bars
                    ErrorCol = NoCols + i+1;
                end
            end
            str = strcat(str, ') plottype:=line:line axiscolor:=1;');
            %str = strcat(str,' ogl:=[', obj.ActiveGraphName, ']', num2str(obj.CurrentLayer), '!;');
            obj.ActivatePage(Wks);
            obj.ExecuteLabTalk(str);
            obj.CurrentPlotNo = obj.NoPlots + 1;
            obj.NoPlots = obj.NoPlots + 1;
            %Now need to loop over layers to set colours
            obj.ActivatePage(obj.ActiveGraphName)
            obj.ExecuteLabTalk(['layer.plot = ' num2str(obj.CurrentPlotNo) ';']);
            obj.ExecuteLabTalk(['set %C -cl color(' colour ');']);
            obj.ExecuteLabTalk('set %C -w 1000;');
            obj.ExecuteLabTalk(['set %C -c color(' colour ');']);
            obj.ExecuteLabTalk(['set %C -cf color(' colour ');']);
            
            
            obj.ExecuteLabTalk(['page.lname$= ' obj.ActiveGraphName ';'] )
            
            obj.FormatGraph;
            plotName = obj.ActiveGraphName;
            obj.ActivatePage(obj.ActiveGraphName);
        end
        function plotName = plotMultiY2(obj,X,Y,E,plotName,colour)
            
            if nargin > 5 && obj.Hold == 1
                ActivateGraphPage(obj, plotName)
            end
            
            for i = 1:size(Y,1)
                plotName = plotXY(obj,X,Y(i,:),E,201,plotName,colour);
                obj.HoldOn;
                if i < size(Y,2)
                    obj.NewLayer(1,0); %Create a new layer whcih links on X only
                end
            end
        end
        function plotName = plotMultiY3(obj,X,Y,E,plotName,colours, types)
            %http://www.originlab.com/doc/LabTalk/guide/Creating-Graphs#Plotting_X_Y_data
            % Type is plot Type ID as here: http://www.originlab.com/doc/LabTalk/ref/Plot-Type-IDs
            %Create Worksheet  - unless it already exists?
            NoCols = size(Y',2);
            %Reshape and check sizes here.
            
            Wks = CreateWorkSheet(obj,[plotName ' Data']);
            %Put Data into Worksheet
            if size(E) == size(Y)
                obj. MatrixToOrigin([X',Y',E']);
                e = 1;
            else
                obj.MatrixToOrigin( [X',Y']);
                e = 0;
            end
            obj.ExecuteLabTalk( 'wks.col1.type=4;' )
            for i = 1:NoCols
                obj.ExecuteLabTalk( ['wks.col' num2str(i+1) '.type=1;'] );
                if e == 1
                    obj.ExecuteLabTalk([' wks.col3.type=' num2str(i+1+NoCols) ';'] );
                end
            end
            %Create a Graph Page;
            if obj.Hold == 0
                obj.CreateGraphPage(plotName);
            else
                %Adding to a plot so implement plot no  - if we were goign
                %Increasing the layer is done by a separat func
                %obj.CurrentPlotNo = obj.NoPlots + 1;
                %obj.NoPlots = obj.NoPlots + 1;
                if nargin > 5
                    ActivateGraphPage(obj, plotName)
                end
            end
            %PLot into existing graph layer 1  - or on to a new layer?
            for i = 1:NoCols
                if e == 0
                    obj.ExecuteLabTalk(['plotxy iy:=[' Wks ']Sheet1!(1,' num2str(1+i) ' ) plot:=' types ' ogl:=[' obj.ActiveGraphName ']' num2str(obj.CurrentLayer) '!;'] )
                else
                    %Add Error Bars
                    ErrorCol = NoCols + i+1;
                    obj.ExecuteLabTalk(['plotxy iy:=[' Wks ']Sheet1!(1,' num2str(1+i) ',' num2str(ErrorCol) ') plot:=' type ' ogl:=[' obj.ActiveGraphName ']' num2str(obj.CurrentLayer) '!;'] )
                    
                end
                obj.CurrentPlotNo = obj.NoPlots + 1;
                obj.NoPlots = obj.NoPlots + 1;
                
                obj.ActivatePage(obj.ActiveGraphName)
                obj.ExecuteLabTalk(['layer.plot = ' num2str(obj.CurrentPlotNo) ';']);
                obj.ExecuteLabTalk(['set %C -cl color(' colours{i} ');']);
                obj.ExecuteLabTalk('set %C -w 1000;');
                obj.ExecuteLabTalk(['set %C -c color(' colours{i} ');']);
                obj.ExecuteLabTalk(['set %C -cf color(' colours{i} ');']);
                if i<NoCols
                    obj.NewLayer(1,0);
                end
            end
            
            obj.ExecuteLabTalk(['page.lname$= ' obj.ActiveGraphName ';'] )
            
            obj.FormatGraph;
            plotName = obj.ActiveGraphName;
            obj.ActivatePage(obj.ActiveGraphName)
        end
        function NewLayer(obj, Xlink,Ylink)
            %Xlink = 0 for no link 1 for bottom.
            %Ylink = 0 for no link, 1 for left and 2 for right.
            obj.ActivatePage(obj.ActiveGraphName);
            if Xlink == 0 && Ylink == 0
                obj.ExecuteLabTalk('layer -n Y;');
            else
                obj.ExecuteLabTalk('layer -n Y;');
                if Ylink > 0
                    obj.ExecuteLabTalk('layer.link = 1;');
                    obj.ExecuteLabTalk('layer.y.link = 1;');
                end
                if Xlink > 0
                    %http://www.originlab.com/doc/LabTalk/ref/Layer-Axis-obj
                    %obj.ExecuteLabTalk('laylink igl:=1 destlayers:=2:0 XAxis:=1;');
                    obj.ExecuteLabTalk('layer.link = 1;');
                    obj.ExecuteLabTalk('layer.x.link = 1;');
                    %obj.ExecuteLabTalk('layer.x.showAxes = 0;');
                    %obj.ExecuteLabTalk('layer.x.showLabels = 0;');
                end
            end
            obj.CurrentLayer = obj.NoLayers + 1;
            obj.NoLayers = obj.CurrentLayer;
        end
        function plotName = plotMultiY(obj,X,Y,E,plotName,types, colours)
            %Select the most developed method of multi Y  plotting - they
            %all have the same effect.
            %Ensures a consistent interface to them
            
            %Need to deal with type and colour being only one or being as
            %many as no Columns
            
            %need to check sizing of X and Y
            if nargin < 7
                colours = obj.colourWheel;
            end
            if nargin < 6
                types = obj.typeWheel;
            end
            plotName = plotMultiY3(obj,X,Y,E,plotName,colours, types);
        end
        function RescaleToShowAll(obj)
            obj.ExecuteLabTalk('layer -a;');
        end
        function logYScale(obj)
            obj.ExecuteLabTalk('layer.y.type = 2');
            obj.ExecuteLabTalk('layer.y.inc = 1');
            obj.yrescale;
        end
        function logXScale(obj)
            obj.ExecuteLabTalk('layer.x.type = 2');
            obj.ExecuteLabTalk('layer.x.inc = 1');
            obj.xrescale;
        end
        function xAxisAtZero(obj, value)
            if nargin < 2
                value = 1;
            end
            obj.ExecuteLabTalk(['layer.x.atZero = ' value]);
        end
        function yAxisAtZero(obj, value)
            if nargin < 2
                value = 1;
            end
            obj.ExecuteLabTalk(['layer.y.atZero = ' value]);
        end
         function xAxisPosition(obj, value)
            if nargin < 2
                obj.ExecuteLabTalk(['layer.x.position = layer.y.from']);
            else
                obj.ExecuteLabTalk(['layer.x.position = ' value]);
            end
         end
         function yAxisPosition(obj, value)
            if nargin < 2
                obj.ExecuteLabTalk(['layer.y.position = layer.x.from']);
            else
                obj.ExecuteLabTalk(['layer.y.position = ' value]);
            end
         end
         function xPosType(obj, type)
             %Axis position: 0 = "Default position", 1 = "% from left", 2 = "At position =" 
             if nargin < 2
                 type = 0;
             end
             obj.ExecuteLabTalk(['layer.x.postype = ' type ';']);
         end
         function yPosType(obj, type)
             %Axis position: 0 = "Default position", 1 = "% from left", 2 = "At position =" 
             if nargin < 2
                 type = 0;
             end
             obj.ExecuteLabTalk(['layer.y.postype = ' type ';']);
         end
        function xaxis(obj, start, to)
            xaxisStart(obj, start);
            xaxisTo(obj, to);
        end
        function xaxisStart(obj, start)
            obj.ExecuteLabTalk(['layer.x.from = ' num2str(start) ';']);
        end
        function xaxisTo(obj, to)
            obj.ExecuteLabTalk(['layer.x.to = ' num2str(to) ';']);
        end
        function yaxis(obj, start,to)
             yaxisStart(obj, start);
            yaxisTo(obj, to);
        end
        function yaxisStart(obj, start)
            obj.ExecuteLabTalk(['layer.y.from = ' num2str(start) ';']);
        end
        function yaxisTo(obj, to)
            obj.ExecuteLabTalk(['layer.y.to = ' num2str(to) ';']);
        end
        function xfirsttick(obj, value)
            obj.ExecuteLabTalk(['layer.x.firstTick = ' num2str(value) ';']);
        end
        function xlabelincrement(obj,value)
            obj.ExecuteLabTalk(['layer.x.inc  = ' num2str(value) ';']);
        end
        function xlabelMajorTicks(obj, value)
            obj.ExecuteLabTalk(['layer.x.majorTicks = ' num2str(value) ';']);
        end
        function xrescaleMode(obj, value)
            obj.ExecuteLabTalk(['layer.x.rescale = ' num2str(value) ';']);
        end
        function rescale(obj)
            obj.ExecuteLabTalk('layer -a;');
        end
        function xrescale(obj)
            obj.xrescaleMode( 3)
            obj.yrescaleMode( 1)
            obj.rescale();
            obj.xrescaleMode( 2)
            obj.yrescaleMode( 2)
        end
        function yrescale(obj)
            obj.xrescaleMode( 1)
            obj.yrescaleMode( 3)
            obj.rescale();
            obj.xrescaleMode( 2)
            obj.yrescaleMode( 2)
        end
        function yfirsttick(obj, value)
            obj.ExecuteLabTalk(['layer.y.firstTick = ' num2str(value) ';']);
        end
        function ylabelincrement(obj,value)
            obj.ExecuteLabTalk(['layer.y.inc  = ' num2str(value) ';']);
        end
        function ylabelMajorTicks(obj, value)
            obj.ExecuteLabTalk(['layer.y.majorTicks = ' num2str(value) ';']);
        end
        function ytickMode(obj,value)
            %See http://www.originlab.com/doc/LabTalk/ref/Layer-Axis-obj
            %For how value works
            obj.ExecuteLabTalk(['layer.y.ticks  = ' num2str(value) ';']);
        end
        function xtickMode(obj,value)
            %See http://www.originlab.com/doc/LabTalk/ref/Layer-Axis-obj
            %For how value works
            obj.ExecuteLabTalk(['layer.x.ticks  = ' num2str(value) ';']);
        end
        function yrescaleMode(obj, value)
            obj.ExecuteLabTalk(['layer.y.rescale = ' num2str(value) ';']);
        end
        function xshowAxes(obj, value)
            %See http://www.originlab.com/doc/LabTalk/ref/Layer-Axis-obj
            %For how value works
             obj.ExecuteLabTalk(['layer.x.showAxes = ' num2str(value) ';']);
        end
        function yshowAxes(obj, value)
            %See http://www.originlab.com/doc/LabTalk/ref/Layer-Axis-obj
            %For how value works
             obj.ExecuteLabTalk(['layer.y.showAxes = ' num2str(value) ';']);
        end
        function colour = ColourPicker(obj, number)
            if nargin < 2
                number = obj.CurrentPlotNo + 1;
            end
            i  = mod(number , max(size(obj.colourWheel)) );
            if i == 0
                i = 1;
            end
            colour = obj.colourWheel{i};
        end
        function Save(obj, Name)
            %http://www.originlab.com/doc/LabTalk/ref/Save-cmd
            if nargin < 2
                obj.ExecuteLabTalk('save');
            else
                obj.ExecuteLabTalk(['save ' Name]);
            end
        end
        function CloseOrigin(obj)
            invoke(obj.originObj, 'Exit');
            obj.Disconnect;
        end
        function Disconnect(obj)
            delete(obj.originObj);
        end
        %Project managmenet code
        %http://www.originlab.com/doc/LabTalk/guide/Managing-the-Project
        function mkdir_cd(obj, dir)
            mkdir(obj, dir);
            cd(obj, dir);
        end
        function mkdir(obj, dir)
            obj.ExecuteLabTalk(['pe_mkdir "' dir '";']);
        end
        function cd(obj, dir)
            obj.ExecuteLabTalk(['pe_cd "' dir '";']);
        end
        function cd_TopLevel(obj)
            cd(obj, '/');
        end
        function cd_up(obj)
            cd(obj, '..');
        end
        function HideActiveWkBk(obj)
            %http://www.originlab.com/doc/LabTalk/ref/Window-cmd#-h.3B_Hide_the_active_window_but_do_not_change_the_view_mode
            %obj.ExecuteLabTalk(['win -hc 1 ' obj.ActiveWorksheetName ';']);
            obj.HideWindow(obj.ActiveWorksheetName);
        end
        function HideWindow(obj, window)
            %http://www.originlab.com/doc/LabTalk/ref/Window-cmd#-h.3B_Hide_the_active_window_but_do_not_change_the_view_mode
            obj.ExecuteLabTalk(['win -hc 1 ' window ';']);
        end
        function HideActiveWin(obj)
            %http://www.originlab.com/doc/LabTalk/ref/Window-cmd#-ch.3B_Hide_the_active_window_and_change_the_view_mode
            obj.ExecuteLabTalk('window -ch 1;');
        end
        

        
    end
    
end

