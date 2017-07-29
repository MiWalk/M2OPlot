% ***********************************
% M2OPlot_YOURFORMAT
%   1. Create an appropriately named copy of this file and replace all
%      YOURFORMATS to match the file name
%   2. Edit between the ***** ----- EDIT ------ ****** lines to add your
%      formatting
%
%%***********************************
classdef M2OPlot_YOURFORMAT < M2OPlot
    properties
    end
    
    methods
        function obj = M2OPlot_YOURFORMAT(Name)
            if nargin < 1
                Name = [];
            end
            obj@M2OPlot(Name);
%           ***** ----- EDIT START ------ ******
%           Set the template name you wish to use - can be empty []
            obj.GraphTemplate = 'Color Publication';
%           ***** ----- EDIT END ------ ******
        end
        function FormatGraph(obj)
%           ***** ----- EDIT START ------ ******
%           Place the commands you'd like to see executed on every graph
%           here.
%           You can execute labtalk commands directly or use any of the
%           methods in M2OPlot
%           See http://www.originlab.com/doc/LabTalk/ref/Layer-Axis-obj

            obj.xshowAxes(3);
            obj.yshowAxes(3);
            
            %Line thickness
            obj.ExecuteLabTalk('layer.x.thickness = 2;');
            obj.ExecuteLabTalk('layer.y.thickness = 2;');
            obj.ExecuteLabTalk('layer.x2.thickness = 2;');
            obj.ExecuteLabTalk('layer.y2.thickness = 2;');
            
            %Major ticks
            obj.xlabelMajorTicks(6)
            obj.ylabelMajorTicks(6);
            
            %Major and Minor in (1+4=5 major and minor ticks inside)
            obj.ytickMode(5)
            obj.xtickMode(5)

            %Set formating of fonts
            %http://www.originlab.com/doc/LabTalk/ref/Layer-Axis-Label-obj
            obj.ExecuteLabTalk('layer.x.label.pt = 28;');
            obj.ExecuteLabTalk('layer.y.label.pt = 28;');
            
            obj.ExecuteLabTalk('xb.fsize = 28;');
            obj.ExecuteLabTalk('yl.fsize = 28;');
            
%           ***** ----- EDIT END ------ ******
        end
    end
    
end

