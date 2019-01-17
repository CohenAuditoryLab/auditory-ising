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

%% run metrics on sorted 8/20 data with waveclus 3

    data_dir_or_file = '/Users/mschaff/Documents/mabs_waveclus3/20180820_Ripple2_d03';
    data_type = 'wave';
    new_directory = '/Users/mschaff/Documents/mabs_waveclus3/20180820_Ripple2_d03/metrics';
    sampling_rate = 0;
    just_isi = false;
    sorting_metrics(data_dir_or_file, data_type, new_directory, sampling_rate, just_isi);
    
%% ACE
    
    setStandardACEParams;
    data = '/Users/mschaff/Documents/mabs_waveclus3/20180820_Ripple2_d03/mabs_waveclus3_20180820_Ripple2_d03_finalclusters.mat';
    output_dir = [base_output filesep '20180820_Ripple2_d03'];
    p_train = .6;
    ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_points);