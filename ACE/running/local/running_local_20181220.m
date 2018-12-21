% 12/20/2018

% PURPOSE OF THIS FILE: To run today's code

%% set up basics

    core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
    addpath(genpath(core_dir)); 
    base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181220'];
    if (exist(base_output, 'dir') == 0)
        mkdir(base_output);
    end
    output_dir = [base_output filesep '20180807_Ripple2_d01_60_40'];
    if (exist(output_dir, 'dir') == 0)
        mkdir(output_dir);
    end

%% - run ACE and then run all-JSD on subsets of the good dataset
    
    % get raw data & num neurons
    data = [core_dir filesep 'data' filesep 'ACE' filesep '20180807_Ripple2_d01' filesep 'Domo_20180807_Ripple2_d01_finalclusters.mat'];
    
    % there was a bug in this method that was causing subsets to be too
    % small, removing too many neurons. I fixed it and am running it again
    runACEonSubsets(data, output_dir);
    
%% - run multiple ACE on bad dataset

    setStandardACEParams;
    output_dir = [base_output filesep '20180820_Ripple2_d03'];
    p_train = .6;
    setStandardTriadParams;
    data_path = [core_dir filesep 'data' filesep 'ACE' filesep '20180820_Ripple2_d03' filesep 'WCSpikeSorting_20180820_Ripple2_d03_finalclusters.mat'];
    multipleRunACE(data_path, output_dir, time_units, bin_size, ACE_path, mc_algorithm_path, p_train);
    distributionJSDmultipleRunACE(output_dir);
    
%% get JSD multiple runs on good dataset
    output_dir = [base_output filesep '20180807_Ripple2_d01_60_40_multiple'];
    old_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181021' filesep '20180807_Ripple2_d01_60_40_firsthalf'];
    if (exist(output_dir, 'dir') == 0)
        mkdir(output_dir);
        copyfile(old_output,output_dir);
    end
    distributionJSDmultipleRunACE(output_dir);
    
%% - re-run ACE on new subset with the same test_logical
    output_dir = [base_output filesep '20180807_Ripple2_d01_subsets_samesplit'];
    if (exist(output_dir, 'dir') == 0)
        mkdir(output_dir);
    end
     % get raw data & num neurons
    data = [core_dir filesep 'data' filesep 'ACE' filesep '20180807_Ripple2_d01' filesep 'Domo_20180807_Ripple2_d01_finalclusters.mat'];
    same_split = true;
    runACEonSubsets(data, output_dir, same_split);