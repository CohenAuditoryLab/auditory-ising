addpath(genpath('/home/matt/Documents/ACE'));
output = '/home/matt/Documents/Ising/ACE/output/Domo_201800807_Voc_Ripple/20180918';
% generate correlations file
WriteCMSAbin('neuro',[output filesep 'finalclusters.dat'],0,10);

% run ACE algorithm
setenv('LD_LIBRARY_PATH', '/usr/lib/x86_64-linux-gnu/libstdc++.so.6');
system(['/home/matt/Documents/ACE/bin/ace -d ' output ' -i finalclusters -o finalclusters-out -b 119211']);
system(['/home/matt/Documents/ACE/bin/qls -d ' output ' -i finalclusters-out -o finalclusters-out-learn -c finalclusters']);
