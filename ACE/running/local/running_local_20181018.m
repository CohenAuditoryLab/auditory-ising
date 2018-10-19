% 10/18/2018

% PURPOSE OF THIS FILE: To run today's code

    % set standard directories
        
        core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
        addpath(genpath(core_dir)); 
        base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181018']; 
        prev_day_base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181017']; 
        mkdir(base_output);
        
    % recompute plotACEresult.m, that now saves the selection_logical.mat &
    % selection_logical.txt
        
        % copy output to new directory
            old_ACE_output_dir = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181016' filesep '20180807_Ripple2_d01_wave'];
            mkdir([base_output filesep '20180807_Ripple2_d01_wave']);
            copyfile(old_ACE_output_dir, [base_output filesep '20180807_Ripple2_d01_wave']);
            ACE_output_dir = [base_output filesep '20180807_Ripple2_d01_wave'];
        % output figures, now w/ the selection_logical saving
            plotACEresult(ACE_output_dir,1);
            
    % generate dataset for Clelia
        
        load([ACE_output_dir filesep 'neuron_trains.mat']);
        neuron_trains = cell2mat(neuron_trains);
        neuron_trains(neuron_trains > 1) = 1;
        neuron_trains(neuron_trains < 1) = 0;
        % generate string to save text file
        num_elements = size(neuron_trains,1);
        string = '';
        for i=1:num_elements
            string = [string '%1g'];
        end
        fid = fopen([ACE_output_dir filesep 'events_by_bin.dat'], 'wt');
        fprintf(fid, [string '\n'],neuron_trains');
        fclose(fid);
        
        % save test_logical as .txt file
        load([ACE_output_dir filesep 'test_logical.mat']);
        fid = fopen([ACE_output_dir filesep 'test_logical.txt'], 'wt');
        fprintf(fid, '%1g\n',test_logical);
        fclose(fid);
        
        
    % recompute bird figures
    
        old_ACE_output_dir = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181010_all' filesep '201801010_Birds_fixedtrain'];
        ACE_output_dir = [base_output filesep 'birds'];
        mkdir(ACE_output_dir);
        copyfile(old_ACE_output_dir, ACE_output_dir);
        load([ACE_output_dir filesep 'test_logical.mat']);
        train_logical = ~test_logical;
        save([ACE_output_dir filesep 'train_logical.mat'], 'train_logical');
        plotACEresult(ACE_output_dir,1);

        % save test_logical as .txt file
        load([ACE_output_dir filesep 'test_logical.mat']);
        fid = fopen([ACE_output_dir filesep 'test_logical.txt'], 'wt');
        fprintf(fid, '%1g\n',test_logical);
        fclose(fid);
        
        
        
     % output triads on Ripple dataset
        ACE_output_dir = [base_output filesep '20180807_Ripple2_d01_wave'];
        data_path = [ACE_output_dir filesep 'neuron_trains.mat'];
        mc_algorithm_path = '/Users/mschaff/Documents/REPOS/QEE'; %precompiled
        triad_output_dir = [ACE_output_dir filesep 'triads'];
        test_logical_path = [ACE_output_dir filesep 'test_logical.mat'];
        j_file_path = [ACE_output_dir filesep 'ACEinput-out.j']; 
        bird = false; % it's neural data not bird data
        probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path);
        
    % output STRICT triads on Ripple dataset 
        triad_output_dir = [ACE_output_dir filesep 'triads_strict'];
        probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path, 1);
        
    % output STRICT triads on bird dataset 
        
        ACE_output_dir = [base_output filesep 'birds'];
        data_path = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/data_allBirds_binary_2010M6.txt';
        j_file_path = [ACE_output_dir filesep 'ACEinput-out.j']; 
        mc_algorithm_path = '/Users/mschaff/Documents/REPOS/QEE'; %precompiled
        test_logical_path = [ACE_output_dir filesep 'test_logical.mat'];
        triad_output_dir = [ACE_output_dir filesep 'triads_strict'];
        j_file_path = [ACE_output_dir filesep 'ACEinput-out.j'];
        bird = true;
        probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path, 1);
