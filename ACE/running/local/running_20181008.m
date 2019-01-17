% 10/08/2018

% PURPOSE OF THIS FILE
    % to run ACE pipeline on pre-computed bird data
             ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
            run_custom =1;
        % Eve's .j
            data_path = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/data_allBirds_binary_2010M6.txt';
            % custom & ACE - 1/2 
            % custom & ACE - no 1/2
                output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181008_bird_j';
                plotACEresult(output_dir,1);
                runPlotCustomAlgorithm(output_dir,1);
            
            
        % Clelia's .j
            % custom & ACE - 1/2
            % custom & ACE - no 1/2
            output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181008_bird_j_clelia';
            plotACEresult(output_dir,1);
            runPlotCustomAlgorithm(output_dir,1);

            % sanity check figures - correlations & mean firing rate - 1/2
            % sanity check figures - correlations & mean firing rate - no 1/2
            figure_dir = [output_dir filesep 'figures'];
            sanity_check_figures(output_dir, figure_dir,1)
            sanity_check_figures(output_dir, figure_dir,.5)
            
            figure_dir = [output_dir filesep 'figures_custom'];
            sanity_check_figures_custom(output_dir, figure_dir,1)
            sanity_check_figures_custom(output_dir, figure_dir,.5)
        % re-run ACE on data to approximate Clelia's .j
       
        % sanity check figures
            % Eve
            % sanity check figures - correlations & mean firing rate 
            
            % Clelia
            % sanity check figures - correlations & mean firing rate 