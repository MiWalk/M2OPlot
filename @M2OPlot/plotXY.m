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

function plotName = plotXY(obj,X,Y,E,type,plotName,colour)
%http://www.originlab.com/doc/LabTalk/guide/Creating-Graphs#Plotting_X_Y_data
% Type is plot Type ID as here: http://www.originlab.com/doc/LabTalk/ref/Plot-Type-IDs
%Create Worksheet  - unless it already exists?
NoCols = size(Y',2);
%Reshape and check sizes here.
%[error, Xout, Yout, nRows, nX,NoCols] = CheckVectors(obj, Xin, Yin)
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
    %Activate a graph page by name  - so you don't have to plot
    %into the current graph - if graph doesn't exist it won't
    %change
    if nargin > 6
        obj.ActivateGraphPage(plotName);
    end
end
%PLot into existing graph layer 1  - or on to a new layer?
for i = 1:NoCols
    if e == 0
        obj.ExecuteLabTalk(['plotxy iy:=[' Wks ']Sheet1!(1,' num2str(1+i) ' ) plot:=' type ' ogl:=[' obj.ActiveGraphName ']' num2str(obj.CurrentLayer) '!;'] );
    else
        %Add Error Bars
        ErrorCol = NoCols + i+1;
        obj.ExecuteLabTalk(['plotxy iy:=[' Wks ']Sheet1!(1,' num2str(1+i) ',' num2str(ErrorCol) ') plot:=' type ' ogl:=[' obj.ActiveGraphName ']' num2str(obj.CurrentLayer) '!;'] );
        obj.ExecuteLabTalk('lay -i %W_C;');
    end
    obj.CurrentPlotNo = obj.NoPlots + 1;
    obj.NoPlots = obj.NoPlots + 1;
    %disp([obj.ActiveGraphName ' ' num2str(obj.CurrentPlotNo)]);
    obj.ActivatePage(obj.ActiveGraphName);
    obj.ExecuteLabTalk(['layer.plot = ' num2str(obj.CurrentPlotNo) ';']);
    obj.ExecuteLabTalk(['set %C -cl color(' colour ');']);
    obj.ExecuteLabTalk('set %C -w 1000;');
    obj.ExecuteLabTalk(['set %C -c color(' colour ');']);
    obj.ExecuteLabTalk(['set %C -cf color(' colour ');']);
end

obj.ExecuteLabTalk(['page.lname$= ' obj.ActiveGraphName ';'] );

obj.FormatGraph;
plotName = obj.ActiveGraphName;
obj.ActivatePage(obj.ActiveGraphName)
end
