% 10/22/2018

% PURPOSE OF THIS FILE: To run today's code

    % try to run ACE on full ripple dataset
        
        core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
        addpath(genpath(core_dir)); 
        base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181022']; 
        mkdir(base_output);
    
    % run ACE normally on new vocalization dataset (70:30)
        
        setStandardACEParams;
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180711_Vocalization_d01' filesep 'ALL_Domo_20180711_Vocalization_d01_finalclusters.mat'];
        output_dir = [base_output filesep '20180711_Vocalization_d01'];
        ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_points)
        setStandardTriadParams;
        probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path, 1);

     % run ACE normally on new vocalization dataset (60:40)
        
        setStandardACEParams;
        output_dir = [base_output filesep '20180711_Vocalization_d01_60_40'];
        p_train = .6;
        ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_points)
        setStandardTriadParams;
        probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path, 1);

     % test J parameter effect on ACE output
        setStandardACEParams;
        
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180807_Ripple2_d01' filesep 'Domo_20180807_Ripple2_d01_finalclusters_firsthalf.mat'];
        output_dir = [base_output filesep '20180807_Ripple2_d01_Jparam_test'];
        setStandardTriadParams;
        p_train = .6;
        testParameterEffectOnACE(data, output_dir, time_units, bin_size, ACE_path, mc_algorithm_path, p_train);