# M2OPlot
An open source MATLAB library to plot data from MATLAB into Origin using simple commands. 
Do your analysis in MATLAB but create plots in Origin.

## Getting Started

1. Ensure the code in this project is on your MATLAB path and you have Origin installed. Note only works on Windows. It has been tested with OriginPro 2015. There may be problems using this with 2016.

2. Here's a quick example  - ensure you have saved your work in Origin before running this code.
```matlab
M2O = M2OPlot();
M2O.PlotScatter([1 2 3 4],[2 4 6 8],'PlotName','green');
```
There are a number of different plotting options. See below, the [examples folder](https://github.com/MiWalk/M2OPlot/tree/master/Examples) and the wiki for more information.

## Applying your style and format

To ensure your figures are formatted in your own or your institutions styles you can create a derived version of M2OPlot.
This means you can set the Origin template that is used and enforce formatting on every graph. There's an example 
provided called M2OPlot_YOURFORMAT.  Simply copy this file, change the name and adapt to your requirements. 
Your plotting code will then work exactly as before.

```matlab
M2O = M2OPlot_YOURFORMAT();
M2O.PlotScatter([1 2 3 4],[2 4 6 8],'PlotName','green');
```

For more information see here.

## More Examples

More examples are provided in the wiki and in the [examples folder](https://github.com/MiWalk/M2OPlot/tree/master/Examples) (under development Oct 2016).

```matlab
M2O = M2OPlot_YOURFORMAT();
M2O.PlotLine([1 2 3 4],[2 4 6 8],'PlotName','green');
M2O.xlabel('X label','X Units');
M2O.ylabel('Y Label','Y Units');
M2O.title('Your graph title');
M2O.yComment('Y Comment');
M2O.HideActiveWkBk();
M2O.Disconnect
```
In particular you can
* Plot line, column, scatter and multi y graphs.
* Add error bars to your data (note requires Origin 9).
* Plot multiple graphs into one figure using Hold and Figure like functionality
* Set the axis labels.
* Set the axis range as fixed or auto scale independently for x and y.
* Set the Ticks inside/outside and the increment.
* Add lines at x = 0 and y = 0
* Navigate the Origin project folders
* Transfer data to a worksheet without plotting

## Important Information
This code is licensed under the MIT License.

The author of this code has no relationship with MATLAB or Origin. 

When the code is started it will connect to an open instance of Origin. If you specify a project it will open that 
project. If another project is open then any unsaved changes will be LOST. Ensure you have saved changes to an open
project before using this code.


