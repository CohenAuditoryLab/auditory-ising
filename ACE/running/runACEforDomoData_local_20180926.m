% 9/26/2018

% PURPOSE OF THIS FILE
    % to generate *.p file and spikes_by_bin file to figure out how to
    % generate graphs from ACE results with

    % add code to path
        addpath(genpath('/Users/mschaff/Documents/DISSERTATION/Ising/code'));
    % generate spike train files
        data = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/201800807_Voc_Ripple/finalclusters.mat';
        time_units = 1e-3;
        bin_size = 20e-3;
        output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20180926';
        generateACEinputSpikeTimes(data, time_units, bin_size, output_dir);
    % reformat spike train files for BoltzmannMetrics
        load([output_dir filesep 'spikes_by_bin.mat']);
        spikes_by_bin(spikes_by_bin==0) = -1;
        neuron_trains = mat2cell(spikes_by_bin, ones([1 20]), [59606]);
        save([output_dir filesep 'neuron_trains.mat'], 'neuron_trains');
        BoltzmannMetrics(output_dir); 
            % FYI -- ACE does not produce h's and J's that work when put
            % put back into the Ising model to predict spike patterns
            
    % let's make some graphs
        % J_ij after learning
        [h, j_matrix] = extractFittedParameters('/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/201800807_Voc_Ripple/finalclusters.mat','/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_NewBark/20180921/ACEinput-out-learn.j');
        f = heatmap(j_matrix);
        title('J_ij -- After Learning');
        saveas(gcf,[output_dir filesep 'Jij_afterlearning.jpg']);
        close all;
        % J_ij before learning
        [h, j_matrix] = extractFittedParameters('/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/201800807_Voc_Ripple/finalclusters.mat','/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_NewBark/20180921/ACEinput-out.j');
        f = heatmap(j_matrix);
        title('J_ij -- Before Learning');
        saveas(gcf,[output_dir filesep 'Jij_beforelearning.jpg']);
        close all;
        % correlations
        load([output_dir filesep 'c_ij.mat']);
        f = heatmap(c_ij);
        title('C_ij');
        saveas(gcf,[output_dir filesep 'C_ij.jpg']);
        close all;
        
        