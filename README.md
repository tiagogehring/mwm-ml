# Introduction

This repository hosts code that can be used to analyse the trajectories of animals by means of a semi-supervised clustering algorithm.

For more details of the analysis procedure, as applied to trajectories in the Morris Water Maze, please refer to Gehring et al., 2015. The data used in this article is also provided here as an example application of the code (data/mwm_peripubertal_stress folder).

Please note that, although this code was initially applied to trajectories in the Morris Water Maze, the method is general enough as to be applied to other types of experiment.

## Provided functions

The following main functionality is provided in this repository:

- A graphical user interface (GUI) for browsing and tagging trajectories or segments of trajectories (gui/browse_trajectories.m). From the GUI a secondary window providing multiple data visualizations (such as individual feature values and clusters) can be accessed. The GUI can also start the semi-supervised clustering algorithm used to classify similar trajectories/segments;

- Semi-supervided clustering algorithm (semisupervised_clustering.m): this class is a frontend for the MPCKmeans semi-supervised algorithm. It uses manually labelled data (provided as mapping from trajectory segments to of one or more behavioural classes) to define *must-link* and *cannot-link* constraints. Again, for more details see the reference above.

- Plotting routines for plotting trajectories (plot_trajectory.m) or the classification results in the form of color bars (one color for each behavioural class) for each trajectory (plot_distribution_strategies.m);

- Various other functions for analyzing and validating the clustering results. These are spread over a set of classes (e.g. trajectories, confusion_matrix, clustering_resuls). See the results/mwm folder for examples on how to use those functions (the functions in this folder were used to generate the results and figures used in the publication referenced above which compared the behaviour of stressed and non-stressed rats in the MWM).

# Using the code

In order to open the GUI with the default configuration loaded (using the data from the paper above) run *initialize* and then *browse_set(2,0)*. The former command is used to initialize the environment and load the Java package that implements the clustering algorithm. The latter command opens the GUI using the configuration number 2 (segmented swimming paths) without any reference configuration (which can specified to compare results). The full (i.e. non-segmented) trajectories can be visualized by calling *browse_set(1,0)* after *initialize*.  

The figures from the paper, as well as other results, can be generated by calling the scripts available in the *results/mwm* folder. For convenience a script called *ALL_RESULTS*, which generates all the results from the paper, is also provided.

# MATLAB Toolboxes required

This code requires the statistics and machine learning toolbox in addition to MATLAB itself.

# Using the GUI

The GUI (shown below) can be used to label path segments, cluster the data and visualize the clustering results.

![GUI](gui.png?raw=true "GUI")

## Labels

Multiple labels or tags (shown to the right of each path) can be defined per trajectory. Tags are automatically saved to a file defined in the configuration file; to change the output file name where the tags are saved and define new tags (among other things) please refer to the next Section.  

## Changing the visualization

The default 2x2 view layout can be changed by selecting a different number of X and Y views in the bottom right control group in the GUI. There the main visualization and up to 2 secondary ones can also be selected (these are experiment dependent and defined in the main configuration file).

## Filtering and sorting segments

Group of segments fulfilling certain criteria (e.g. all segments that are tagged/non-tagged or which belong to a certain cluster or class) can be selected by using the group of controls found in the bottom left. Segments can also be sorted according to a specific feature or, for example, according to their distance to the cluster centroids (useful for identifying edge cases of segments falling between two behavioural classes).  

## Running the clustering algorithm

The clustering algorithm can be run by clicking in the "cluster" button. Before doing so it is necessary to select a target number of clusters (done also directly in the GUI). After running the clustering results will be automatically shown; segments of specific classes or that were wrongly classified (available if the "cross-validation" option is active) can be selected by using the filtering options.  

# Adapting the code to other experiments

To adapt the code for other experiments a configuration file has to be provided. This configuration is merely a global object containing some variables and methods which is then referenced by various parts of the code. The configuration file is also used to define the data loading function, segmentation methods of the swimming paths and features used in during the clustering procedure. See config/morris_water_maze/config_mwm.m for an example of such a file (this is the configuration used for the analyzes in the aforementioned publication).

Before running any routines provided here please call the *initialize* function first. This function has to also be changed accordingly with the desired configuration file that is to be used.


For more information feel free to contact Tiago Gehring (tiagogehring@gmail.com).
