A description of the purpose of all functions: 

PREPROCESSING2 - handles the preprocessing of Sharath data.  Neuron IDs on line 3 should be changed accordingly. Outputs CohenNeurons.mat (structure of neurons and spike times).

SPIKE_TRAIN_GENERATOR2 - the full pipeline for processing Sharath data. Should be run from directory containing CohenNeurons.mat.

SPIKE_TRAIN_PROCESSING2 - Bins spike data from CohenNeurons.mat. Outputs spike_trains.mat, a 3D matrix of mxkxn, where m is # neurons, k is # trials, and n is # bins.  Make sure that bin width is wide enough when calling this function.  Bins that are too small will yield poor Ising models.  For Sharath data, 100 bins is approximately ideal.  The top layer of this 3D array contains TNR values.

VISUALIZE_TNRS2 - outputs TNR_index.mat, which contains TNRs per trial.  Also plots TNR values for visualization of distribution.

CONCATENATE_TRAINS2 - Sorts spike trains by TNR.  Concatenates spike trains such that all trains for same neuron and same TNR are stored in the same array.  Outputs sorted_trains.mat, which is an nxm cell array where n is # neurons and m is # TNR values.

CREATE_NEURON_TRAINS2 -  Concatenates all trials for same neuron in increasing order of TNR.  Outputs neuron_trains.mat, which contains a cell array of n cells, where n is the # of neurons in the data set.  Each cell contains a single spike train for that neuron.  This output file is the file that is fed into the Ising model.

PREPROCESSING_DOMO - handles the preprocessing of Domo data for use in Ising models.  Produces the files CohenNeurons.mat (structure of neurons and spike times), spike_trains.mat (matrix of spike counts for all trials for all neurons), and neuron_trains.mat (the final spike trains, with -1 and 1 only). This script can be run independently.

FIND_AUDITORY_NEURONS - Takes a sorted tank of Domo data (from wave_clus) and the corresponding behavioral data and determines the auditory neurons by comparing the number of spikes when the stimulus is off to the number of spikes when the stimulus is on.

AUDITORY_AFTER_STIM - produces a trial-by-trial CohenNeurons.mat file from Domo data tank (intended to be used with auditory neurons output from FIND_AUDITORY_NEURONS.M).  Output file can be used in other preprocessing functions in the pipeline, as described above. Treats stimulus difference as TNR for postprocessing purposes.

TDT2ISING - converts TDT spike timestamps (in Taku's format, where stim on time is in seconds and spike time is in ms, centered around the stimulus onset) into format to be run in Ising models, where each channel is treated as a single cell.
