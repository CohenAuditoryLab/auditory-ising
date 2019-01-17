function JSD_master = distributionJSDmultipleRunACE(output_dir)
%% get all-probability JSD distribution of multiple runs of ACE
    % initialize output
    JSD_master = [];
    % get all directory paths
    contents = dir(output_dir);
    % loop through directory paths
    for j=1:numel(contents)
        if(regexp(contents(j).name, '(run_)\d') ==1)
           run_dir = [contents(j).folder filesep contents(j).name];
           % extract parameters
           load([run_dir filesep 'spikes_by_bin.mat']);
           N = size(spikes_by_bin, 1);
           [h, j_matrix] = extractFittedParameters(N, [run_dir filesep 'ACEinput-out.j']);
           % calculate probabilities of data pairwise & indep
           zeros_and_ones = 1; 
           freq = pattern_frequencies_noplot(h', j_matrix, run_dir, zeros_and_ones);
           output = struct;
           % calculate JSD
           output.JSD_indep = calculateJSD(freq.observed, freq.ind);
           output.JSD_pairwise = calculateJSD(freq.observed, freq.ising);
           JSD_master = [JSD_master; output];
           disp(run_dir);
        end
    end
    save([output_dir filesep 'JSD_output.mat'], 'JSD_master');
    
    %% FIGURE
    figure();

    % for obs_is
    %convert to log scale
    log_obs_is = log10([JSD_master.JSD_pairwise]);
    %bins from 10^-4 to 10^0
    bins = linspace(-4, 0, 41)-0.05;
    %normalized in the x log space to have an area of 1
    histogram(log_obs_is, bins, 'normalization', 'pdf');

    hold on;

    % for obs_ind
    log_obs_ind = log10([JSD_master.JSD_indep]);
    histogram(log_obs_ind, bins, 'normalization', 'pdf');

    xlabel('JS Divergence (bits)');
    ylabel('Probability Density');
    set(gca, 'FontSize', 14);
    legend({'Pairwise', 'Independent'});

    ax = gca;
    lab = ax.XTick;
    labels = {};
    for b=1:numel(lab)
        labels{end+1} = ['10^' '{' num2str(lab(b)) '}'];
    end 

    set(gca, 'XTickLabel', labels);
    print([output_dir filesep 'all_JS_hist_multiple_runs'], '-dpng');
    close all;
    hold off;
end