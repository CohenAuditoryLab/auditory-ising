% 10/03/2018

% PURPOSE OF THIS FILE
    % to run ACE pipeline on bird data
        output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181003_bird';
        ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        run_custom =1;
        data_path = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/data_allBirds_binary_2010M6.txt';
        ACEpipeline_birds(data_path, output_dir, run_custom, ACE_path);
        
        %run again, this time w/ L2 regularization set
        output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181003_bird_l2';
        ACEpipeline_birds(data_path, output_dir, run_custom, ACE_path);