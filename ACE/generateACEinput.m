function result_vector = generateACEinput(data, bin_size, output_dir)
% generateACEinput - generates *.p file for ACE algorithm from Cohen data
    % input variables:
        % data 
            % path of binned file
        % bin_size
            % bin size in seconds
        % output_dir
            % directory where output should be saved
    % output variables:
        % result_vector
            % first N (# neurons) rows = firing rates by neuron
            % next N(N-1)/2 rows = pairwise Pearson correlations
    %% LOGIC
        % get binned data (in ms bins)
            load(data,'spikes_by_bin');
%             if (exist(spikes_by_bin, 'var'))
%                 error('Could not load spikes_by_bin from specified file.')
%             end
        % get firing rates
            num_neurons = size(spikes_by_bin,1);
            firing_rates = zeros([num_neurons 1]);
            for i=1:num_neurons
                %firing_rates(i) = sum(spikes_by_bin(i,:))/size(spikes_by_bin,2)/bin_size;
                firing_rates(i) = sum(spikes_by_bin(i,:))/size(spikes_by_bin,2);
            end
        % get correlations
            [A,~] = corrcoef(spikes_by_bin'); %A = pairwise Pearson correlation matrix
        % align them in one vector
            vector_length = (num_neurons*(num_neurons-1))/2;
            corr_placeholder_vector = zeros([vector_length 1]);
            result_vector = vertcat(firing_rates, corr_placeholder_vector);
            index = num_neurons;
            for i=1:num_neurons
                for j=1:num_neurons
                    if(i==j || i>j)
                        continue;
                    end
                    index = index+1;
                    result_vector(index) = A(i,j);
                end
            end
        % save file
        fid = fopen([output_dir filesep 'ACEinput.p'], 'wt');
        fprintf(fid,'%1g\n',result_vector);
        fclose(fid);
end