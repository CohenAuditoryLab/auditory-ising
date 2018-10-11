function pattern_frequencies_subset(h0, J, k, test_logical, filepath, figures_dir, zeros_and_ones)

%% load experimental data
load([filepath filesep 'neuron_trains.mat']);
neuron_trains = cell2mat(neuron_trains);
%test_neuron_trains = double(test_neuron_trains == 1);
test_neuron_trains = neuron_trains(:,test_logical);
train_neuron_trains = neuron_trains(:,~test_logical);
n = size(test_neuron_trains, 1);

%% extract k neurons randomly
p_train = k/n;
selection_logical = false(n, 1);
selection_logical(1:round(p_train*n)) = true;
selection_logical = selection_logical(randperm(n));
test_neuron_trains = test_neuron_trains(selection_logical, :);
train_neuron_trains = train_neuron_trains(selection_logical, :);
% get corresponding parameters
h0 = h0(selection_logical);
J = J(selection_logical, selection_logical);

%% compute ising and independent model results 
if (zeros_and_ones)
    [sigm, states] = sample_ising_exact_0(h0, J);
else
    [sigm, states] = sample_ising_exact(h0, J);
end

%h0_independent = log(mean(test_neuron_trains, 2)./(1-mean(test_neuron_trains, 2)))*0.5;
h0_independent = atanh(mean(train_neuron_trains,2));
h0_independent = transpose(h0_independent);
k = numel(h0);
[sigm_ind, states_ind] = sample_ising_exact(h0_independent, zeros(k, k));

%sigm = sigm == 1;
%sigm_ind = sigm_ind == 1;

test_neuron_trains = test_neuron_trains';

N = k;
patterns = sigm;
patterns(patterns<1) = -1;
%% for each pattern, determine frequency of occurrence in Hz 
T = 1e-3; %seconds 

numpat = size(patterns, 1);
numtrials = size(test_neuron_trains, 1);

observed = zeros(1, numpat);
ising = states/T;
ind = states_ind/T;

for i = 1:numpat
    %disp(['Counting pattern number ' num2str(i) ' of ' num2str(numpat) '...']);
    count = sum(ismember(test_neuron_trains, patterns(i, :), 'rows'));
    freq = count/numtrials/T;
    observed(i) = freq;
    %disp(['Frequencies: ' num2str(freq)]);
end 

% save('pattern_freqs_subset.mat', 'observed', 'ising', 'ind');
%% plot on log-log scale 

figure();
l1 = loglog(observed, ind, '.c', 'MarkerSize', 10);
hold on;

l2 = loglog(observed, ising, '.b', 'MarkerSize', 10);
set(gca, 'FontSize', 14);
title('Whole Pattern Frequencies');
xlabel('Observed Frequencies (Hz)');
ylabel('Predicted Frequencies (Hz)');
x1 = xlim;
lin = linspace(x1(1), x1(2), 100);
plot(lin, lin, 'k', 'Linewidth', .75);
legend([l1 l2], 'Independent', 'Pairwise', 'Location', 'SouthEast');
print([figures_dir filesep 'whole_pattern_frequencies'], '-dpng');
close all;
end 