% 10/04/2018

% PURPOSE OF THIS FILE
    % to run ACE pipeline on bird data
        ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        run_custom =1;
        data_path = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/data_allBirds_binary_2010M6.txt';
        
        %run again, this time w/ L2 regularization set for both ACE & QLS
        output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181004_bird_l2_both';
        ACEpipeline_birds(data_path, output_dir, run_custom, ACE_path);
        
        output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181004_bird_j';
        plotACEresult(output_dir); runPlotCustomAlgorithm(output_dir);