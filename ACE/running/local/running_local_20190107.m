% 01/07/2019
% PURPOSE OF THIS FILE: To run today's code

% To run ACE on a newly sorted 8/20 dataset

%% set up basics

    core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
    addpath(genpath(core_dir)); 
    base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20190114'];
    if (exist(base_output, 'dir') == 0)
        mkdir(base_output);
    end
    
%% run sorting metrics on newly sorted 8/20 data
    data_dir_or_file = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/20180820_Ripple2_d03/new_sorted';
    data_type = 'wave';
    new_directory = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/20180820_Ripple2_d03/new_sorted/metrics';
    sampling_rate = 0;
    just_isi = false;
    sorting_metrics(data_dir_or_file, data_type, new_directory, sampling_rate, just_isi);

%% run ACE on output from sorting metrics from newly sorted 8/20 data

    setStandardACEParams;
    data = '/Users/mschaff/Documents/mabs_waveclus3/20180820_Ripple2_d03/mabs_waveclus3_20180820_Ripple2_d03_finalclusters.mat';
    output_dir = [base_output filesep '20180820_Ripple2_d03'];
    p_train = .6;
    ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_points);
    
%% run subset ACE on newly sorted 8/20 data (20180711_Vocalization_d01)
    
    output_dir = [base_output filesep '20180820_Ripple2_d03_new_subsets'];
    if (exist(output_dir, 'dir') == 0)
        mkdir(output_dir);
    end
    % get raw data & num neurons
    data = [core_dir filesep 'data' filesep 'ACE' filesep '20180820_Ripple2_d03' filesep 'new_sorted' filesep '20180820_Ripple2_d03_new_sorted_finalclusters.mat'];
    same_split = true;
    runACEonSubsets(data, output_dir, same_split);