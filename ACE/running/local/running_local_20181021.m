% 10/21/2018

% PURPOSE OF THIS FILE: To run today's code

    % try to run ACE on full ripple dataset
        
        core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
        addpath(genpath(core_dir)); 
        base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181021']; 
        mkdir(base_output);
        
    % run ACE mutiple
        ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180807_Ripple2_d01' filesep 'Domo_20180807_Ripple2_d01_finalclusters_firsthalf.mat'];
        output_dir = [base_output filesep '20180807_Ripple2_d01_60_40_firsthalf'];
        time_units = 1e-3;
        bin_size = 20e-3;
        p_train = .6;
        mc_algorithm_path = '/Users/mschaff/Documents/REPOS/QEE';
        multipleRunACE(data, output_dir, time_units, bin_size, ACE_path, mc_algorithm_path, p_train);