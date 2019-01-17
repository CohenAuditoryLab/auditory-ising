function freq = count_ensemble_freq(data, binary_patterns, num_patterns, ensemble_size)
    % calculate the frequency of X (size) neurons being active in one bin    
    freq = zeros(1, num_patterns);
    pb = CmdLineProgressBar('Progress: ');
    data_size = size(data,1);
    for i = 1:num_patterns
        pb.print(i,num_patterns);
        %count = sum(ismember(data, binary_patterns(i, :), 'rows'));
        freq(i) = numel(find(sum(data(:,logical(binary_patterns(i, :))),2)==ensemble_size))/data_size;
    end 
end