function all_violations = isi_plots(directory, save_on)
%% Function calculates isi violations for set of neurons.  
%
% DIRECTORY is the folder in which the file 'CohenNeurons.mat' is found.
% This file should refer to the neurons to be calculated.
%
% SAVE_ON is a string. If the string is 'y', then all the individual ISI
% histograms will be automatically saved in a new folder in DIRECTORY.  
% Otherwise, they will not be produced.

%create folder to save plots
mkdir(directory, 'isi_plots');

%load data file
CohenNeurons = load([directory filesep 'CohenNeurons.mat']);
CohenNeurons = CohenNeurons.CohenNeurons;

num_neurons = size(CohenNeurons, 2);

all_violations = zeros(1, num_neurons);

    bin_length = 1;
    trial_length = 2000;
    num_neurons = 16;
    num_trials = 464;
    all_spikes_labels_array = [];
    all_spikes_labels_array = reshape(all_spikes_labels_array, [0,2]);
    for i = 1:num_neurons
        % For each trial...
        spikes_array = [];
        spikes_array = reshape(spikes_array, [0,1]);
        for j = 1:num_trials
            % add to array spikes from this neuron & this trial
            spikes_array = vertcat(spikes_array, CohenNeurons(i).trials(j).spikes.' + trial_length*(j-1));
            % add to array the ID of the neuron
            label = zeros(size(spikes_array,1), 1); label(:) = CohenNeurons(i).ID;
            % combine IDs & spikes
            spikes_labels_array = horzcat(spikes_array, label);
        end
        % collect all neuron ID & spikes into one array
        all_spikes_labels_array = vertcat(all_spikes_labels_array, spikes_labels_array);
    end
    spike_times = all_spikes_labels_array(:,1);
    spike_clusters = all_spikes_labels_array(:,2);

%for each neuron
for n = 1:num_neurons
    disp(['-------NEURON ' num2str(n) ' -------']);
    neuron_num = CohenNeurons(n).ID;
    
    %get all spike times for all trials
    neuron = CohenNeurons(n);
    t = {neuron.trials(:).spikes};
    num_trials = size(t, 2);
    
    %calculate interspike intervals for each trial
    isi = [];
    spikes = [];
    for m = 1:num_trials
        spike_t = t{m};
        %spike_t = spike_t(spike_t > 0);
        d = diff(spike_t);
        isi = horzcat(isi, d);
        spikes = horzcat(spikes, spike_t + 10000*(m-1));
    end
    what = diff(spikes);
    violation_rate_what = sum(what < 3) / length(what);
    what2 = numel(isi);
    violation_rate = sum(isi < 3) / length(isi);
    all_violations(n) = violation_rate;
    
    if strcmp(save_on, 'y')
    %plot histogram
    figure();
    h = histogram(isi, 0:5:1000);
    title(['Interspike Interval Histogram, Neuron ' num2str(neuron_num) ...
        '; Violation Rate: ' num2str(violation_rate*100) '%']);
    xlabel('Interval (ms)');
    ylabel('Frequency');
    set(gca, 'FontSize', 8);
    
    %save
    filename = [directory filesep 'isi_plots' filesep 'isi_neuron_' num2str(neuron_num)];
    print(filename, '-dpng');

%close all the figures
close all;

labels = categorical(cell2mat({CohenNeurons(:).ID}));
bar(labels, all_violations)
title('Fraction of ISI Violations');
xlabel('Neuron');
ylabel('Fraction Violations/# Spikes');

end
