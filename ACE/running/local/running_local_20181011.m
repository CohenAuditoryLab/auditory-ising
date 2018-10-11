% 10/11/2018

% PURPOSE OF THIS FILE
    % to run ACE algorithm & custom algorithm on Domo & bird data on local
    
        base_output = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_all'; 
       % addpath(genpath('../../'));
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
        
        
        %% DISCOVERY - JS_hist.m was incorrectly estimating the indep model;
        % using {1,0}-derived h to solve Ising model w/ {1, -1}
        
        % re-running
        data = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/201800807_Voc_Ripple/finalclusters.mat';
        output_dir = [base_output filesep '201801010_DOMO_fixedJS'];
        ACEpipeline(data, output_dir, 1e-3, 20e-3, 0, 1, ACE_path,0); %no chunking let's see how long that takes; takes too long
        output_dir = [base_output filesep '201801010_DOMO'];
        ACEpipeline(data, output_dir, 1e-3, 20e-3, 1, 1, ACE_path,0);
        
        % discovered frequency subset had the same problem; killed after
        % chunk 4
        
        % ok on to birds
        data = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/data_allBirds_binary_2010M6.txt';
        output_dir = [base_output filesep '201801010_Birds'];
        run_custom = 1;
        ACEpipeline_birds(data, output_dir, run_custom, ACE_path);
        % some kind of problem w/ frequency graph, plotting again
        zeros_and_ones = 1;
        plotACEresult(output_dir, zeros_and_ones);
        
        % now fixing frequency plots for neural
        output_dir = [base_output filesep '201801010_DOMO'];
        zeros_and_ones = 1;
        plotACEresult(output_dir, zeros_and_ones);
        PlotCustomAlgorithm(output_dir);