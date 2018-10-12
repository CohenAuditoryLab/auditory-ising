function freq = count_pattern_freq(data, binary_patterns, num_patterns)
    freq = zeros(1, num_patterns);
    pb = CmdLineProgressBar('Progress: '); 
    for i = 1:num_patterns
        pb.print(i,num_patterns);
        count = sum(ismember(data, binary_patterns(i, :), 'rows'));
        freq(i) = count/size(data,1);
    end 
end