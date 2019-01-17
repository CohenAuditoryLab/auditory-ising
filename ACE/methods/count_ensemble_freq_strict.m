function freq = count_ensemble_freq_strict(data, binary_patterns, num_patterns, ensemble_size)
    % calculate the frequency of 3 neurons being active in one bin STRICT
    % strict definition -- 3 neurons are active, and all the other neurons
    % are silent
    freq = zeros(1, num_patterns);
    pb = CmdLineProgressBar('Progress: ');
    data_size = size(data,1);
    for i = 1:num_patterns
        pb.print(i,num_patterns);
        sum_triad = sum(data(:,logical(binary_patterns(i, :))),2);
        sum_nontriad = sum(data(:,~logical(binary_patterns(i, :))),2);
        freq(i) = numel(find(sum_triad == ensemble_size & sum_nontriad == 0))/data_size;
    end 
end