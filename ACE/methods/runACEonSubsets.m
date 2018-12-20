function runACEonSubsets(data_path, output_dir)
    load(data_path);
    unique_neurons = unique(g(:,1));
    num_neurons = numel(unique_neurons);
    % get current subset size; if none, then subset = number of neurons
        contents = dir(output_dir);
        last_subset = false;
        for i=1:numel(contents)
            if(regexp(contents(i).name, '(num_)\d') ==1)
                if (cell2mat(regexp(contents(i).name,'\d*','Match')) < last_subset) 
                    last_subset = str2num(cell2mat(regexp(contents(i).name,'\d*','Match')));
                end
            end
        end
        if (last_subset ~= false)
            subset_num = last_subset - 1;
        else
            subset_num = num_neurons; % 
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
        ACEpipeline(new_data_path, subset_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij, p_train, plot_all_points);
        % save ACE results to new folder
        plotAllJSD(subset_dir); 
        subset_num = subset_num - 1;
    end
end