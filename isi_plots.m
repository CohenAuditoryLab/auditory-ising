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
    for m = 1:num_trials
        spike_t = t{m};
        spike_t = spike_t(spike_t > 0);
        d = diff(spike_t);
        isi = horzcat(isi, d);
    end
    
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
    end
end

%close all the figures
close all;

labels = categorical(cell2mat({CohenNeurons(:).ID}));
bar(labels, all_violations)
title('Fraction of ISI Violations');
xlabel('Neuron');
ylabel('Fraction Violations/# Spikes');

end