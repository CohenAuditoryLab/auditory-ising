function plotParameterH_indep_v_ising(output_dir)
% load experimental data
    load([output_dir filesep 'neuron_trains.mat']);
    load([output_dir filesep 'test_logical.mat']);
    neuron_trains = cell2mat(neuron_trains);
    neuron_trains(neuron_trains > 0) = 1;
    neuron_trains(neuron_trains < 1) = 0;
%test_neuron_trains = double(test_neuron_trains == 1);
    test_neuron_trains = neuron_trains(:,test_logical);
    load([output_dir filesep 'train_logical.mat']);
    train_neuron_trains = neuron_trains(:,train_logical);

    h0_independent = log(mean(test_neuron_trains, 2)./(1-mean(test_neuron_trains, 2)));
    h0_independent = transpose(h0_independent);

    N = size(test_neuron_trains, 1);
    [h, j_matrix] = extractFittedParameters(N, [output_dir filesep 'ACEinput-out.j']);
 % figure 1 h parameter 
    figure(); 
    p1 = plot(h); hold on; p2 = plot(h0_independent); hold off; 
    lgd = legend({'Pairwise', 'Independent'}); 
    lgd.FontSize = 40;
    ylim([min(h0_independent)*1.2 0]);
    p1.LineWidth = 4; p2.LineWidth = 4;
    p1.Color = 'm'; p2.Color = 'c';
    set(gca,'fontsize',30);
    print([output_dir filesep 'figures' filesep 'h_parameters.png'], '-dpng');
    close all;
end