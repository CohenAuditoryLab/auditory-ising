function [h, j_matrix] = extractFittedParameters(data, ACE_output)
% generateACEinput - generates *.p file for ACE algorithm from Cohen data
    % input variables:
        % data 
            % path of spike time file
        % ACE_output
            % *.j file from ACE
    % output variables:
        % h
            % (vector) first parameter in Ising model
        % j_matrix
            % (NxN matrix) 2nd parameter in Ising model
    % load data
    load(data,'g');
    spike_neurons = g(:,1);
    unique_neurons = unique(spike_neurons);
    num_neurons = numel(unique_neurons);
    a = importdata(ACE_output);
    % set variables
    h = a(1:num_neurons);
    index = num_neurons;
    j_matrix = zeros([num_neurons num_neurons]);
    for i=1:num_neurons
        for k=1:num_neurons
            if(i==k || i>k)
                continue;
            end
            index = index+1;
            j_matrix(i,k) = a(index);
        end
    end
    % mirror across diagonal
    j_matrix = j_matrix' + j_matrix;
end