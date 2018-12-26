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