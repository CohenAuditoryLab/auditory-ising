function probs = p_dist_neg(subset, h0)
%% compute all possible patterns of neuron firing 
N = numel(h0);
states = zeros(1, 2^N);
numbers = transpose(linspace(1,numel(states),numel(states)));
sigm = de2bi(numbers-1)*2-1;
sigm = sigm==1; %turn into 0 and 1 

%% calculate the probability of each pattern in the subset of data 

numpat = size(sigm, 1);
probs = zeros(1, numpat);
numtrials = size(subset, 1);

for i = 1:numpat
    sum_pattern = sum(subset(:,logical(sigm(i, :))),2);
    sum_nonpattern = sum(subset(:,~logical(sigm(i, :))),2);
    freq = numel(find(sum_pattern == sum(sigm(i, :)) & sum_nonpattern == 0))/numtrials;
    probs(i) = freq;
end 
end 