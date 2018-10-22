% compare J matrix variance & triad JS divergence

% load multiple ACE output
    output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181021/20180807_Ripple2_d01_60_40_firsthalf';
    load([output_dir filesep 'multipleRunACE_output.mat'])
    figures_dir = [output_dir filesep 'figures'];
    mkdir(figures_dir);
% get J matrices in columns of vectors
    num_runs = numel(output_master);
    N = numel(output_master(1).h);
    num_J_values = N*(N-1)/2;
    j_matrices = zeros([num_J_values num_runs]);
    for r=1:num_runs
        j_matrix = output_master(r).J;
        index = 0;
         for i=1:N
            for j=i+1:N
                index = index+1;
                j_matrices(index,r) = j_matrix(i,j);
            end
        end
    end
% get max across columns
    [M,I] = max(j_matrices);
    histogram(I);
    ylabel('Number of runs');
    xlabel('i-j combination with max coupling parameter');
    print([figures_dir filesep 'max_J_histogram'], '-dpng');
    close all;
% plot heatmap of variance
    variances = var(j_matrices');
    mean_J = mean(j_matrices');
    variances_map = zeros([N N]);
    mean_J_map = zeros([N N]);
    index = 0;
    for i=1:N
        for j=i+1:N
            index = index+1;
            variances_map(i,j) = variances(index);
            mean_J_map(i,j) = mean_J(index);
        end
    end
    variances_map = variances_map' + variances_map;
    mean_J_map = mean_J_map' + mean_J_map;
    heatmap(variances_map);
    xlabel('Neurons');
    ylabel('Neurons');
    title('Variance of J parameters');
    print([figures_dir filesep 'variance_J_parameters'], '-dpng');
    close all;
% create figures of values per combo
    x = variances';
    y = mean_J';
    scatter(x, y);
    hold on;
    f = polyval(polyfit(x, y, 1),x);
    plot(x, f);
    hold off;
    xlabel('Variance (\sigma^2) of J parameters (100 runs of ACE)');
    ylabel('Mean of J parameters (100 runs of ACE)');
    print([figures_dir filesep 'mean_variance_J_parameters'], '-dpng');
    close all;
% create histograms of values per combo
    J_hist_dir = [figures_dir filesep 'J_parameter_histograms'];
    if (exist('J_hist_dir', 'dir') == 0) 
        mkdir(J_hist_dir);
    end
    index = 0;
    J_min = min(min(j_matrices))-.5;
    J_max = max(max(j_matrices))+.5;
    for i=1:N
        for j=i+1:N
            index = index+1;
            histogram(j_matrices(index,:));
            ylabel('Number of runs');
            xlabel('J parameter value');
            title(['Distribution of J Parameter: ' num2str(i) '&' num2str(j)]);
            xlim([J_min J_max]);
            print([J_hist_dir filesep 'distribution_J_parameters_' num2str(i) '_' num2str(j)], '-dpng');
            close all;
        end
    end
% generate correlations between J vectors heatmap
    corrs = corrcoef(j_matrices);
    heatmap(corrs);
    ylabel('Runs of ACE');
    xlabel('Runs of ACE');
    title('Pairwise Pearson Correlations (R) Between J Parameter Vectors Across 100 Runs of ACE');
    print([figures_dir filesep 'correlations_J_parameters'], '-dpng');
    close all;
% visualize clusters
    addpath(genpath('/Users/mschaff/Documents/MATLAB/chen_network_analysis/BCT_code'));
    [Ci Q] = modularity_und(corrs);
    [X,Y,indsort] = grid_communities(Ci);
    heatmap(indsort, indsort, corrs(indsort,indsort));
    ylabel('Runs of ACE');
    xlabel('Runs of ACE');
    title({'Pairwise Pearson Correlations (R) Between J Parameter Vectors Across 100 Runs of ACE','Clustered & Sorted'});
    print([figures_dir filesep 'correlations_J_parameters_clustered'], '-dpng');
    close all;
    
% JS Divergence between triad distributions
JSD_ind = zeros([num_runs 1]);
JSD_pairwise = zeros([num_runs 1]);
for r=1:num_runs
    freq_data = output_master(r).triads.freq_data;
    freq_indep = output_master(r).triads.freq_indep;
    freq_pairwise = output_master(r).triads.freq_pairwise;
    
    %INDEP JSD
        P = freq_data';
        Q = freq_indep';
        % throw out zero values 
        z = P ~= 0;
        P = P(z);
        Q = Q(z);
        new_z = Q ~=0;
        P = P(new_z);
        Q = Q(new_z);
        M = .5 * (P + Q);

        % half the KL divergence between P & M   
        % negative sum of P * log M/P 
        Dpm = sum(P .* log2(P./M));
        % half the KL divergence between Q & M 
        % negative sum of Q * log Q/M
        Dqm = sum(Q .* log2(Q./M));

        % total 
        JSD = .5 * Dpm + .5 * Dqm;
        JSD_ind(r) = JSD;
    
    %PAIRWISE JSD
        P = freq_data';
        Q = freq_pairwise';
        % throw out zero values 
        z = P ~= 0;
        P = P(z);
        Q = Q(z);
        M = .5 * (P + Q);

        % half the KL divergence between P & M   
        % negative sum of P * log M/P 
        Dpm = sum(P .* log2(P./M));
        % half the KL divergence between Q & M 
        % negative sum of Q * log Q/M
        Dqm = sum(Q .* log2(Q./M));

        % total 
        JSD = .5 * Dpm + .5 * Dqm;
        JSD_pairwise(r) = JSD;
end

figure();

% for obs_is
%convert to log scale
log_obs_is = log10(JSD_pairwise);
%bins from 10^-4 to 10^0
bins = linspace(-4, 0, 41)-0.05;
%normalized in the x log space to have an area of 1
histogram(log_obs_is, bins, 'normalization', 'pdf');

hold on;

% for obs_ind
log_obs_ind = log10(JSD_ind);
histogram(log_obs_ind, bins, 'normalization', 'pdf');

xlabel({'JS Divergence (bits) between Triad Probability Distributions',' Across 100 Runs of ACE'});
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
print([figures_dir filesep 'JS_hist_triads'], '-dpng');
close all;
hold off;

% regular histogram
bins = linspace(-2, 0, 21);
histogram(log_obs_is, bins)
hold on
histogram(log_obs_ind, bins)
hold off;
xlabel({'JS Divergence (bits) between Triad Probability Distributions',' Across 100 Runs of ACE'});
ylabel('# of Runs');
set(gca, 'FontSize', 14);
legend({'Pairwise', 'Independent'});
ax = gca;
lab = ax.XTick;
labels = {};
for b=1:numel(lab)
    labels{end+1} = ['10^' '{' num2str(lab(b)) '}'];
end 
set(gca, 'XTickLabel', labels);
print([figures_dir filesep 'JS_hist_triads_nonnormalized'], '-dpng');
close all;