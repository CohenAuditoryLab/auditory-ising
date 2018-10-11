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
        
        
        %% DISCOVERY - ?JS_hist.m was incorrectly estimating the indep model;
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

        %% DISCOVERY -- p_dist_neg was ALSO not respecting 
        
        % so re-running metrics
        
        % bird
        destination = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_all/201801010_Birds_pdistfix';
        mkdir(destination);
        source = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_all/201801010_Birds';
        copyfile(source, destination);
        output_dir = destination;
        zeros_and_ones = 1;
        plotACEresult(output_dir, zeros_and_ones);
        
        %% run ACE on all bird data
        data = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/data_allBirds_binary_2010M6.txt';
        output_dir = [base_output filesep '201801010_Birds_nosplit'];
        run_custom = 1;
        split = 0;
        ACEpipeline_birds(data, output_dir, run_custom, ACE_path, split);
        
        %% DISCOVERY! - independent models are being trained on test data!
        % must fix for all plots
        
        % edited JS_hist.m & pattern_frequencies_subset.m so they train
        % independent model on training data!
        base_output = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_all'; 
        zeros_and_ones = 1;
        output_dir = [base_output filesep '201801010_Birds'];
        plotACEresult(output_dir, zeros_and_ones);
        
        % bird
        output_dir = [base_output filesep '201801010_Birds_fixedtrain'];
        mkdir(output_dir);
        copyfile([base_output filesep '201801010_Birds'], output_dir);
        zeros_and_ones = 1;
        plotACEresult(output_dir, zeros_and_ones);
        
        % neural
        output_dir = [base_output filesep '201801010_DOMO_fixedtrain'];
        mkdir(output_dir);
        copyfile([base_output filesep '201801010_DOMO'], output_dir);
        zeros_and_ones = 1;
        plotACEresult(output_dir, zeros_and_ones);
        PlotCustomAlgorithm(output_dir);
        
        
        %% Get new plots from Eve's .j file
        
        % using 100% data astraining data, then 20% of that as test data
        eve_j_file = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/data-out.j';
        destination = [base_output filesep '201801010_Birds_fixedtrain_j'];
        mkdir(destination);
        source = [base_output filesep '201801010_Birds_fixedtrain'];
        copyfile(source, destination); % copy the directory so the plotting functions can use the files in it
        copyfile(eve_j_file, [destination filesep]); % copy Eve's .j file
        delete([destination filesep 'ACEinput-out.j']); %delete the ACE output I generated
        rmdir([destination filesep 'figures_custom']);
        output_dir = destination;
        zeros_and_ones = 1;
        plotACEresult(output_dir, zeros_and_ones);
        
        % using 100% data as training data, then 100% of that as test data
        destination = [base_output filesep '201801010_Birds_nosplit_j'];
        mkdir(destination);
        source = [base_output filesep '201801010_Birds_nosplit'];
        copyfile(source, destination); % copy the directory so the plotting functions can use the files in it
        copyfile(eve_j_file, [destination filesep]); % copy Eve's .j file
        delete([destination filesep 'ACEinput-out.j']); %delete the ACE output I generated
        rmdir([destination filesep 'figures_custom']);
        output_dir = destination;
        zeros_and_ones = 1;
        plotACEresult(output_dir, zeros_and_ones);
        
        %% Running custom algorithm on Domo data w/ 1000 iterations (Instead of 100)
        data = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/201800807_Voc_Ripple/finalclusters.mat';
        output_dir = [base_output filesep 'DOMO_custom_1000_iters'];
        mkdir(output_dir);
        time_units = 1e-3; bin_size=20e-3; chunk=0;
        generateACEinputSpikeTimes(data, time_units, bin_size, output_dir, chunk);
        runPlotCustomAlgorithm(output_dir, 1000);