% 10/19/2018

% PURPOSE OF THIS FILE: To run today's code

    % try to run ACE on full ripple dataset
        
        core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
        addpath(genpath(core_dir)); 
        base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181019']; 
        mkdir(base_output);
    % add ACE path
        
        
    % domo neural 20180807_Ripple2_d01 - 50:50 split
        ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        data = [core_dir filesep 'data' filesep 'ACE' filesep '20180807_Ripple2_d01' filesep 'Domo_20180807_Ripple2_d01_finalclusters.mat'];
        output_dir = [base_output filesep '20180807_Ripple2_d01_50_50'];
        time_units = 1e-3;
        bin_size = 20e-3;
        use_chunks = 0;
        run_custom = 0;
        indep_c_ij = 0;
        p_train = .5;
        ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train);
        
    % try to plot all points
        old_ACE_output_dir = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181018' filesep '20180807_Ripple2_d01_wave'];
        ACE_output_dir = [base_output filesep '20180807_Ripple2_d01_wave_allpoints'];
        mkdir(ACE_output_dir);
        copyfile(old_ACE_output_dir, ACE_output_dir);
        plotACEresult(ACE_output_dir, 1);
        
    % replot bird data for Eve, now without stupid Hz scaling
        old_ACE_output_dir = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181018' filesep 'birds'];
        ACE_output_dir = [base_output filesep 'birds'];
        mkdir(ACE_output_dir);
        copyfile(old_ACE_output_dir, ACE_output_dir);
        plotACEresult(ACE_output_dir, 1);
        
    % replot 100% no split bird data for Eve, now without stupid Hz scaling
        old_ACE_output_dir = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181010_all' filesep '201801010_Birds_nosplit_j'];
        ACE_output_dir = [base_output filesep 'birds_nosplit'];
        mkdir(ACE_output_dir);
        copyfile(old_ACE_output_dir, ACE_output_dir);
        plotACEresult(ACE_output_dir, 1);
        
    % replot 100% no split bird data, and ALL points for Eve, now without stupid Hz scaling
        old_ACE_output_dir = ACE_output_dir;
        ACE_output_dir = [base_output filesep 'birds_nosplit_all'];
        mkdir(ACE_output_dir);
        copyfile(old_ACE_output_dir, ACE_output_dir);
        plotACEresult(ACE_output_dir, 1);
        
    % domo neural 20180807_Ripple2_d01 - 70:30 split
        output_dir = [base_output filesep '20180807_Ripple2_d01_70_30'];
        p_train = .7;
        ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train);
        plotACEresult(output_dir, 1);
    % domo neural 20180807_Ripple2_d01 - 60:40 split
        output_dir = [base_output filesep '20180807_Ripple2_d01_60_40'];
        p_train = .6;
        ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train);
        plotACEresult(output_dir, 1);
        
    % redo figures for 70:30 split and 60:40 split and 50:50 split; plot
    % all elements for codeword figure
        plot_all_elements = true; % as opposed to 
        output_dir = [base_output filesep '20180807_Ripple2_d01_70_30']; plotACEresult(output_dir, 1, plot_all_elements);
        output_dir = [base_output filesep '20180807_Ripple2_d01_60_40']; plotACEresult(output_dir, 1, plot_all_elements);
        output_dir = [base_output filesep '20180807_Ripple2_d01_50_50']; plotACEresult(output_dir, 1, plot_all_elements);
        output_dir = [base_output filesep '20180807_Ripple2_d01_wave_allpoints2']; plotACEresult(output_dir, 1, plot_all_elements);
        
        
        output_dir = [base_output filesep '20180807_Ripple2_d01_70_30_new'];
        p_train = .7;
        plot_all_elements = true;
        ACEpipeline(data, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_elements);