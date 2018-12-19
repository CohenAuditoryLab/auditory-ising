function plotAllJSD(output_dir)
    data_path = [output_dir filesep 'figures' filesep 'pattern_freqs_all.mat'];
    probs = load(data_path);
    % compute JSD & MSE
    JSD_ind = calculateJSD(probs.observed', probs.ind');
    JSD_ising = calculateJSD(probs.observed', probs.ising');
    
    % create figure
    figure;
    JSD_ind = log10(JSD_ind);
    JSD_ising = log10(JSD_ising);
    JSD_bins = linspace(-4, 0, 41)-0.05;
    histogram(JSD_ising, JSD_bins, 'normalization', 'pdf');
    hold on;
    histogram(JSD_ind, JSD_bins, 'normalization', 'pdf');
    legend({'Pairwise', 'Independent'});
    ax = gca;
    lab = ax.XTick;
    labels = {};
    for b=1:numel(lab)
        labels{end+1} = ['10^' '{' num2str(lab(b)) '}'];
    end 
    set(gca, 'XTickLabel', labels);
    set(gca,'ytick',[]);
    xlabel('JS Divergence');
    print([output_dir filesep 'figures' filesep 'JS_hist_all'], '-dpng');
    hold off;
    close all;
end