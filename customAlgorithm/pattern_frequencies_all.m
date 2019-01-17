function [observed, ising, ind] = pattern_frequencies_all(h0, J, test_logical, filepath, figures_dir, zeros_and_ones)

%% load experimental data
disp('Generating codewords probability figure on all elements.');
load([filepath filesep 'neuron_trains.mat']);
neuron_trains = cell2mat(neuron_trains);
neuron_trains(neuron_trains > 0) = 1;
%test_neuron_trains = double(test_neuron_trains == 1);
test_neuron_trains = neuron_trains(:,test_logical);
load([filepath filesep 'train_logical.mat']);
train_neuron_trains = neuron_trains(:,train_logical);
n = size(test_neuron_trains, 1);
k = n;
%% extract k neurons randomly
if (exist([figures_dir filesep 'selection_logical.mat'], 'file') == 0)
    p_train = k/n;
    selection_logical = false(n, 1);
    selection_logical(1:round(p_train*n)) = true;
    selection_logical = selection_logical(randperm(n));
    % save selection logical
        save([figures_dir filesep 'selection_logical.mat'], 'selection_logical');
        fid = fopen([figures_dir filesep 'selection_logical.txt'], 'wt');
        fprintf(fid,'%1g\n',selection_logical);
        fclose(fid);
else
   load([figures_dir filesep 'selection_logical.mat']);
end

% something is very weird with the 7th bird
if (isempty(strfind(lower(filepath), 'bird'))) 
else
    selection_logical(7) = false; 
end

%test_neuron_trains = test_neuron_trains(selection_logical, :);
%train_neuron_trains = train_neuron_trains(selection_logical, :);
% get corresponding parameters
%h0 = h0(selection_logical);
%J = J(selection_logical, selection_logical);

%% compute ising and independent model results 
if (zeros_and_ones)
    [sigm, states] = sample_ising_exact_0(h0, J);
else
    [sigm, states] = sample_ising_exact(h0, J);
end

%h0_independent = log(mean(test_neuron_trains, 2)./(1-mean(test_neuron_trains, 2)))*0.5;
h0_independent = atanh(mean(train_neuron_trains,2));
h0_independent = transpose(h0_independent);
%k = numel(h0);
disp('Estimating pattern probabilities in independent model.');
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
ising = states;%/T;
ind = states_ind;%/T;

disp('Measuring pattern probabilities in data.');
pb = CmdLineProgressBar('Progress: ');
observed_trains = test_neuron_trains; observed_trains(observed_trains < 1) = 0; observed_trains(observed_trains > 0) = 1;
for i = 1:numpat
    pb.print(i,numpat);
    pattern = patterns(i, :); pattern(pattern < 1) = 0; pattern(pattern > 0) = 1;
    sum_pattern = sum(observed_trains(:,logical(pattern)),2);
    sum_nonpattern = sum(observed_trains(:,~logical(pattern)),2);
    freq = numel(find(sum_pattern == sum(pattern) & sum_nonpattern == 0))/numtrials;
    observed(i) = freq;
end 
save([figures_dir filesep 'pattern_freqs_all.mat'], 'observed', 'ising', 'ind');
%% plot on log-log scale 

figure();
l1 = loglog(observed, ind, '.c', 'MarkerSize', 10);
hold on;

l2 = loglog(observed, ising, '.b', 'MarkerSize', 10);
set(gca, 'FontSize', 14);
xlabel('Observed Pattern Probabilities per Bin');
ylabel('Predicted Pattern Probabilities per Bin');
x1 = xlim;
lin = linspace(x1(1), x1(2), 100);
plot(lin, lin, 'k', 'Linewidth', .75);
legend([l1 l2], 'Independent', 'Pairwise', 'Location', 'SouthEast');
print([figures_dir filesep 'whole_pattern_frequencies_all'], '-dpng');
close all;
end 