# striatal-action-value-neurons-reconsidered-codes

This folder contains all the MATLAB scripts that are used to simulate and analyze neurons and to create the figures. 
In the main folder there are generate_fig_#/generate_fig_#_supp_# files. Simply running them from the command line will 
generate the relevant figure. For all panels except three, the generate_fig_# files call the relevant simulation and 
analyses functions so that the figures are created from newly run simulations and analyses.

In three cases, because running the code takes time, data is loaded - in Figs 2D, 3B and Fig 2 - supp. 4. 
The codes for these analyses are found in folders by the name analyses_fig_#.

The files are divided between subfolders according to their roles - functions that simulate learning algorithms, 
functions for analyses, and functions for creation of figures. So that each script will typically call functions from 
several different folders.

For all the codes, the path must be defined to include the generate_all_figs folder and all subfolders within it. Running the generate_fig_# files from this folder does this automatically.

The datasets found here consist of the spike counts in trials (see Materials and Methods). 


The auditory cortex data is taken from:
Hershenhoren, I., Taaseh, N., Antunes, F. M., & Nelken, I. (2014). Intracellular Correlates of Stimulus-Specific Adaptation. The Journal of Neuroscience, 34(9), 3303–3319. https://doi.org/10.1523/JNEUROSCI.2166-13.2014

The motor cortex data is taken from recordings conducted by Oren Peles in Eilon Vaadia's lab.

The basal ganglia data is taken from this paper:
Ito, M., & Doya, K. (2009). Validation of Decision-Making Models and Analysis of Decision Variables in the rat basal ganglia. The Journal of Neuroscience, 29(31), 9861–9874. https://doi.org/10.1523/JNEUROSCI.6157-08.2009

The basal ganglia data that was used for the original paper by Ito and Doya appears in https://groups.oist.jp/ncu/data.
To create a matrix of spike counts in trials called here 'basal_ganglia_data' from this data, download the relevant zip file from https://groups.oist.jp/ncu/data. In the current repository, inside the folder 'data_sets_of_recorded_neurons' you will find the script 'create_matrices_of_basal_ganglia_data'. set the path to include the 'data' subfolder within the downloaded zip and run the script. A file called 'basal_ganglia_data.mat' will be generated. This file should be exactly the same as the file by the same name in the 'data_sets_of_recorded_neurons' folder.


