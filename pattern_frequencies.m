function pattern_frequencies(h0, J, test_logical, file)
%% load experimental data
load(file);
neuron_trains = cell2mat(neuron_trains);
neuron_trains = double(neuron_trains == 1); % switch to 1 and 0 from 1 and -1
neuron_trains = neuron_trains(:,test_logical);
n = size(neuron_trains, 1);

%% compute ising and independent model probability distributions 
% ising
[sigm, states] = sample_ising_exact(h0, J);
% independent
h0_independent = log(mean(neuron_trains, 2)./(1-mean(neuron_trains, 2)))*0.5;
h0_independent = transpose(h0_independent);
[sigm_ind, states_ind] = sample_ising_exact(h0_independent, zeros(n, n));
% convert to 1 and 0 from 1 and -1
sigm = sigm == 1;
sigm_ind = sigm_ind == 1;

neuron_trains = neuron_trains';

N = n;
%define patterns in order of computed probabilities
patterns = sigm;

%% for each pattern, determine frequency of occurrence in Hz 
T = 1e-3; %seconds, length of each bin

numpat = size(patterns, 1);
numtrials = size(neuron_trains, 1);

observed = zeros(1, numpat);

% convert frequencies to Hz 
ising = states/T;
ind = states_ind/T;

% count frequency of occurrence of each pattern in experimental data 
for i = 1:numpat
    disp(['Counting pattern number ' num2str(i) ' of ' num2str(numpat) '...']);
    count = sum(ismember(neuron_trains, patterns(i, :), 'rows'));
    freq = count/numtrials/T;
    observed(i) = freq;
    disp(['Frequencies: ' num2str(freq)]);
end 

filecomps = strsplit(file, filesep);
cd(filecomps{1});
save('pattern_freqs2.mat', 'observed', 'ising', 'ind');
%% plot on log-log scale 

figure();
loglog(observed, ind, '.c', 'MarkerSize', 10);
hold on;
loglog(observed, ising, '.b', 'MarkerSize', 10);
legend({'Independent', 'Ising'}, 'Location', 'SouthEast');
set(gca, 'FontSize', 14);
title('Whole Pattern Frequencies');
xlabel('Observed Frequencies (Hz)');
ylabel('Predicted Frequencies (Hz)');
lin = linspace(10^(-2), 10^2,100);
plot(lin, lin, 'k', 'Linewidth', .75);

end 