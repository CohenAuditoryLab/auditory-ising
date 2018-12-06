function testParameterEffectOnACE(data_path, output_dir, time_units, bin_size, ACE_path, mc_algorithm_path, p_train)
% testParameterEffectOnACE - tests J parameter effect on ACE output
    % input variables:
        % data_path 
            % path to *.mat file with a variable g 
            % g - (2xNumber of spikes), 
                % column 1 - neuron ID 
                % column 2 - spike times
        % output_dir
            % (string) directory where output should be saved
        % time_units
            % (double) units in time of the data (e.g. 1e-3, which would correspond
            % to ms)
        % bin_size
            % (double) size of bin in seconds (e.g. 20e-3, or 20 ms bins)
        % ACE_path
            % (string) where ACE is
        % p_train
            % (double) decimal fraction of training data vs. test data
% run ACE 100 times
   
    % add all code to path
        addpath(genpath(fileparts(fileparts(fileparts(mfilename('fullpath'))))));
    % make output dir
        if (exist(output_dir, 'dir')==0)      
            mkdir(output_dir);
        end
    % load output
        if (exist([output_dir filesep 'testParameterEffectOnACE_output.mat'], 'file')==0)
            output_master = [];
        else
            load([output_dir filesep 'testParameterEffectOnACE_output.mat']);
        end
    % set r
        dirs = dir(fullfile(output_dir, 'run*'));
        last_index = numel(dirs);
        if (last_index > 0 & ~isempty(regexp(dirs(last_index).name,'\d+', 'match')))
            r_start = str2num(cell2mat(regexp(dirs(last_index).name,'\d+', 'match')))+1;
        else
            r_start = 1;
        end
        r_start = 15;
    % run ACE once normally (60:40)
        original_output_dir = [output_dir filesep 'original_run'];
        if (exist(original_output_dir, 'dir')==0)      
            mkdir(original_output_dir);
            generateACEinputSpikeTimes(data_path, time_units, bin_size, original_output_dir,0, 0, 1e4, p_train); 
            runACEonCohenData(original_output_dir, ACE_path);
        end
    % figure out # of runs
        load([original_output_dir filesep 'spikes_by_bin.mat']);
        N = size(spikes_by_bin,1);
        num_runs = N*(N-1)/2;
    for r=r_start:num_runs  
        tic
        disp(['Run ' num2str(r) ' out of ' num2str(num_runs)])
        % figure out i & j
        if (numel(output_master)==0)
            i = 1;
            j = 2;
        else
            if (output_master(r-1).j == N)
                i = output_master(r-1).i+1;
                j = 1;
            else
                i = output_master(r-1).i;
                j = output_master(r-1).j+1;
            end
        end
        % create subdir
             sub_output_dir = [output_dir filesep 'run_' num2str(r)];
             if(exist(sub_output_dir, 'dir')==0)
                 mkdir(sub_output_dir);
             end
        % cp data from original dir
            copyfile(original_output_dir, sub_output_dir);
            delete([sub_output_dir filesep 'ACEinput-out.j']);
            delete([sub_output_dir filesep 'ACEinput-out.sce']);
        % edit .p file such that the correlation is random (f_i*f_i)
            edit_ACEinput_P(sub_output_dir, i, j); 
        % run ACE & learning algorithm on the *.p file
            runACEonCohenData(sub_output_dir, ACE_path);
            toc
        % initialize output
            output = struct;
        % extract parameters
            load([sub_output_dir filesep 'spikes_by_bin.mat']);
            N = size(spikes_by_bin,1);
            [h, j_matrix] = extractFittedParameters(N, [sub_output_dir filesep 'ACEinput-out.j']);
            output.h = h;
            output.j_matrix = j_matrix;
            figures_dir = [sub_output_dir filesep 'figures'];
            mkdir(figures_dir);
            load([sub_output_dir filesep 'test_logical.mat']);
            [output.observed, output.ising, output.ind] = pattern_frequencies_all(h', j_matrix, test_logical, sub_output_dir, figures_dir, 1);
        % triads
            output.triads = probability_of_triads2([sub_output_dir filesep 'neuron_trains.mat'], [sub_output_dir filesep 'ACEinput-out.j'], mc_algorithm_path, [sub_output_dir filesep 'triads'], 0, [sub_output_dir filesep 'test_logical.mat'], 0);
            output.i = i; output.j = j;
            output_master = [output_master; output];
            save([output_dir filesep 'testParameterEffectOnACE_output.mat'], 'output_master');
            toc
    end

end

% run ACE once normally (60:40)
% figure out is & js & total # of runs
% iterate over runs
    % create subdir
    % copy ACE input files into subdir
    % edit .p file such that the correlation is random (f_i*f_i)
    % run ACE on this
    % ouput_master
        % extract parameters
        % get JS divergence between all codewords distributions
        % get JS divergence between triads