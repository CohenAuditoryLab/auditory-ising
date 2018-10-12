% load data
    disp('Loading data.');
    sim_data_matt = importdata('/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/MC_result/MC_output_matt.dat');
    sim_data_eve = importdata('/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/MC_result/MC_output_eve.dat');
    load('/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/bin_by_bird.mat');
    data_bird = spikes_by_bin';
    disp('Data loaded.');
% invert numbers
    sim_data_eve = sim_data_eve*-1+1;
    sim_data_matt = sim_data_matt*-1+1;
% get possible triad patterns
    num_birds = size(data_bird,2);
    triad_patterns = nchoosek(1:num_birds,3);
    num_patterns = size(triad_patterns,1);
    triad_patterns_binary = zeros([num_patterns num_birds]);
    for i=1:num_patterns
        triad_patterns_binary(i,triad_patterns(i,:)) = 1;
    end
% measure frequencies over triad patterns
    
    % bird data
    disp('Counting triads over bird data');
    freq_data = count_pattern_freq(data_bird, triad_patterns_binary, num_patterns);
    
    % matt simulated data
    disp('Counting triads over bird data simulated from Matts .j file');
    freq_matt = count_pattern_freq(sim_data_matt, triad_patterns_binary, num_patterns);
    % eve simulated data
    disp('Counting triads over bird data simulated from Eves .j file');
    freq_eve = count_pattern_freq(sim_data_eve, triad_patterns_binary, num_patterns);

    % save triad frequencies
    save('triad_frequencies.mat', 'freq_data', 'freq_eve', 'freq_matt');