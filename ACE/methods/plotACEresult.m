function plotACEresult(output_dir, zeros_and_ones, all_elements)
    
    % initialize variables
        if (exist('all_elements', 'var') == 0)
            all_elements = false;
        end
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
            
            % extract fitted parameters from ACE algorithm
            disp(['Extracting parameters from ACE algorithm on ' output_dir]);
            b = dir(fullfile(output_dir, '*out.j'));
            [~,name,ext] = fileparts([b.folder filesep b.name]);
            [h, j_matrix] = extractFittedParameters(N,[output_dir filesep name '.j']);

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
                pattern_frequencies_subset(h', j_matrix, 10, test_logical, output_dir, figures_dir, zeros_and_ones);
                if (all_elements); pattern_frequencies_all(h', j_matrix, test_logical, output_dir, figures_dir, zeros_and_ones); end
                
                % JS divergence
                JS_hist(h', j_matrix, test_logical, output_dir, figures_dir, zeros_and_ones);
                
                hold off;
                close all;
        end
end