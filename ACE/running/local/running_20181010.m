% 10/10/2018

% PURPOSE OF THIS FILE
    % to run ACE pipeline on pre-computed bird data
             ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
            run_custom =1;
        % Eve's .j
            data_path = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/data_allBirds_binary_2010M6.txt';
            
        % Clelia's .j
            % custom & ACE - 1/2
            % custom & ACE - no 1/2
            output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181008_bird_j_2';
            plotACEresult(output_dir,1);
           % runPlotCustomAlgorithm(output_dir,1);

            output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010';
            runPlotCustomAlgorithm(output_dir,1);

            data = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/201800807_Voc_Ripple/finalclusters.mat';
            time_units = 1e-3;
            bin_size = 20e-3;
            output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_nochunk';
            generateACEinputSpikeTimes(data, time_units, bin_size, output_dir,0,0);
            runPlotCustomAlgorithm(output_dir,1);
            
            load('/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_nochunk/figures_custom/h_custom.mat');
            load('/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_nochunk/figures_custom/j_matrix.mat');
            load('/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_nochunk/test_logical.mat');
            figure_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_nochunk/figures_new_custom';
            output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_nochunk';
            pattern_frequencies_subset_atanh(h,j_matrix,10,test_logical, output_dir, figure_dir);
            JS_hist_atanh(h,j_matrix, test_logical, output_dir, figure_dir);
            test_atanh_onehalf(output_dir)
            
            %bird
            output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_bird_j_2';
            plotACEresult(output_dir,1);
            
            %neural
            output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181010_02_neural';
            plotACEresult(output_dir,1);
            
            
            % neural custom
            data = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/201800807_Voc_Ripple/finalclusters.mat';
            time_units = 1e-3;
            bin_size = 20e-3;
            output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/201801010_neural_custom';
            generateACEinputSpikeTimes(data, time_units, bin_size, output_dir,0,0); 
            runPlotCustomAlgorithm(output_dir);