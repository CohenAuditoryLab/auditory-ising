function all_violations = isi_plots(directory)

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
    
    %plot histogram
%     figure();
%     h = histogram(isi, 0:5:1000);
%     title(['Interspike Interval Histogram, Neuron ' num2str(neuron_num) ...
%         '; Violation Rate: ' num2str(violation_rate*100) '%']);
%     xlabel('Interval (ms)');
%     ylabel('Frequency');
%     set(gca, 'FontSize', 8);
    
    %save
%     filename = [directory filesep 'isi_plots' filesep 'isi_neuron_' num2str(neuron_num)];
%     print(filename, '-dpng');
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