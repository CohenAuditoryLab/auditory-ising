function BoltzmannMetrics(directory) 
%% Run all ising code and related metrics.

%% Define file path to neuron trains for group of neurons in question.
% filepath = 'Domo_Data/ALL_Domo_20180711_Vocalization_d01_finalclusters/neuron_trains.mat';
filepath = [directory filesep 'neuron_trains.mat'];

%% Run estimate_ising 
%  This produces plots of deviation over iterations, empirical vs.
%  predicted responses (firing rates) and empirical vs. predicted correlations for 80% 
%  train (as a sanity check) and 20% test data.

disp('Solving inverse ising problem...');

[h0, J, fr_model, fr_exp, corr_model, corr_exp, test_logical, train_exp_corr, train_corr, train_logical] ...
    = estimate_ising_v2(100, directory);
save([directory filesep 'Boltzmann_h.mat'],'h0');
save([directory filesep 'Boltzmann_J.mat'],'J');
%% Produce plot for 3rd order interactions.

disp('Computing third order correlations...');

Ising_Pijk(corr_model, corr_exp, train_corr, train_exp_corr, directory);

%% Probability of k neurons to be simultaneously active in a time bin of 
%  duration delta_t = 10 ms.

disp('Computing probability of k simultaneously firing neurons...');

plot_num_firing(h0, J, test_logical, filepath);
plot_num_firing_v2(h0, J, test_logical, train_logical, directory);

%% Probabilities of the activity configurations

% try to load data from file 

% try
%     disp('Loading whole pattern frequencies...');
%     
%     load([directory filesep pattern_freqs.mat]);
%     
%     figure();
%     loglog(observed, ind, '.c', 'MarkerSize', 10);
%     hold on;
%     loglog(observed, ising, '.b', 'MarkerSize', 10);
%     legend({'Independent', 'Ising'}, 'Location', 'SouthEast');
%     set(gca, 'FontSize', 14);
%     title('Whole Pattern Frequencies');
%     xlabel('Observed Frequencies (Hz)');
%     ylabel('Predicted Frequencies (Hz)');
%     lin = linspace(10^(-2), 10^2,100);
%     plot(lin, lin, 'k', 'Linewidth', .75);
%     
% % if not found, recompute (this will take a while) 
% catch 
%     disp('File not found. Computing whole pattern frequencies...');
% 
%     pattern_frequencies(h0, J, test_logical, filepath);
% end

%% Compute whole pattern frequencies on a subset of k neurons 

k = 10; % number of neurons to select
pattern_frequencies_subset(h0, J, k, test_logical, directory);

%% JS Divergence Histogram 
% Shows JS Divergence between observed/ising model and observed/independent
% model. 

try 
    disp('Loading JS divergences...');
    
    load([directory filesep 'JS_patterns.mat']);
    
    % for obs_is
    %convert to log scale
    log_obs_is = log10(obs_is);
    %bins from 10^-4 to 10^0
    bins = linspace(-4, 0, 41)-0.05;
    %normalized in the x log space to have an area of 1
    histogram(log_obs_is, bins, 'normalization', 'pdf');

    hold on;

    % for obs_ind
    log_obs_ind = log10(obs_ind);
    histogram(log_obs_ind, bins, 'normalization', 'pdf');

    xlabel('JS');
    ylabel('Probability Density');
    set(gca, 'FontSize', 14);
    legend({'Ising', 'Independent'});
    
    % change xtick labels back to bit scale 
    ax = gca;
    lab = ax.XTick;
    labels = {};
    for b=1:numel(lab)
        labels{end+1} = ['10^' '{' num2str(lab(b)) '}'];
    end 
    
    set(gca, 'XTickLabel', labels);
catch 
    disp('File not found. Computing JS divergences...');

    JS_hist(h0, J, test_logical, directory);
end 

end 