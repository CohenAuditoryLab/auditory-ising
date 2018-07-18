function isi_plots(directory) 

%create folder to save plots
mkdir(directory, 'isi_plots');

%load data file
CohenNeurons = load([directory filesep 'CohenNeurons.mat']);
CohenNeurons = CohenNeurons.CohenNeurons;

num_neurons = size(CohenNeurons, 2);

%for each neuron
for n = 1:num_neurons
    disp(['-------NEURON ' num2str(n) ' -------']);
    neuron_num = CohenNeurons(n).ID;
    
    %get all spike times for all trials 
    neuron = CohenNeurons(n);
    t = {neuron.trials(:).spike_times};
    num_trials = size(t, 2);
    
    %calculate interspike intervals for each trial
    isi = [];
    for m = 1:num_trials
        d = diff(t{m});
        isi(end+1:end+length(d)) = d;
    end 
    
    %plot histogram
    figure();
    h = histogram(isi);
    title(['Interspike Interval Histogram, Neuron ' num2str(neuron_num)]);
    xlabel('Interval (ms)');
    ylabel('Frequency');
    set(gca, 'FontSize', 10);
    
    %save 
    filename = [directory filesep 'isi_plots' filesep 'isi_neuron_' num2str(neuron_num)];
    print(filename, '-dpng');
end 

%close all the figures
close all;

end 