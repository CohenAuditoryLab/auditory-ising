% 10/17/2018

% PURPOSE OF THIS FILE: To run today's code

    % set standard directories
        
        core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
        addpath(genpath(core_dir)); 
        base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181017']; 
        prev_day_base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181016']; 
        mkdir(base_output);
    % output triads on Ripple dataset
            ACE_output_dir = [prev_day_base_output filesep '20180807_Ripple2_d01_wave'];
            data_path = [ACE_output_dir filesep 'spikes_by_bin.mat'];
            mc_algorithm_path = '/Users/mschaff/Documents/REPOS/QEE'; %precompiled
            triad_output_dir = [base_output filesep 'triads'];
            test_logical_path = [ACE_output_dir filesep 'test_logical.mat'];
            j_file_path = [ACE_output_dir filesep 'ACEinput-out.j']; 
            bird = false; % it's neural data not bird data
            probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path);
            
    
    % replicating bird results just to be sure
        % data bird path
        data_bird_path = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/data_allBirds_binary_2010M6.txt';
        % triad output path
        triad_output_dir = [base_output filesep 'triads_birds_split'];
        test_logical_path = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_all/201801010_Birds_fixedtrain/test_logical.mat';
        j_file_path = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_all/201801010_Birds_fixedtrain/ACEinput-out.j';
        bird = true;
        probability_of_triads2(data_bird_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path);
        
    % test JS_hist.m
        plotACEresult(ACE_output_dir,1);