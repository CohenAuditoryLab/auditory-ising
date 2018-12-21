% 12/21/2018

% PURPOSE OF THIS FILE: To run today's code

%% set up basics

    core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
    addpath(genpath(core_dir)); 
    base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181221'];
    if (exist(base_output, 'dir') == 0)
        mkdir(base_output);
    end
    
%% run subset ACE on vocalizations (20180711_Vocalization_d01)
    output_dir = [base_output filesep '20180711_Vocalization_d01_subsets'];
    if (exist(output_dir, 'dir') == 0)
        mkdir(output_dir);
    end
    % get raw data & num neurons
    data = [core_dir filesep 'data' filesep 'ACE' filesep '20180711_Vocalization_d01' filesep 'ALL_Domo_20180711_Vocalization_d01_finalclusters.mat'];
    same_split = true;
    runACEonSubsets(data, output_dir, same_split);
    
%% run multiple ACE on vocalizations (20180711_Vocalization_d01)

    output_dir = [base_output filesep '20180711_Vocalization_d01_multiple'];
    if (exist(output_dir, 'dir') == 0)
        mkdir(output_dir);
    end

    setStandardACEParams;
    output_dir = [base_output filesep '20180711_Vocalization_d01_multiple'];
    p_train = .6;
    setStandardTriadParams;
    data_path = [core_dir filesep 'data' filesep 'ACE' filesep '20180711_Vocalization_d01' filesep 'ALL_Domo_20180711_Vocalization_d01_finalclusters.mat'];
    multipleRunACE(data_path, output_dir, time_units, bin_size, ACE_path, mc_algorithm_path, p_train);
    distributionJSDmultipleRunACE(output_dir);