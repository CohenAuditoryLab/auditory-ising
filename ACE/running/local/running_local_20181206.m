% 12/06/2018

% PURPOSE OF THIS FILE: To run today's code; output figures for Yale grant

%% set up basics

    core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
    addpath(genpath(core_dir)); 
    base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181206']; 
    old_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181025'];
    if (exist(base_output, 'dir') == 0)
        mkdir(base_output);
        copyfile(old_output, base_output);
        ACE_output_dir = [base_output filesep '20180807_Ripple2_d01_60_40'];
        mkdir([ACE_output_dir filesep 'figures_foryale']);
        
    end
   
    
    % create output directory
    
    
%% codeword figure
     
    load([ACE_output_dir filesep 'figures' filesep 'pattern_freqs_all.mat']);
    figure();
    l1 = loglog(observed, ind, '.c', 'MarkerSize', 15);
    hold on;
    l2 = loglog(observed, ising, '.m', 'MarkerSize', 15);
    set(gca, 'FontSize', 14);
    x1 = xlim;
    lin = linspace(x1(1), x1(2), 100);
    set(gca,'fontsize',20);
    plot(lin, lin, 'k', 'Linewidth', .75);
    lgd=legend([l2 l1], 'Pairwise', 'Independent', 'Location', 'SouthEast');
    lgd.FontSize = 30;
    print([ACE_output_dir filesep 'figures_foryale' filesep 'whole_pattern_frequencies_all.svg'], '-dsvg');
    print([ACE_output_dir filesep 'figures_foryale' filesep 'whole_pattern_frequencies_all.pdf'], '-dpdf');
    close all;
    
%% triads
    load([ACE_output_dir filesep 'triads' filesep 'triad_frequencies.mat']);
    figure();
    l1 = loglog(freq_data, freq_pairwise, '.m', 'MarkerSize', 15);
    hold on;
    l2 = loglog(freq_data, freq_indep, '.c', 'MarkerSize', 15);
    set(gca, 'FontSize', 20);
    x1 = xlim;
    lin = linspace(x1(1), x1(2), 100);
    plot(lin, lin, 'k', 'Linewidth', .75);
    set(gca,'fontsize',20);
    lgd=legend([l1 l2], 'Pairwise', 'Independent', 'Location', 'SouthEast');
    lgd.FontSize = 30;
    hold off;
    print([ACE_output_dir filesep 'figures_for_yale' filesep 'triads.svg'], '-dsvg');
    print([ACE_output_dir filesep 'figures_for_yale' filesep 'triads.pdf'], '-dpdf');
    close all;
    
%% J matrix
     
    load([ACE_output_dir filesep 'spikes_by_bin.mat']);
    N = size(spikes_by_bin, 1);
    [h, j_matrix] = extractFittedParameters(N,[ACE_output_dir filesep 'ACEinput-out.j']);
    figure;
    heatmap(j_matrix, 'FontSize', 16);
    % change colors
    max_j = max(max(j_matrix));
    min_j = min(min(j_matrix));
    mapsize = round(64/((2*max_j-(min_j+max_j))/(2*max_j)));
    colormap(map2(end-64:end,:));
    print([ACE_output_dir filesep 'figures_foryale' filesep 'J_ij.svg'], '-dsvg');
    print([ACE_output_dir filesep 'figures_foryale' filesep 'J_ij.pdf'], '-dpdf');