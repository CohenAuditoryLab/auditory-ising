function result_vector = generateACEinputCustomCorr(data, output_dir)
% generateACEinput - generates *.p file for ACE algorithm from Cohen data
    % input variables:
        % data 
            % path of binned file
        % output_dir
            % directory where output should be saved
    % output variables:
        % result_vector
            % first N (# neurons) rows = firing rates by neuron
            % next N(N-1)/2 rows = pairwise Pearson correlations
    %% LOGIC
        % get binned data (in ms bins)
            load(data,'spikes_by_bin');
        % get firing rates
            num_neurons = size(spikes_by_bin,1);
            num_bins = size(spikes_by_bin,2);
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
                     disp([ num2str(num_coactive_bins) ' - pairwise coactive correlation for neurons' num2str(i) ' and ' num2str(j) '.']);
                    result_vector(index) = num_coactive_bins/num_bins;
                end
            end
        % save file
        fid = fopen([output_dir filesep 'ACEinput.p'], 'wt');
        fprintf(fid,'%1g\n',result_vector);
        fclose(fid);
end