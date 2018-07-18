function [] = spike_train_generator2()

% Create spike trains for all 16 x 464 trials
spike_train_processing2(20, 2000);

% Sort trials by TNR and visualize the results
visualize_tnrs2();

% Concatenate spike trains to get 1 train for every neuron at every TNR
concatenate_trains2();

% Concatenate spike trains to get 1 train for every neuron
create_neuron_trains2();

end