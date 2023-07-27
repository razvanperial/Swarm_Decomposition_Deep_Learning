# A Deep Learning approach into classifying Swarm Decomposition filtered data

This repository contains the data files and necesarry code behind using a dataset composed of EEG signals for a **deep learning** classification task, using the approach from the paper *Bullying incidences identification within an immersive environment using HD EEG-based analysis: A Swarm Decomposition and Deep Learning approach*, which can be found under this [link](https://www.nature.com/articles/s41598-017-17562-0).

The main idea here was to use Swarm Decomposition (a novel signal analysis technique) to apply certain filters to our data, which will then be inputted into a Convolutional Neural Network in order to solve a binary classification task.

More info regarding Swarm Decomposition can be found in the following paper: [link](https://www.sciencedirect.com/science/article/pii/S0165168416302304).

### Datasets
- **initial data** - the initial dataset, composed of EEG signals gatherd from 14 test subjects, 7 belonging to the control group and 7 belonging to the clinical group. The subjects were presented with a specific instruction representing one of 2 possibilities: *walk* or *dance*. We then have 2 crucial time intervals, one representing the EEG signals emmitted by the brain while the instruction was being processed (noted as *inst* in the datasets) and one representing the EEg signals emmited by the brain while performing the specific actian. Finally, one extra split in the data came from the initial filtering of the signals, thus splitting each dataset into 2: raw data and clean/filtered data.
- **initial_filtered_data** - here we can see the data resulted from executing the code found in the **prepare_data** directory, which simply trims the signals, eliminates the discontinuities and applies a bandpass filter to the data.
- **swd_data** - here we can see the data resulted from applying the Swarm Decomposition algorithm to the initial filtered data. This dataset is going to be used as an input to our CNN.

Please note that due to privacy reasons, the data is not available in this repository, but with small modifications to the code, you can use your own data.

The classifications task can be described as follows: given a dataset of EEG sygnals, we want to be able to classify them into one of 2 categories: *control* or *clinical*. Notice that the files are named using 2 prefixes: **P** (clinical) and **S**(control). 

### Code
In order to run the code, you will need to have the following dependencies installed:
- numpy
- scipy
- matplotlib
- sklearn
- keras
- tensorflow

Furthermore, in the **functions** directory you can find the following files:
- **bandpass.ipynb** - contains the code for applying a bandpass filter to the data
- **get_data.ipynb** - contains the code for reading the data from the initial dataset
- **trimmer.ipynb** - contains the code for trimming the data

In the **models** directory you can find the following directories:
- **prepare_data** - this contains the code for doing the initial filtering of the data. The results will be stored inthe **initial_filtered_data** directory. Using these files, you can run the **swd_execution** file from the **matlab_code** directory in order to apply the Swarm Decomposition algorithm to the data. Note that you will have to add the files from the **initial_filtered_data** directory to the **matlab_code** directory in order to run the code. Once you have the results, you can add them to the **swd_data** directory.
- the other 2 direactories contain the code for building the CNN and training it on the datafiltered using Swarm Decomposition. 

Note: the matlab code used for Swarm Decomposition was provided by the following repository: [link](https://github.com/gkaposto/Swarm-Decomposition)