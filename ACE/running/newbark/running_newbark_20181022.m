% 10/22/2018

% PURPOSE OF THIS FILE: To run today's code

    % try to run ACE on full ripple dataset
        
        core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
        addpath(genpath(core_dir)); 
        base_output = [core_dir filesep 'output' filesep 'ACE_newbark' filesep '20181022']; 
        mkdir(base_output);

     % test J parameter effect on ACE output
        setStandardACEParams;
        setStandardTriadParams;
        mc_algorithm_path = '/home/matt/Documents/QEE';
        ACE_path = '/home/matt/Documents/ACE';
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180807_Ripple2_d01' filesep 'Domo_20180807_Ripple2_d01_finalclusters_firsthalf.mat'];
        output_dir = [base_output filesep '20180807_Ripple2_d01_Jparam_test'];
        p_train = .6;
        testParameterEffectOnACE(data, output_dir, time_units, bin_size, ACE_path, mc_algorithm_path, p_train);