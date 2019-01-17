% 9/20/2018

% PURPOSE OF THIS FILE
    % to run ACE algorithm on custom generated *.p file from Domo data
    
% add path
    addpath(genpath('/home/matt/Documents/ACE'));
    output = '/home/matt/Documents/Ising/ACE/output/Domo_201800807_Voc_Ripple/20180920';
% run ACE algorithm
    setenv('LD_LIBRARY_PATH', '/usr/lib/x86_64-linux-gnu/libstdc++.so.6');
    system(['/home/matt/Documents/ACE/bin/ace -d ' output ' -i ACEinput -o ACEinput-out -b 119211']);
% run qls
    system(['/home/matt/Documents/ACE/bin/qls -d ' output ' -i ACEinput-out -o ACEinput-out-learn -c ACEinput']);
