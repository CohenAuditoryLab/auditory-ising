% 10/16/2018

% PURPOSE OF THIS FILE: To run today's code

    % try to run ACE on full ripple dataset
        
        core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
        addpath(genpath(core_dir)); 
        base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181016']; 
        mkdir(base_output);
    % add ACE path
        ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        
    % domo neural 20180807_Ripple2_d01
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180807_Ripple2_d01' filesep 'Domo_20180807_Ripple2_d01_finalclusters.mat'];
        output_dir = [base_output filesep '20180807_Ripple2_d01_wave'];
        ACEpipeline(data, output_dir, 1e-3, 20e-3, 0, 1, ACE_path,0);
       
        



        % get bird data triads -- test vs train         
         % data bird path
        data_bird_path = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/data_allBirds_binary_2010M6.txt';
    % MC algorithm path
        mc_algorithm_path = '/Users/mschaff/Documents/REPOS/QEE'; %precompiled
    % triad output path
        triad_output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/10152018/triads_birds_split';

        test_logical_path = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_all/201801010_Birds_fixedtrain/test_logical.mat';
        j_file_path = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_all/201801010_Birds_fixedtrain/ACEinput-out.j';
        bird = true;
        probability_of_triads2(data_bird_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path);