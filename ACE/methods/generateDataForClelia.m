function generateDataForClelia(data, output_dir)
    % get matrix of spike trains by neuron
    load(data);
    % invert matrix 
    spikes_by_bin(spikes_by_bin > 0) = 1;
    a = spikes_by_bin.';
    % get placeholder text string to put in fprint
    placeholder_string = '';
    for i=1:size(a,2)
        placeholder_string = [placeholder_string '%1g'];
    end
    % save file
    fid = fopen([output_dir filesep 'dataForCelia.txt'], 'wt');
    fprintf(fid,[placeholder_string '\n'],a);
    fclose(fid);
end