function probs = p_dist(subset, h0, J)
%% compute all possible patterns of neuron firing 
[sigm, ~] = sample_ising_exact(h0, J);
sigm = sigm==1; %turn into 0 and 1 

%% calculate the probability of each pattern in the subset of data 

numpat = size(sigm, 1);
probs = zeros(1, numpat);
numtrials = size(subset, 1);

for i = 1:numpat
%     disp(['Counting pattern number ' num2str(i) ' of ' num2str(numpat) '...']);
    count = sum(ismember(subset, sigm(i, :), 'rows'));
    freq = count/numtrials;
    probs(i) = freq;
end 

end 