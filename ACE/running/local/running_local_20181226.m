% 12/21/2018

% PURPOSE OF THIS FILE: To run today's code

%% set up basics

    core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
    addpath(genpath(core_dir)); 
    base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181226'];
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
    generateDataForClelia(spikes_data, output_dir);
    
    % 1ms bins
    output_dir = [base_output filesep '20180820_Ripple2_d03_1ms_bin'];
    spikes_data = [output_dir filesep 'spikes_by_bin.mat'];
    bin_size = 1e-3;
    generateACEinputSpikeTimes(data, time_units, bin_size, output_dir, chunk, indep_c_ij, chunk_size, p_train);
    generateDataForClelia(spikes_data, output_dir);
    
%% look at firing rates of good & bad dataset
    % make dir
        investigate_dir = [base_output filesep 'good_vs_bad_data'];
        if (exist(investigate_dir, 'dir') == 0)
            mkdir(investigate_dir);
        end
    % package data
        setStandardACEParams; chunk = false; chunk_size = 1e4;
        
        % package bad data
            data = [core_dir filesep 'data' filesep 'ACE' filesep '20180820_Ripple2_d03' filesep 'WCSpikeSorting_20180820_Ripple2_d03_finalclusters.mat'];
            output_dir = [investigate_dir filesep '20180820_Ripple2_d03'];
            generateACEinputSpikeTimes(data, time_units, bin_size, output_dir, chunk, indep_c_ij, chunk_size, p_train);
            
        % package good data
            data = [core_dir filesep 'data' filesep 'ACE' filesep '20180807_Ripple2_d01' filesep 'Domo_20180807_Ripple2_d01_finalclusters.mat'];
            output_dir = [investigate_dir filesep '20180807_Ripple2_d01'];
            generateACEinputSpikeTimes(data, time_units, bin_size, output_dir, chunk, indep_c_ij, chunk_size, p_train);
            
        % get bad package & good package
            good_spikes_by_bin = load([investigate_dir filesep '20180807_Ripple2_d01' filesep 'spikes_by_bin.mat']);
            good_spikes_by_bin = good_spikes_by_bin.spikes_by_bin;
            bad_spikes_by_bin = load([investigate_dir filesep '20180820_Ripple2_d03' filesep 'spikes_by_bin.mat']);
            bad_spikes_by_bin = bad_spikes_by_bin.spikes_by_bin;
        
     % firing rates for all neurons in bad dataset
        firing_rate_graph(bad_spikes_by_bin, bin_size, [investigate_dir filesep '20180820_Ripple2_d03']);
    
    % firing rates for all neurons in good dataset
        firing_rate_graph(good_spikes_by_bin, bin_size, [investigate_dir filesep '20180807_Ripple2_d01']);
        
        
        
        