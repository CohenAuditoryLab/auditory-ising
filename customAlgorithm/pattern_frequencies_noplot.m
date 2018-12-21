function output = pattern_frequencies_noplot(h0, J, output_dir, zeros_and_ones)

%% load experimental data
load([output_dir filesep 'neuron_trains.mat']);
load([output_dir filesep 'test_logical.mat']);
neuron_trains = cell2mat(neuron_trains);
neuron_trains(neuron_trains > 0) = 1;
test_neuron_trains = neuron_trains(:,test_logical);
load([output_dir filesep 'train_logical.mat']);
train_neuron_trains = neuron_trains(:,train_logical);
n = size(test_neuron_trains, 1);
%% compute ising and independent model results 
if (zeros_and_ones)
    [sigm, states] = sample_ising_exact_0(h0, J);
else
    [sigm, states] = sample_ising_exact(h0, J);
end

h0_independent = atanh(mean(train_neuron_trains,2));
h0_independent = transpose(h0_independent);
disp('Estimating patterin probabilities in independent model.');
[sigm_ind, states_ind] = sample_ising_exact(h0_independent, zeros(n, n));

test_neuron_trains = test_neuron_trains';
patterns = sigm;
patterns(patterns<1) = -1;
%% for each pattern, determine frequency of occurrence in Hz 

numpat = size(patterns, 1);
numtrials = size(test_neuron_trains, 1);

observed = zeros(1, numpat);
ising = states;%/T;
ind = states_ind;%/T;

disp('Measuring patterin probabilities in data.');
tic
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
toc

output = struct;
output.observed = observed;
output.ising = ising;
output.ind = ind;
save([output_dir filesep 'pattern_frequencies.mat'], 'output');
end 