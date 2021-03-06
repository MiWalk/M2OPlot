% ***********************************
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

function plotName = plotHist(obj,Y,plotName,colour)
%http://www.originlab.com/doc/LabTalk/guide/Creating-Graphs#Plotting_X_Y_data
% Type is plot Type ID as here: http://www.originlab.com/doc/LabTalk/ref/Plot-Type-IDs
%Create Worksheet  - unless it already exists?
NoCols = size(Y',2);
%Reshape and check sizes here.

Wks = CreateWorkSheet(obj,[plotName ' Data']);
%Put Data into Worksheet
obj.MatrixToOrigin( Y');
%1 column set as Y Type
obj.ExecuteLabTalk( 'wks.col1.type=1;' )

%Create a Graph Page;
if obj.Hold == 0
    obj.CreateGraphPage(plotName);
else
    %Adding to a plot so implement plot no
    %Increasing the layer is done by a separat func
    %obj.CurrentPlotNo = obj.NoPlots + 1;
    %obj.NoPlots = obj.NoPlots + 1;
    if nargin > 3
        obj.ActivateGraphPage(plotName);
    end
end
%PLot into existing graph layer 1  - or on to a new layer?
for i = 1:NoCols
    obj.ExecuteLabTalk(['plotxy iy:=[' Wks ']Sheet1!(1) plot:=219 ogl:=[' obj.ActiveGraphName ']' num2str(obj.CurrentLayer) '!;'] )
    obj.CurrentPlotNo = obj.NoPlots + 1;
    obj.NoPlots = obj.NoPlots + 1;
    
    obj.ActivatePage(obj.ActiveGraphName)
    obj.ExecuteLabTalk(['layer.plot = ' num2str(obj.CurrentPlotNo) ';']);
    obj.ExecuteLabTalk(['set %C -cl color(' colour ');']);
    obj.ExecuteLabTalk('set %C -w 1000;');
    obj.ExecuteLabTalk(['set %C -c color(' colour ');']);
    obj.ExecuteLabTalk(['set %C -cf color(' colour ');']);
end

obj.ExecuteLabTalk(['page.lname$= ' obj.ActiveGraphName ';'] )

obj.FormatGraph;
plotName = obj.ActiveGraphName;
obj.ActivatePage(obj.ActiveGraphName)
end

