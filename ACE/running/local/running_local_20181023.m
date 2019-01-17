% 10/23/2018

% PURPOSE OF THIS FILE: To run today's code

    % try to run ACE on full ripple dataset
        
        core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
        addpath(genpath(core_dir)); 
        base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181023']; 
        mkdir(base_output);
    
    % run ACE normally on 20180821_Ripple2_d01 dataset (70:30)
        
        setStandardACEParams;
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180821_Ripple2_d01' filesep 'newDomoData_20180821_Ripple2_d01_finalclusters.mat'];
        output_dir = [base_output filesep '20180821_Ripple2_d01'];
        p_train = .6;
        ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_points)
        setStandardTriadParams;
        probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path, 1);
        
     % run ACE normally on 20180820_Ripple2_d03 dataset (70:30)
        
        setStandardACEParams;
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180820_Ripple2_d03' filesep 'WCSpikeSorting_20180820_Ripple2_d03_finalclusters.mat'];
        output_dir = [base_output filesep '20180820_Ripple2_d03'];
        p_train = .6;
        ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_points)
        setStandardTriadParams;
        probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path, 1);
        
    % run ACE normally on 20180917_Ripple_d01 dataset (60:40)
        
        setStandardACEParams;
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180917_Ripple_d01' filesep 'newDomoData_20180917_Ripple_d01_finalclusters.mat'];
        output_dir = [base_output filesep '20180917_Ripple_d01'];
        p_train = .6;
        ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_points)
        setStandardTriadParams;
        probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path, 1);

    % run ACE normally on 20180917_Ripple_d01 dataset (70:30)
        
        setStandardACEParams;
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180917_Ripple_d01' filesep 'newDomoData_20180917_Ripple_d01_finalclusters.mat'];
        output_dir = [base_output filesep '20180917_Ripple_d01_70_30'];
        p_train = .7;
        ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_points)
        setStandardTriadParams;
        probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path, 1);