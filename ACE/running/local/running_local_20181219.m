% 12/19/2018

% PURPOSE OF THIS FILE: To test the effect of subsets of good dataset

%% set up basics

    core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
    addpath(genpath(core_dir)); 
    base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181218'];
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
    runACEonSubsets(data, output_dir);