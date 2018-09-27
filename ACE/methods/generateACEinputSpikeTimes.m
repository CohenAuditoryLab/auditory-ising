function result_vector = generateACEinputSpikeTimes(data, time_units, bin_size, output_dir, chunk, chunk_size)
% generateACEinput - generates *.p file for ACE algorithm from Cohen ...
    % ... spike time data
    
    % input variables:
        % data 
            % path of spike time file
        % time_units
            % units in time of the data (e.g. 1e-3, which would correspond
            % to ms)
        % bin_size
            % size of bin in seconds (e.g. 20e-3, or 20 ms bins)
        % output_dir
            % directory where output should be saved
        % chunk
            % (boolean) whether to chunk the data
        % chunk_size
            % (integer) number of bins in a chunk (except for remainder
            % chunk)
    % output variables:
        % result_vector
            % first N (# neurons) rows = firing rates by neuron
            % next N(N-1)/2 rows = pairwise Pearson correlations
    %% LOGIC
        % set vars
            time_multiplier = time_units;
            if exist('chunk', 'var') == 0
                chunk = false;
                num_chunks = 1;
            else if (chunk == 0)
                    num_chunks = 1;
            end
            if exist('chunk_size', 'var') == 0
                chunk_size = 1e4;
            end
            % get data
            load(data,'g');
            spike_times = g(:,2);
            spike_neurons = g(:,1);
            unique_neurons = unique(spike_neurons);
            num_neurons = numel(unique_neurons);
        % set bin sizes
            max_time = double(max(spike_times))*time_multiplier;
            num_bins = round(max_time/bin_size) + 1;
            bins = 1:num_bins;
        % bin data
            spikes_by_bin = zeros(num_neurons, num_bins);
            for i = 1:num_neurons % 1 to num clusters
                % get spike times of the cell
                cluster_spikes = double(spike_times(find(spike_neurons==unique_neurons(i)))).*1e-3; % now in seconds
                % collect by bin
                spikes_by_bin(i,:) = histc((cluster_spikes),bins*bin_size);
            end
        % chunk data
           if (chunk)
               num_chunks = round(num_bins/chunk_size);
               if (exist(output_dir, 'dir') == 0)
                    mkdir(output_dir);
               end
               all_spikes_by_bin = spikes_by_bin;
               original_output_dir = output_dir;
               original_num_bins = num_bins;
           end
           
           for n=1:num_chunks
                % get chunk
                if (chunk)
                    if (original_num_bins > n*chunk_size) 
                        spikes_by_bin = all_spikes_by_bin(:,(n-1)*chunk_size+1:n*chunk_size);
                        num_bins_in_chunk = chunk_size;
                    else
                        spikes_by_bin = all_spikes_by_bin(:,(n-1)*chunk_size+1:end);
                        num_bins_in_chunk = original_num_bins - (n-1)*chunk_size;
                    end
                    num_bins = num_bins_in_chunk;
                    output_dir = [original_output_dir filesep 'chunk_' num2str(n) '__' num2str(num_bins)];
                    disp(['Outputting chunk ' num2str(n) ' into ' output_dir]);
                end
                % get firing rates
                    firing_rates = zeros([num_neurons 1]);
                    for i=1:num_neurons
                        %firing_rates(i) = sum(spikes_by_bin(i,:))/size(spikes_by_bin,2)/bin_size;
                        firing_rates(i) = sum(spikes_by_bin(i,:))/num_bins;
                    end
                % align them in one vector
                    vector_length = (num_neurons*(num_neurons-1))/2;
                    corr_placeholder_vector = zeros([vector_length 1]);
                    result_vector = vertcat(firing_rates, corr_placeholder_vector);
                    index = num_neurons;
                    c_ij = zeros([20 20]);
                    for i=1:num_neurons
                        for j=1:num_neurons
                            if(i==j || i>j)
                                continue;
                            end
                            index = index+1;
                            % get special pairwise correlation as defined by ACE:
                                % number of bins where 2 neurons are both active
                                % divded by total number of bins
                            num_coactive_bins = 0;
                            for b=1:num_bins
                                if (spikes_by_bin(i,b) >0 & spikes_by_bin(j,b) > 0)
                                    num_coactive_bins = num_coactive_bins+1;
                                end
                            end
                             %disp([ num2str(num_coactive_bins) ' - pairwise coactive correlation for neurons' num2str(i) ' and ' num2str(j) '.']);
                            result_vector(index) = num_coactive_bins/num_bins;
                            c_ij(i,j) = result_vector(index);
                        end
                    end
                    c_ij = c_ij' + c_ij;
                % save files
                    if (exist(output_dir, 'dir') == 0)
                        mkdir(output_dir);
                    end
                    % save spikes_by_bin
                        save([output_dir filesep 'spikes_by_bin.mat'], 'spikes_by_bin');
                    % save C_ij
                        save([output_dir filesep 'c_ij.mat'], 'c_ij');
                    % save .p file
                        fid = fopen([output_dir filesep 'ACEinput.p'], 'wt');
                        fprintf(fid,'%1g\n',result_vector);
                        fclose(fid);
            end
end