function freq = count_triad_freq(data, binary_patterns, num_patterns)
    % calculate the frequency of 3 neurons being active in one bin    
    freq = zeros(1, num_patterns);
    pb = CmdLineProgressBar('Progress: ');
    data_size = size(data,1);
    for i = 1:num_patterns
        pb.print(i,num_patterns);
        %count = sum(ismember(data, binary_patterns(i, :), 'rows'));
        freq(i) = numel(find(sum(data(:,logical(binary_patterns(i, :))),2)==3))/data_size;
    end 
end