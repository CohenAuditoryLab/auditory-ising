% 10/11/2018

% PURPOSE OF THIS FILE
    % to run ACE algorithm & custom algorithm on Domo & bird data on local
    
        base_output = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_all'; 
    % add ACE path
        ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        %addpath(genpath(ACE_path));
    
    % domo neural
        data = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/201800807_Voc_Ripple/finalclusters.mat';
        output_dir = [base_output filesep '201801010_DOMO'];
        ACEpipeline(data, output_dir, 1e-3, 20e-3, 1, 1, ACE_path,0);
        
    % bird
        data = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/data_allBirds_binary_2010M6.txt';
        output = [base_output filesep '201801010_Birds'];
        ACEpipeline_birds(data_path, output_dir, 1, ACE_path);