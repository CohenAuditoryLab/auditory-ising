addpath(genpath('/Users/mschaff/Documents/REPOS/ACE'));
% generate correlations file
WriteCMSAbin('neuro','/Users/mschaff/Documents/DISSERTATION/Code/Ising/ACE/201800807_Voc_Ripple_20ms_1000iter/20180913/ForACE__Domo_201800807_Voc_Ripple_finalclusters.dat',0,10);
% run ACE algorithm
system('/Users/mschaff/Documents/REPOS/ACE/bin/ace -d /Users/mschaff/Documents/DISSERTATION/Code/Ising/ACE/201800807_Voc_Ripple_20ms_1000iter/20180913 -i ForACE__Domo_201800807_Voc_Ripple_finalclusters -o ForACE__Domo_201800807_Voc_Ripple_finalclusters-out -b 119211');
%
system('/Users/mschaff/Documents/REPOS/ACE/bin/qls -d /Users/mschaff/Documents/DISSERTATION/Code/Ising/ACE/201800807_Voc_Ripple_20ms_1000iter/20180913 -i ForACE__Domo_201800807_Voc_Ripple_finalclusters-out -o ForACE__Domo_201800807_Voc_Ripple_finalclusters-out-learn -c ForACE__Domo_201800807_Voc_Ripple_finalclusters');
    
%9/17/18
    % prep data
    load('/Users/mschaff/Documents/DISSERTATION/Code/Ising/DomoOutput_Boltzmann/201800807_Voc_Ripple_20ms_1000iter/Domo_201800807_Voc_Ripple_finalclusters.mat');
    % get 2 minutes of data
    a = g(find(g(:,2) < 120000),:);
    % make folder
    new_folder = '/Users/mschaff/Documents/DISSERTATION/Code/Ising/ACE/201800807_Voc_Ripple_20ms_1000iter/20180917';
    if (exist(new_folder, 'dir'))
    else
        mkdir(new_folder);
    end
    % save new data
    output2 = a;
    output2(:,1) = a(:,2);
    output2(:,2) = a(:,1);
    output2(:,1) = round(output2(:,1));
    fileID = fopen([new_folder filesep 'raw_first_2_minutes.dat'],'w');
    fprintf(fileID,'%g   %g\n',output2.');
    fclose(fileID);
    % run ACE
    % add ACE to path
        addpath(genpath('/Users/mschaff/Documents/REPOS/ACE'));
        % generate correlations file
        WriteCMSAbin('neuro',[new_folder filesep 'raw_first_2_minutes.dat'],0,10);
        % run ACE algorithm
        system('/Users/mschaff/Documents/REPOS/ACE/bin/ace -d /Users/mschaff/Documents/DISSERTATION/Code/Ising/ACE/201800807_Voc_Ripple_20ms_1000iter/20180917 -i raw_first_2_minutes -o raw_first_2_minutes-out -b 11995');
        %
        system('/Users/mschaff/Documents/REPOS/ACE/bin/qls -d /Users/mschaff/Documents/DISSERTATION/Code/Ising/ACE/201800807_Voc_Ripple_20ms_1000iter/20180917 -i raw_first_2_minutes-out -o raw_first_2_minutes-out-learn -c raw_first_2_minutes');

% 9/19/18
    % make folder
        new_folder = '/Users/mschaff/Documents/DISSERTATION/Code/Ising/ACE/201800807_Voc_Ripple_20ms_1000iter/20180918';
        if (exist(new_folder, 'dir'))
        else
            mkdir(new_folder);
        end
    % create correlations file with different bin sizes
        bin_sizes = [20 50 100 200];
        for i=1:numel(bin_sizes)
            %create bin folder
                new_bin_folder = [new_folder filesep num2str(bin_sizes(i))];
                if (exist(new_bin_folder, 'dir'))
                else
                    mkdir(new_bin_folder);
                end
            % copy file
                new_spike_times_path = [new_bin_folder filesep 'spike_times.dat'];
                copyfile('/Users/mschaff/Documents/DISSERTATION/Code/Ising/ACE/201800807_Voc_Ripple_20ms_1000iter/20180913/ForACE__Domo_201800807_Voc_Ripple_finalclusters.dat',new_spike_times_path);
            % run ACE helper function to create correlations,
            % WriteCMSAbin.m
                WriteCMSAbin('neuro',new_spike_times_path,0,bin_sizes(i));
        end