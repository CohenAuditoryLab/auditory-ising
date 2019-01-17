addpath(genpath('/home/matt/Documents/ACE'));
% generate correlations file
WriteCMSAbin('neuro','/home/matt/Documents/ACE_output/ForACE__Domo_201800807_Voc_Ripple_finalclusters.dat',0,10);
% run ACE algorithm
system('/home/matt/Documents/ACE/bin/ace -d /home/matt/Documents/ACE_output -i ForACE__Domo_201800807_Voc_Ripple_finalclusters -o ForACE__Domo_201800807_Voc_Ripple_finalclusters-out -b 119211');
%
system('/home/matt/Documents/ACE/bin/qls -d /home/matt/Documents/ACE_output -i ForACE__Domo_201800807_Voc_Ripple_finalclusters-out -o ForACE__Domo_201800807_Voc_Ripple_finalclusters-out-learn -c ForACE__Domo_201800807_Voc_Ripple_finalclusters');
