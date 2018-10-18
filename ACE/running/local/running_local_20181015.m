% 10/15/2018

% PURPOSE OF THIS FILE: To run today's code

% get triads of bird data -- all data
        data_bird_path = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/data_allBirds_binary_2010M6.txt';
    % MC algorithm path
        mc_algorithm_path = '/Users/mschaff/Documents/REPOS/QEE'; %precompiled
    % triad output path
        triad_output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/10152018/triads2';

        j_file_path = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_all/201801010_Birds_nosplit_j/data-out.j';
        probability_of_triads2(data_bird_path, j_file_path, mc_algorithm_path, triad_output_dir)


% get bird data triads -- test vs train         
         % data bird path
        data_bird_path = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/data_allBirds_binary_2010M6.txt';
    % MC algorithm path
        mc_algorithm_path = '/Users/mschaff/Documents/REPOS/QEE'; %precompiled
    % triad output path
        triad_output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/10152018/triads_birds_split';

        test_logical_path = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_all/201801010_Birds_fixedtrain/test_logical.mat';
        j_file_path = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_all/201801010_Birds_fixedtrain/ACEinput-out.j';
        probability_of_triads2(data_bird_path, j_file_path, mc_algorithm_path, triad_output_dir, test_logical_path);
                

% run ACE on Kilosort output of 8/7/18 Ripple
    
    % sorting metrics
        sorting_metrics('/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/20180807_Ripple2_d01/Kilosortoutput', 'kilo', '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/20180807_Ripple2_d01/Kilosortoutput/Metrics');
        NeuronDecisions;

    % to run ACE algorithm & custom algorithm on Domo & bird data on local
        
        core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
        addpath(genpath(core_dir)); 
        base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181015']; 
        mkdir(base_output);
    % add ACE path
        ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        
    % domo neural 20180807_Ripple2_d01
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180807_Ripple2_d01' filesep 'Kilosortoutput' filesep '20180807_Ripple2_d01_Kilosortoutput_finalclusters.mat'];
        output_dir = [base_output filesep '20180807_Ripple2_d01_kilo'];
        ACEpipeline(data, output_dir, 1/24414, 100e-3, 1, 1, ACE_path,0);
       
        
