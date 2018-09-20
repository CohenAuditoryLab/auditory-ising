function all_violations = isi_plots(directory)

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

%close all the figures
close all;

labels = categorical(cell2mat({CohenNeurons(:).ID}));
bar(labels, all_violations)

end

% function plotRaster(tVec)
% hold all;
% for trialCount = 1:size(tVec,2)
%     spikePos = tVec{trialCount};
%     spikePos = spikePos(spikePos > 0);
%     for spikeCount = 1:length(spikePos)
%         plot([spikePos(spikeCount) spikePos(spikeCount)], ...
%             [trialCount-0.4 trialCount+0.4], 'k');
%     end
% end
% ylim([0 size(tVec, 2)+1]);
% end 