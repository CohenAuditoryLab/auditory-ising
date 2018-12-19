% 12/17/2018

% PURPOSE OF THIS FILE: To investigate the weird datasets

% steps
    % - re-run ACE on weird dataset 1
    % - look at graphs of weird dataset 1
    % - play around with output of weird dataset 1 (pseudo shuffle maybe)
    
    % - check JSD of shuffled good dataset
    % - run ACE then all-JSD on subsets of the good dataset

%% set up basics

    core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
    addpath(genpath(core_dir)); 
    base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181217']; 
    if (exist(base_output, 'dir') == 0)
        mkdir(base_output);
    end
    
%% re-run ACE on weird datset 1
    
    setStandardACEParams;
    data = [core_dir filesep 'data' filesep 'ACE' filesep '20180820_Ripple2_d03' filesep 'WCSpikeSorting_20180820_Ripple2_d03_finalclusters.mat'];
    output_dir = [base_output filesep '20180820_Ripple2_d03'];
    p_train = .6;
    ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_points)
    setStandardTriadParams;
    probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path, 1);
    
%% look at graphs of weird dataset 1
    
    data_path = [output_dir filesep 'figures' filesep 'pattern_freqs_all.mat'];
    probs = load(data_path);
    plotAllJSD(output_dir);
    
%% re-run ACE on weird datset 1 - indep c_ij

    setStandardACEParams;
    data = [core_dir filesep 'data' filesep 'ACE' filesep '20180820_Ripple2_d03' filesep 'WCSpikeSorting_20180820_Ripple2_d03_finalclusters.mat'];
    output_dir = [base_output filesep '20180820_Ripple2_d03_indep_cij'];
    p_train = .6;
    indep_c_ij = 1;
    ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_points);
    setStandardTriadParams;
    probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path, 1);data_path = [output_dir filesep 'figures' filesep 'pattern_freqs_all.mat'];
    plotAllJSD(output_dir);
    
%% compare h parameters between indep and ising

    plotParameterH_indep_v_ising(output_dir);
        
%% - check JSD of shuffled good dataset
    
    % copy shuffled output to output
        old_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181025' filesep '20180807_Ripple2_d01_60_40_indep_cij'];
        new_output = [base_output filesep '20180807_Ripple2_d01_60_40_indep_cij'];
        if (exist(new_output, 'dir') == 0)
            mkdir(new_output);
            copyfile(old_output, new_output);
        end
        output_dir = new_output;
        plotAllJSD(output_dir);
   
