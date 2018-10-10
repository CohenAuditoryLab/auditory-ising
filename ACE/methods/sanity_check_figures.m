function sanity_check_figures = sanity_check_figures(file, figure_dir, multiplier)
    % initialize variables
    subset = '_no_onehalf';    
    if multiplier == 1/2
       subset = '';
     end
% load data
    load([file filesep 'neuron_trains.mat']);
    neuron_trains = cell2mat(neuron_trains);
    [N, T] = size(neuron_trains);
    load([file filesep 'test_logical.mat']);
    train_logical = ~test_logical;
    
    % split into train and test data 
    neuron_trains_test = neuron_trains(:,test_logical);
    neuron_trains = neuron_trains(:,train_logical);
    
    %compute the average of the products of all pairs - oi * oj
    mean_experiment = transpose(mean(neuron_trains,2));
    mean_experiment_product = neuron_trains*transpose(neuron_trains)/size(neuron_trains,2);

    % get mean & product of fit model
    b = dir(fullfile(file, '*learn.j'));
    [~,name,ext] = fileparts([b.folder filesep b.name]);
    [h, j_matrix] = extractFittedParameters(N,[file filesep name '.j']);
    [sigm, states] = sample_ising_exact(h', j_matrix);
    weighted_states = sigm.*repmat(transpose(states), 1, size(sigm, 2));
    mean_sigma = sum(weighted_states);
    mean_product = transpose(sigm)*weighted_states;
    
    % get stuff from independent model
    h0_indep = log(mean(neuron_trains, 2)./(1-mean(neuron_trains, 2)))*multiplier;
    h0_indep = transpose(h0_indep);
    k = numel(h);
    [sigm_ind, states_ind] = sample_ising_exact(h0_indep, zeros(k, k));
    weighted_states_ind = sigm_ind.*repmat(transpose(states_ind), 1, size(sigm_ind, 2));
    mean_sigma_ind = sum(weighted_states_ind);
    mean_product_ind = transpose(sigm_ind)*weighted_states_ind;
    
    % Mean responses
    mrs = mean_sigma;
    mers = mean_experiment;
    mrs_ind = mean_sigma_ind;
    
    % Mean products
    num_entries = N*(N-1)/2;
    meps = zeros(1,num_entries);
    mps = zeros(1,num_entries);
    mps_ind = zeros(1,num_entries);
    k = 1;
    for i = 1:N
        for j = i+1:N
            % computing covariance 
            meps(k) = mean_experiment_product(i,j) - mean_experiment(i)*mean_experiment(j);
            mps(k) = mean_product(i,j) - mean_sigma(i)*mean_sigma(j);
            mps_ind(k) = mean_product_ind(i,j) - mean_sigma_ind(i)*mean_sigma_ind(j);
            k = k+1;
        end
    end
    % get mean & product of independent model
     % Plot predicted vs. empirical values TRAIN DATA (sanity check) 
    figure;
    hold on;
    xlabel('Mean Experimental Response');
    ylabel('Mean Predicted Response');
    lin = linspace(min(min(mers),min(mrs)),max(max(mers),max(mrs)),101);
    plot(lin, lin, 'k', 'LineWidth', 1.5);
    rtr = plot(mers, mrs, '*b', 'MarkerSize', 10);
    rtr = plot(mers, mrs_ind, '*r', 'MarkerSize', 10);
    set(gca, 'FontSize', 14);
    print([figure_dir filesep 'responses' subset], '-dpng'); % save to file
    hold off;
    close all;
    figure;
    hold on;
    xlabel('Mean Experimental Correlation');
    ylabel('Mean Predicted Correlation');
    lin = linspace(min(min(meps),min(mps)),max(max(meps),max(mps)),101);
    plot(lin, lin, 'k', 'LineWidth', 1.5);
    ctr = plot(meps, mps, '*b', 'MarkerSize', 10);
    ctr = plot(meps, mps_ind, '*r', 'MarkerSize', 10);
    set(gca, 'FontSize', 14);
    print([figure_dir filesep 'correlations' subset], '-dpng'); % save to file
    hold off;
    close all;
end