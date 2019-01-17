% get indep model of birds
load('/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/bin_by_bird.mat');
data_bird = spikes_by_bin';
% data_bird_neg = data_bird;
% data_bird_neg(data_bird_neg < 1) = -1;
% h_i = atanh(mean(data_bird_neg));
h_i =log(mean(data_bird)./(1-mean(data_bird)));
h_i = h_i';
fid = fopen('indep_bird.j', 'wt');
fprintf(fid,'%1g\n',h_i);
N = numel(h_i);
num_j = (N*(N-1))/2;
J_ij = zeros([num_j 1]);
fprintf(fid,'%1g\n',J_ij);
fclose(fid);