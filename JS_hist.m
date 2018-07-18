function JS_hist(h0, J, test_logical, filepath)
%% Load data 

load(filepath);
neuron_trains = cell2mat(neuron_trains);
neuron_trains = double(neuron_trains == 1)'; % switch to 1 and 0 from 1 and -1
neuron_trains = neuron_trains(test_logical,:);
n = size(neuron_trains, 1);

%% produce all combinations of 10 neurons firing 
N = size(neuron_trains, 2);
i = 10;
patterns = [];

ii = nchoosek(1:N,i);
k = size(ii,1);
out = zeros(k,N);
out(sub2ind([k,N],(1:k)'*ones(1,i),ii)) = 1;
patterns(end+1:end+size(out,1), :) = out;

% select 250 of these randomly
r = randperm(size(patterns,1), 250);
patterns = patterns(r, :);

%% compute JS divergence 
obs_is = zeros(1, 250); % observed vs. ising model
obs_ind = zeros(1, 250); % observed vs. independent model

% for each pattern of 10 neurons 
for i = 1:size(patterns,1)
    disp(['Computing divergence for ' num2str(i) ' of ' num2str(size(patterns,1))]);
    
    % select those neurons from distribution
    subset = neuron_trains(:,logical(patterns(i,:)));
    h0_subset = h0(logical(patterns(i,:)));
    J_subset = J(logical(patterns(i,:)), logical(patterns(i,:)));
       
    %%%%  JS divergence observed vs. ising 
    % extract appropriate spikes
    observed = p_dist(subset, h0_subset, J_subset);
    P = observed;
    [~, Q] = sample_ising_exact(h0_subset, J_subset);
    
    % throw out zero values of P
    z = P ~= 0;
    P = P(z);
    Q = Q(z);
    M = .5 * (P + Q); % by formula 

    % half the KL divergence between P & M   
    % negative sum of P * log M/P 
    Dpm = sum(P .* log2(P./M));

    % *PLUS*

    % half the KL divergence between Q & M 
    % negative sum of Q * log Q/M
    Dqm = sum(Q .* log2(Q./M));

    % total
    JSD = .5 * Dpm + .5 * Dqm;
    obs_is(i) = JSD;

    %%%% JS divergence observed vs. independent 
    % extract appropriate spike trains 
    P = observed;
    h0_independent = log(mean(subset, 1)./(1-mean(subset, 1)))*0.5;
    [~, Q] = sample_ising_exact(h0_independent, zeros(10, 10));
    
    % throw out zero values 
    z = P ~= 0;
    P = P(z);
    Q = Q(z);
    M = .5 * (P + Q);

    % half the KL divergence between P & M   
    % negative sum of P * log M/P 
    Dpm = sum(P .* log2(P./M));

    % *PLUS*

    % half the KL divergence between Q & M 
    % negative sum of Q * log Q/M
    Dqm = sum(Q .* log2(Q./M));

    % total 
    JSD = .5 * Dpm + .5 * Dqm;
    obs_ind(i) = JSD;
end 

% save variables 
% filecomps = strsplit(filepath, filesep);
% cd(filecomps{1});
save('JS_patterns.mat', 'obs_is', 'obs_ind');

%% plot histograms 

% % From Eugenio: js is an array containing 250 values of the JS divergences computed 
% % for a particular model (i.e. the independent model or the ising
% % model). Note that I'm generating them according to a log-normal
% % distribution, so that the histogram in log space will look Gaussian.
% js = random(makedist('Lognormal', 'mu', -3, 'sigma', 0.2), 250, 1);
% log_js = log10(js);
% bins = linspace(-4,0,41)-0.05;
% histogram(log_js,bins, 'normalization', 'pdf');
% % you then repeat the above for the other distribution, perhaps by
% % setting mu to -1 instead than -3.
% % finally, you have to change the labels of the x axis to show JS
% % instead of log_10(JS).

figure();

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

xlabel('JS Divergence (bits)');
ylabel('Probability Density');
set(gca, 'FontSize', 14);
legend({'Ising', 'Independent'});

ax = gca;
lab = ax.XTick;
labels = {};
for b=1:numel(lab)
    labels{end+1} = ['10^' '{' num2str(lab(b)) '}'];
end 

set(gca, 'XTickLabel', labels);
print(filepath, '-dpng');

end 