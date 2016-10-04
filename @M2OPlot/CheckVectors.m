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

function [error, Xout, Yout, nRows, nX,nY] = CheckVectors(obj, Xin, Yin)
Xout = Xin;
Yout = Yin;
error = 0;
nRows = max(size(y));
nX = min(size(X));
nY = min(size(Y));

%Need to work out the sizes of the data set and ensure the X
%and Y have the same number of rows
%Need X to be either 1, or equal to the no of Y cols
%Need to output the data in the correct format
[x_rows, x_cols] = size(Xin);
[y_rows, y_cols] = size(Yin);

%Now work out which way round they should be - accepts single
%x, multi Y - so use X to determine the direction
%But also can have multi X and Multi Y

%Find which direction of X  and Y match

end

