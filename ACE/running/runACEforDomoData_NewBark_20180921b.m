% 9/21/2018

% PURPOSE OF THIS FILE
    % to run ACE algorithm on custom generated *.p file from Domo data
    
% create output dir
    base_output = '/home/matt/Documents/Ising/output/ACE_NewBark/'; 
    output = [base_output '20180921b'];
    if (exist(output, 'dir') == 0)
        mkdir(output);
    end
% generate .p file
    addpath(genpath('../'));
    data = '../../../data/ACE/201800807_Voc_Ripple/final_clusters.mat';
    bin_size = 20e-3;
    time_units = 1e-3;
    generateACEinputSpikeTimes(data, time_units, bin_size, output);
% add ACE path
    ACE_path = '/home/matt/Documents/ACE';
    addpath(genpath(ACE_path));
% run ACE algorithm
    setenv('LD_LIBRARY_PATH', '/usr/lib/x86_64-linux-gnu/libstdc++.so.6');
    system([ACE_path '/bin/ace -d ' output ' -i ACEinput -o ACEinput-out -b 1192108']);
% run qls
    system([ACE_path '/bin/qls -d ' output ' -i ACEinput-out -o ACEinput-out-learn -c ACEinput']);
