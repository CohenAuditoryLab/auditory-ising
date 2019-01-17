function result_vector = edit_ACEinput_P(output_dir, special_i, special_j)
% generateACEinput - generates *.p file for ACE algorithm from Cohen ...
    % ... spike time data
    
  
    %% LOGIC
            % set vars
                load([output_dir filesep 'spikes_by_bin.mat']);
                load([output_dir filesep 'train_logical.mat']);
                num_neurons = size(spikes_by_bin,1);
            % training/test split
                train_spikes_by_bin = spikes_by_bin(:,train_logical);
            % get firing rates
                num_train_bins = size(train_spikes_by_bin,2);
                firing_rates = zeros([num_neurons 1]);
                for i=1:num_neurons
                    firing_rates(i) = sum(train_spikes_by_bin(i,:))/num_train_bins;
                end
            % align them in one vector
                vector_length = (num_neurons*(num_neurons-1))/2;
                corr_placeholder_vector = zeros([vector_length 1]);
                result_vector = vertcat(firing_rates, corr_placeholder_vector);
                index = num_neurons;
                c_ij = zeros([num_neurons num_neurons]);
                for i=1:num_neurons
                    for j=i+1:num_neurons
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
                        if (i == special_i & j == special_j)
                            result_vector(index) = firing_rates(i)*firing_rates(j);
                        end
                        c_ij(i,j) = result_vector(index);
                    end
                end
                c_ij = c_ij' + c_ij;
            % save files
                % save C_ij
                    save([output_dir filesep 'c_ij.mat'], 'c_ij');
                % save .p file
                    fid = fopen([output_dir filesep 'ACEinput.p'], 'wt');
                    fprintf(fid,'%1g\n',result_vector);
                    fclose(fid);
                    
                % save ID file
                    fid = fopen([output_dir filesep 'pair_ID.txt'], 'wt');
                    fprintf(fid,'%1g\n',special_i);
                    fprintf(fid,'%1g\n',special_j);
                    fclose(fid);
end