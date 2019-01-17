% 10/10/2018

% PURPOSE OF THIS FILE
    % to run ACE algorithm & custom algorithm on Domo & bird data on new
    % bark
    
        base_output = '/home/matt/Documents/Ising/output/ACE_NewBark'; 
        addpath(genpath('../../'));
    % add ACE path
        ACE_path = '/home/matt/Documents/ACE';
        addpath(genpath(ACE_path));
    
    % add ACE env variable
        setenv('LD_LIBRARY_PATH', '/usr/lib/x86_64-linux-gnu/libstdc++.so.6');
    
    % domo neural
        data = '/home/matt/Documents/Ising/data/ACE/201800807_Voc_Ripple/finalclusters.mat';
        output_dir = [base_output filesep '201801010_DOMO'];
        ACEpipeline(data, output_dir, 1e-3, 20e-3, 1, 1, ACE_path,0);
        
    % bird
        data = '/home/matt/Documents/Ising/data/ACE/Eve_birds/data_allBirds_binary_2010M6.txt';
        output = [base_output filesep '201801010_Birds'];
        ACEpipeline_birds(data_path, output_dir, 1, ACE_path);