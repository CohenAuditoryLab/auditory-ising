function plotACEresult(output_dir, ACE_path)
    
    % initialize variables
        if exist('ACE_path', 'var') == 0
             ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        end
        addpath(genpath(ACE_path));
        % add path to respository
        addpath(genpath(fileparts(fileparts(fileparts(mfilename('fullpath'))))));
        % load data
        chunks = dir(fullfile(output_dir, 'chunk*'));
        % determine if there are chunks
        if (length(chunks) == 0)
            num_chunks = 1;
            no_chunks = true;
        else
            num_chunks = numel(chunks);
            no_chunks = false;
            disp('Data is chunked.');
        end
        % loop through chucnks
        for i =1:num_chunks
            if (~no_chunks)
                output_dir = [chunks(i).folder filesep chunks(i).name];
            end
            % load test_logical and get size of training data
            load([output_dir filesep 'test_logical.mat']);
            num_bins = numel(find(test_logical == 0));
            % get # of neurons
            load([output_dir filesep 'spikes_by_bin.mat']);
            N = size(spikes_by_bin, 1);
            % save neuron_trains file (needed for plot methods)
            neuron_trains = mat2cell(spikes_by_bin, ones([1 size(spikes_by_bin,1)]), [size(spikes_by_bin,2)]);
            save([output_dir filesep 'neuron_trains.mat'], 'neuron_trains');
            % extract fitted parameters from ACE algorithm
            disp(['Extracting parameters from ACE algorithm on ' output_dir]);
            b = dir(fullfile(output_dir, '*learn.j'));
            [~,name,ext] = fileparts([b.folder filesep b.name]);
            [h, j_matrix] = extractFittedParameters(N,[output_dir filesep name '.j']);
            
            % get probability distributions from fitted parameters
            %[sigm_new, states_new] = sample_ising_exact(h', j_matrix);
            
            % generate figures 
            disp(['Generating figures for ' output_dir]);
            
                % figures directory
                figures_dir = [output_dir filesep 'figures'];
                if (exist(figures_dir, 'dir') == 0)
                    mkdir(figures_dir);
                end
                
                % J_ij heatmap
                heatmap(j_matrix);
                title('J_ij');
                saveas(gcf,[figures_dir filesep 'Jij.jpg']);
                close all;
                
                % C_ij heatmap
                load([output_dir filesep 'c_ij.mat']);
                heatmap(c_ij);
                title('C_ij');
                saveas(gcf,[figures_dir filesep 'C_ij.jpg']);
                close all;
                
                % Pattern frequencies
                pattern_frequencies_subset(h', j_matrix, 10, test_logical, output_dir);
                
                % JS divergence
                %JS_hist(h', j_matrix, test_logical, output_dir);
                hold off;
        end
end