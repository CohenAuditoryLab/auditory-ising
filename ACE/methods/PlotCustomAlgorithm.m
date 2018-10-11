function PlotCustomAlgorithm(output_dir)
    
    % initialize variables
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
            
           
            % generate figures 
            disp(['Generating custom algorithm figures for ' output_dir]);
            
                % figures directory
                figures_dir = [output_dir filesep 'figures_custom'];
                if (exist(figures_dir, 'dir') == 0)
                    mkdir(figures_dir);
                end
                 % extract fitted parameters from custom algorithm
                disp(['Extracting cutom fit parameters ' output_dir]);
                load([figures_dir filesep 'h_custom.mat']);
                load([figures_dir filesep 'j_matrix.mat']);
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
                pattern_frequencies_subset(h, j_matrix, 10, test_logical, output_dir, figures_dir,0);
                
                % JS divergence
                JS_hist(h, j_matrix, test_logical, output_dir, figures_dir,0);
                hold off;
                close all;
        end
end
