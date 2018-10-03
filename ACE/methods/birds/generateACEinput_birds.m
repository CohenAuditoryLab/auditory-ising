function result_vector = generateACEinput_birds(data, output_dir)
% generateACEinput_birds - generates *.p file for ACE algorithm from bird ...
    % ... song data
    
    % input variables:
        % data 
            % path of spike time file
        % output_dir
            % directory where output should be saved
    % output variables:
        % result_vector
            % first N (# neurons) rows = firing rates by neuron
            % next N(N-1)/2 rows = pairwise Pearson correlations
    %% LOGIC

        % get data
            spikes_by_bin = importdata(data);
            spikes_by_bin = spikes_by_bin';
        % process data
            % training/test split
                p_train = .8;
                T = size(spikes_by_bin,2);
                train_logical = false(T, 1);
                % change num_bins to jsut be train bins
                num_train_bins = round(p_train*T);
                train_logical(1:num_train_bins) = true;
                train_logical = train_logical(randperm(T));
                train_spikes_by_bin = spikes_by_bin(:,train_logical);
                test_logical = ~train_logical;
            % get firing rates
                num_neurons = size(spikes_by_bin,1);
                firing_rates = zeros([num_neurons 1]);
                for i=1:num_neurons
                    firing_rates(i) = sum(train_spikes_by_bin(i,:))/num_train_bins;
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
                        for b=1:num_train_bins
                            if (train_spikes_by_bin(i,b) >0 & train_spikes_by_bin(j,b) > 0)
                                num_coactive_bins = num_coactive_bins+1;
                            end
                        end
                        result_vector(index) = num_coactive_bins/num_train_bins;
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
                % save neuron_trains file (needed for plot methods)
                    spikes_by_bin(spikes_by_bin==0) = -1;
                    neuron_trains = mat2cell(spikes_by_bin, ones([1 size(spikes_by_bin,1)]), [size(spikes_by_bin,2)]);
                    save([output_dir filesep 'neuron_trains.mat'], 'neuron_trains');
                % save test_logical
                    save([output_dir filesep 'test_logical.mat'], 'test_logical');
                % save C_ij
                    save([output_dir filesep 'c_ij.mat'], 'c_ij');
                % save .p file
                    fid = fopen([output_dir filesep 'ACEinput.p'], 'wt');
                    fprintf(fid,'%1g\n',result_vector);
                    fclose(fid);
end