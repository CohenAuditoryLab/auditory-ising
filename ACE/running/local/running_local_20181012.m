% 10/12/2018

% PURPOSE OF THIS FILE
    % to run ACE algorithm & custom algorithm on Domo & bird data on local
        
        core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
        addpath(genpath(core_dir)); 
        base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181012']; 
        mkdir(base_output);
    % add ACE path
        ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        
    % domo neural 20180807_Ripple2_d01
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180807_Ripple2_d01' filesep 'Domo_20180807_Ripple2_d01_finalclusters.mat'];
        output_dir = [base_output filesep '20180807_Ripple2_d01'];
        ACEpipeline(data, output_dir, 1e-3, 20e-3, 1, 1, ACE_path,0);
       
        