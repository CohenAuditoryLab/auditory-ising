A description of all functions: 

BOLTZMANNMETRICS - the full pipeline for producing all Ising model results. Run with path to neuron_trains.mat.

ESTIMATE_ISING_V2 - fits the Ising model, produces firing rate, correlation, and convergence plots.

ISING_PIJK - produces a plot of triplet correlations.

PLOT_NUM_FIRING - original code for plotting probability of n neurons firing.  Plots Ising, independent, and experimental data.

PLOT_NUM_FIRING_V2 - adapted code for plotting probability of n neurons firing.  Plots train, test, and experimental data.  This is the plot that I usually present, since it is closer to that in Gaia's paper.

PATTERN_FREQUENCIES - computes the whole pattern frequency plot for all 2^N patterns.  I usually do not run this script, since it takes a very long time, but it is available if needed.

PATTERN_FREQUENCIES_SUBSET - computes the whole pattern frequency plot for a subset of k neurons.  Is significantly more efficient, as only computes 2^k patterns, where k<N.  I usually set k = 10, as in the literature, but this is an adjustable parameter.

JS_HIST - produces the JS divergence histogram, and saves the divergences in a .mat file.  Also saves the plot automatically as JS_hist.png.  

ISI_PLOTS - produces and saves interspike interval violation plots for neural data. Designed for Sharath data set.

P_DIST - helper function called in JS_hist to compute the probability distribution of a subset of data.

SAMPLE_ISING_EXACT - produces the probability distribution based on model parameters.  Can also be used to produce independent rather than Ising models.

MH_SAMPLE_ISING - helper function in ESTIMATE_ISING_V2. Used in computing new state on each iteration.
