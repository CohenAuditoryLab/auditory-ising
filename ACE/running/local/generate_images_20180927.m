% 9/27-10/1/2018

% PURPOSE OF THIS FILE
    % to design an efficient pipeline that outputs ACE results
    % add code to path
        addpath(genpath('/Users/mschaff/Documents/DISSERTATION/Ising/code'));
    % get chunks of data such that there are 10,000 bins per chunk &
    % training + test split
        data = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/201800807_Voc_Ripple/finalclusters.mat';
        time_units = 1e-3;
        bin_size = 20e-3;
        output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20180927';
        generateACEinputSpikeTimes(data, time_units, bin_size, output_dir,1); 
    % run ACE & learning algorithm on the *.p file
        ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        runACEonCohenData(output_dir, ACE_path);     
    % extract h & J parameters from *.j file & generate plots
        plotACEresult(output_dir, ACE_path);
