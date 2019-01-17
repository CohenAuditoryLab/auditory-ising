function firing_rate_graph(spikes_by_bin, bin_size, output_dir)
% firing_rate_graph - plots firing rates per neuron of binned spike data

    % inputs:
        % spikes_by_bin 
            % Nxbins neural data
        % bin_size
            % size of time bin in seconds (e.g. 1e-3 for millisecond bins)
        % output_dir
            % where to save graph
    % set up vars
        if exist('output_dir', 'var') == 0
            output_dir_set = false;
        else
            output_dir_set = true;
        end
        N = size(spikes_by_bin,1);
        firing_window = 30; % seconds
        num_small_bins = 1/bin_size*firing_window;
        num_windows = floor(size(spikes_by_bin,2)/num_small_bins);
        firing_rates = zeros(N, num_windows);
        x = firing_window:firing_window:num_windows*firing_window;
        h = figure; hold on;
        
    % loop through cells
        for k=1:size(spikes_by_bin,1)
            for i=1:num_windows
                % get firing rate in window
                    firing_rates(k,i) = sum(spikes_by_bin(k,(i-1)*num_small_bins+1:i*num_small_bins))/firing_window; % in Hz
            end
            % plot firing rates
                plot(x,firing_rates(k,:));
        end
        xlabel('Seconds');
        ylabel('Firing Rate');
        title('Firing Rate of Neurons over Time');
        hold off;
        if (output_dir_set)
            saveas(h, [output_dir filesep 'firing_rate.png']);
        end
        close all;
end