% 10/21/2018

% PURPOSE OF THIS FILE: To run today's code

    % try to run ACE on full ripple dataset
        
        core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
        addpath(genpath(core_dir)); 
        base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181021']; 
        mkdir(base_output);
        
    % run ACE mutiple
        ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180807_Ripple2_d01' filesep 'Domo_20180807_Ripple2_d01_finalclusters_firsthalf.mat'];
        output_dir = [base_output filesep '20180807_Ripple2_d01_60_40_firsthalf'];
        time_units = 1e-3;
        bin_size = 20e-3;
        p_train = .6;
        mc_algorithm_path = '/Users/mschaff/Documents/REPOS/QEE';
        multipleRunACE(data, output_dir, time_units, bin_size, ACE_path, mc_algorithm_path, p_train);
    
    % run ACE normally
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180807_Ripple2_d01' filesep 'Domo_20180807_Ripple2_d01_finalclusters.mat'];
        time_units = 1e-3;
        bin_size = 20e-3;
        p_train = .6;
        output_dir = [base_output filesep '20180807_Ripple2_d01_60_40_noshift'];
        use_chunks = 0;
        run_custom = 0;
        ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        indep_c_ij = 0;
        plot_all_points = 1;
        ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_points)
        
    % shift bins in data
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180807_Ripple2_d01' filesep 'Domo_20180807_Ripple2_d01_finalclusters.mat'];
        output_dir = [base_output filesep '20180807_Ripple2_d01_60_40_shiftbins'];
        generateACEinputSpikeTimes_shiftbins(data, time_units, bin_size, output_dir);
        % run ACE & learning algorithm on the *.p file
        runACEonCohenData(output_dir, ACE_path);     
        % extract h & J parameters from *.j file & generate figures
        plotACEresult(output_dir, 1, 1);
        data_path = [output_dir filesep 'neuron_trains.mat'];
        j_file_path = [output_dir filesep 'ACEinput-out.j']; 
        test_logical_path = [output_dir filesep 'test_logical.mat'];
        triad_output_dir = [output_dir filesep 'triads'];
        j_file_path = [output_dir filesep 'ACEinput-out.j'];
        bird = false;
        probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path, 1);
        
    % analyze multiple runs
        analyzeMultipleRuns;
        
    % output codewords w/ epsilon added to 0s
        old_output_dir = [base_output filesep '20180807_Ripple2_d01_60_40_noshift'];
        output_dir = [base_output filesep '20180807_Ripple2_d01_60_40_epsilon_new'];
        mkdir(output_dir);
        copyfile(old_output_dir, output_dir);
        plotACEresult(output_dir, 1,1);