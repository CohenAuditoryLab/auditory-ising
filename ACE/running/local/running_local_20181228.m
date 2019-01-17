% 12/28/2018

% PURPOSE OF THIS FILE: To run today's code

%% set up basics

    core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
    addpath(genpath(core_dir)); 
    base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181228'];
    if (exist(base_output, 'dir') == 0)
        mkdir(base_output);
    end
     
%% comptue higher than 3 graphs

    % re-run ACE
        setStandardACEParams;
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180807_Ripple2_d01' filesep 'Domo_20180807_Ripple2_d01_finalclusters.mat'];
        output_dir = [base_output filesep '20180807_Ripple2_d01'];
        p_train = .6;
        ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_points)
       
    % run triads on them
        setStandardTriadParams;
        probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path, 1);
        
    % run modified higher-order script
        output_dir = [base_output filesep '20180807_Ripple2_d01'];
        setStandardTriadParams;
        strict = 1;
        ensemble_size = [3 4];        
        ensemble_output_dir = [output_dir filesep 'ensembles'];
        probability_of_ensembles(data_path, j_file_path, mc_algorithm_path, ensemble_output_dir, bird, test_logical_path, strict, ensemble_size);
        
        ensemble_size = 5;        
        ensemble_output_dir = [output_dir filesep 'ensembles_5'];
        probability_of_ensembles(data_path, j_file_path, mc_algorithm_path, ensemble_output_dir, bird, test_logical_path, strict, ensemble_size);