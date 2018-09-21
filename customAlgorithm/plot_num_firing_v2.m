function plot_num_firing_v2(h0, J, test_logical, train_logical, file)

%% Load data
load([file filesep 'neuron_trains.mat']);
neuron_trains = cell2mat(neuron_trains);
% Separate into train and test sets 
neuron_trains_test = neuron_trains(:,test_logical);
neuron_trains_test = (neuron_trains_test+1)/2;
N = size(neuron_trains_test, 1);
%% Compute ising model probability distribution and neuron states for TEST DATA 
[sigm, states] = sample_ising_exact(h0, J);
sigm = (sigm+1)/2;
% Determine number of neurons firing in each pattern
num_firing_each_sig = sum(sigm, 2);
num_firing_bins = zeros(1, N+1);
% Add up probabilities of each # of neurons firing 
for i=1:numel(states)
    num_firing_bins(num_firing_each_sig(i)+1) = num_firing_bins(num_firing_each_sig(i)+1)+states(i);
end

%% Compute ising model prob distribution/states for TRAIN DATA 
% Grab corresponding train trials 
neuron_trains = neuron_trains(:,train_logical);
neuron_trains = (neuron_trains+1)/2;
N = size(neuron_trains, 1);
% Compute ising probabilities/states for train data 
[sigm, states] = sample_ising_exact(h0, J);
sigm = (sigm+1)/2;
% Count number of neurons firing 
num_firing_each_sig = sum(sigm, 2);
num_firing_bins_tr = zeros(1, N+1);
% Add up probabilities of each number 
for i=1:numel(states)
    num_firing_bins_tr(num_firing_each_sig(i)+1) = num_firing_bins_tr(num_firing_each_sig(i)+1)+states(i);
end

%% Determine experimental probability distribution 
experimental_num_firing = zeros(1, N+1);
for i=1:size(neuron_trains, 2)
    experimental_num_firing(sum(neuron_trains(:, i))+1) = experimental_num_firing(sum(neuron_trains(:, i))+1)+1;
end
experimental_num_firing = experimental_num_firing/size(neuron_trains, 2);

%% Plot result
figure;
hold on
test = plot(0:N, num_firing_bins, 'sr', 'MarkerSize', 10);
train = plot(0:N, num_firing_bins_tr, '*b', 'MarkerSize', 10);
exp = plot(0:N, experimental_num_firing, '^k', 'MarkerSize', 10);
title('Probability vs. Number of neurons firing');
xlabel('Number of neurons firing');
ylabel('Probability');
legend([test, train, exp], {'Test', 'Training', 'Experimental'});
set(gca, 'FontSize', 14);
print([file filesep 'firing_probabilities'], '-dpng');
end