function runACEonSubsets(data_path, output_dir, same_split)
    if (exist('same_split', 'var')==0)
        same_split = false;
    end
    load(data_path);
    unique_neurons = unique(g(:,1));
    num_neurons = numel(unique_neurons);
    % get current subset size; if none, then subset = number of neurons
        contents = dir(output_dir);
        last_subset = false;
        for i=1:numel(contents)
            if(regexp(contents(i).name, '(num_)\d') ==1)
                if (~last_subset) 
                    last_subset = str2num(cell2mat(regexp(contents(i).name,'\d*','Match')));
                    % if samesplit & this is the first subset, 
                    % save the name for the test_logical
                    % to use for every other subset
                    if (same_split)
                        first_subset_name = contents(i).name;
                    end
                elseif (cell2mat(regexp(contents(i).name,'\d*','Match')) < last_subset) 
                    last_subset = str2num(cell2mat(regexp(contents(i).name,'\d*','Match')));
                end
            end
        end
        if (last_subset ~= false)
            subset_num = last_subset - 1;
        else
            subset_num = num_neurons; % 
            first_subset_name = ['num_' num2str(subset_num)];
        end
    % loop that chooses smaller subsets each time & runs them
    original_g = g;
    while subset_num > 5 
        % get random subset
            subset = datasample(unique_neurons,subset_num,'Replace', false);
            subset_index = ismember(original_g(:,1), subset);
            subset_data = original_g(subset_index,:);
            g = subset_data;
            % save new data
            subset_dir = [output_dir filesep 'num_' num2str(subset_num)];
            mkdir(subset_dir);
            new_data_path = [subset_dir filesep 'subset_data_' num2str(subset_num) '.mat'];
            save(new_data_path, 'g');
        setStandardACEParams;
        p_train = .6;
        if (same_split)
                generateACEinputSpikeTimes(new_data_path, time_units, bin_size, subset_dir,use_chunks, indep_c_ij, 1e4, p_train); 
                % overwrite test_logical & train_logical
                load([output_dir filesep first_subset_name filesep 'test_logical.mat']);
                save([subset_dir filesep 'test_logical.mat'], 'test_logical');
                load([output_dir filesep first_subset_name filesep 'train_logical.mat']);
                save([subset_dir filesep 'train_logical.mat'], 'train_logical');
                runACEonCohenData(subset_dir, ACE_path);     
                plotACEresult(subset_dir, 1, plot_all_points);
        else
            ACEpipeline(new_data_path, subset_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_points);
        end
        
        % save ACE results to new folder
        plotAllJSD(subset_dir); 
        subset_num = subset_num - 1;
    end
end