function multipleRunACE(data_path, output_dir, time_units, bin_size, ACE_path, mc_algorithm_path, p_train, num_iterations, triads)
% multipleRunACE - runs ACE 100 times
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
    % do triads
        if (exist('triads', 'var') == 0)
            triads = false;
        end
    % num iterations
        if (exist('num_iterations', 'var') == 0)
            num_iterations = 100;
        end
    % add all code to path
        addpath(genpath(fileparts(fileparts(fileparts(mfilename('fullpath'))))));
    % load output
        if (exist([output_dir filesep 'multipleRunACE_output.mat'], 'dir')~=0)
            load([output_dir filesep 'multipleRunACE_output.mat']);
        else
            output_master = [];
        end
    % set i
        dirs = dir(fullfile(output_dir, 'run*'));
        last_index = numel(dirs);
        if (last_index > 0 & ~isempty(regexp(dirs(last_index).name,'\d+', 'match')))
            i_start = str2num(cell2mat(regexp(dirs(last_index).name,'\d+', 'match')))+1;
        else
            i_start = 1;
        end
        
    for i=i_start:num_iterations  
        disp(['Run ACE multiple, iteration #' num2str(i)]);
        tic
        % initialize output
            output = struct;
        % generate ACE input files, with a training + test split
            sub_output_dir = [output_dir filesep 'run_' num2str(i)];
            generateACEinputSpikeTimes(data_path, time_units, bin_size, sub_output_dir,0, 0, 1e4, p_train); 
        % run ACE & learning algorithm on the *.p file
            runACEonCohenData(sub_output_dir, ACE_path);
            toc
        % extract parameters
            load([sub_output_dir filesep 'spikes_by_bin.mat']);
            N = size(spikes_by_bin,1);
            [h, j_matrix] = extractFittedParameters(N, [sub_output_dir filesep 'ACEinput-out.j']);
            output.h = h;
            output.J = j_matrix;
        % triads
            if (triads)
                output.triads = probability_of_triads2([sub_output_dir filesep 'neuron_trains.mat'], [sub_output_dir filesep 'ACEinput-out.j'], mc_algorithm_path, [sub_output_dir filesep 'triads'], 0, [sub_output_dir filesep 'test_logical.mat'], 0);
            end
            output_master = [output_master; output];
            save([output_dir filesep 'multipleRunACE_output.mat'], 'output_master');
            toc
    end

end