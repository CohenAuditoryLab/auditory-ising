% 12/28/2018

% PURPOSE OF THIS FILE: To run today's code

%% set up basics

    core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
    addpath(genpath(core_dir)); 
    base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20190102'];
    if (exist(base_output, 'dir') == 0)
        mkdir(base_output);
    end
%% re-generate bad dataset for Clelia
    % set vars
    setStandardACEParams;
    data = [core_dir filesep 'data' filesep 'ACE' filesep '20180820_Ripple2_d03' filesep 'WCSpikeSorting_20180820_Ripple2_d03_finalclusters.mat'];
    p_train = .6;
    chunk = false;
    chunk_size = 1e4;
    
    % 20ms bins
    output_dir = [base_output filesep '20180820_Ripple2_d03_20ms_bin'];
    spikes_data = [output_dir filesep 'spikes_by_bin.mat'];
    generateACEinputSpikeTimes(data, time_units, bin_size, output_dir, chunk, indep_c_ij, chunk_size, p_train);
    spikes_by_bin_20 = load([output_dir filesep 'spikes_by_bin.mat']);
    
    % 1ms bins
    output_dir = [base_output filesep '20180820_Ripple2_d03_1ms_bin'];
    spikes_data = [output_dir filesep 'spikes_by_bin.mat'];
    bin_size = 1e-3;
    generateACEinputSpikeTimes(data, time_units, bin_size, output_dir, chunk, indep_c_ij, chunk_size, p_train);
    spikes_by_bin_1 = load([output_dir filesep 'spikes_by_bin.mat']);
    
%% ask if the spike sums are equal
    for i=1:7 % cause there are 7 neurons in this dataset
        sum_20 = sum(spikes_by_bin_20.spikes_by_bin(i,:));
        sum_1 = sum(spikes_by_bin_1.spikes_by_bin(i,:));
        disp(['1 sum: ' num2str(sum_1) '; 20 sum: ' num2str(sum_20)]);
    end

%% play with histc
    % set vars
    setStandardACEParams;
    data = [core_dir filesep 'data' filesep 'ACE' filesep '20180820_Ripple2_d03' filesep 'WCSpikeSorting_20180820_Ripple2_d03_finalclusters.mat'];
    p_train = .6;
    chunk = false;
    chunk_size = 1e4;
    
    % 20ms bins
    output_dir = [base_output filesep '20180820_Ripple2_d03_20ms_bin'];
    spikes_data = [output_dir filesep 'spikes_by_bin.mat'];
    bin_size = 20e-3;
    generateACEinputSpikeTimes(data, time_units, bin_size, output_dir, chunk, indep_c_ij, chunk_size, p_train);
    generateDataForClelia(spikes_data, output_dir);
    spikes_by_bin_20 = load([output_dir filesep 'spikes_by_bin.mat']);
    
    % 1ms bins
    output_dir = [base_output filesep '20180820_Ripple2_d03_1ms_bin'];
    spikes_data = [output_dir filesep 'spikes_by_bin.mat'];
    bin_size = 1e-3;
    generateACEinputSpikeTimes(data, time_units, bin_size, output_dir, chunk, indep_c_ij, chunk_size, p_train);
    generateDataForClelia(spikes_data, output_dir);
    spikes_by_bin_1 = load([output_dir filesep 'spikes_by_bin.mat']);
    