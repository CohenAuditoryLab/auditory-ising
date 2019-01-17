function output = test_atanh_onehalf(filepath)
    %% load experimental data
    load([filepath filesep 'neuron_trains.mat']);
    neuron_trains = cell2mat(neuron_trains);
    
    neuron_trains_0 = neuron_trains;
    neuron_trains_0(neuron_trains_0<1) = 0;
    
    output = struct;
    %1s and 0s
        % test 1/2 multiplier
        output.h_onehalf = log(mean(neuron_trains_0, 2)./(1-mean(neuron_trains_0, 2)))*0.5;
        % test 1 multiplier
        output.h_one = log(mean(neuron_trains_0, 2)./(1-mean(neuron_trains_0, 2)));
    
    %1s and -1ss
        % test atanh
        output.h_atanh = atanh(mean(neuron_trains,2));
        % test definition
        output.h_atanh_computed = log((mean(neuron_trains, 2)+1)./(1-mean(neuron_trains_0, 2)))*0.5;
end