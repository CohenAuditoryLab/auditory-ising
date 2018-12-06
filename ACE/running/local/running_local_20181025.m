% 10/23/2018

% PURPOSE OF THIS FILE: To run today's code

    % try to run ACE on full ripple dataset
        
        core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
        addpath(genpath(core_dir)); 
        base_output = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181025']; 
        mkdir(base_output);
  
    % output better figures for core dataset
    
        old_ACE_output_dir = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181019' filesep '20180807_Ripple2_d01_60_40'];
        ACE_output_dir = [base_output filesep '20180807_Ripple2_d01_60_40'];
        mkdir(ACE_output_dir);
        copyfile(old_ACE_output_dir, ACE_output_dir);
        plotACEresult(ACE_output_dir, 1,1);
        
    % model parameters reliable over many fits
        old_output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181021/20180807_Ripple2_d01_60_40_firsthalf';
        load([old_output_dir filesep 'multipleRunACE_output.mat']);
        output_dir = [base_output filesep 'many_runs'];
        mkdir(output_dir);
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
        corrs = corrcoef(j_matrices);
        h = heatmap(corrs, 'FontSize', 40);
        h.XDisplayLabels = strings([100 1]);
        h.YDisplayLabels = strings([100 1]);
        pos=get(gca,'position');  % retrieve the current values
        pos(3)=0.9*pos(3);        % try reducing width 10%
        set(gca,'position',pos); 
        print([output_dir filesep 'many_run_correlations.svg'], '-dsvg');
        print([output_dir filesep 'many_run_correlations.png'], '-dpng');
        close all;
        %% create histograms of values per combo
        J_hist_dir = [output_dir filesep 'J_parameter_histograms'];
        if (exist('J_hist_dir', 'dir') == 0) 
            mkdir(J_hist_dir);
        end
        figure();
        J_min = min(min(j_matrices))-.5;
        J_max = max(max(j_matrices))+.5;
        h = histogram(j_matrices(21,:), 'FaceColor', [0 0 0]);
        h.FaceAlpha= 1;
        hold on;
        histogram(j_matrices(80,:), 'FaceColor', 'white', 'LineWidth', 2);
        hold off;
        lgd=legend({'J(2,7)', 'J(6,16)'});
        lgd.FontSize = 40;
        xlim([J_min J_max]);
        set(gca,'fontsize',30);
        print([J_hist_dir filesep 'J_param_comparison.svg'], '-dsvg');
        close all;
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
        lgd=legend([l1 l2], 'Independent', 'Pairwise', 'Location', 'SouthEast');
        lgd.FontSize = 30;
        print([ACE_output_dir filesep 'figures' filesep 'whole_pattern_frequencies_all.svg'], '-dsvg');
        close all;
        
    %% JS Divergence figure
        load([ACE_output_dir filesep 'figures' filesep 'JS_patterns.mat']);
        figure();
        % for obs_is
        %convert to log scale
        log_obs_is = log10(obs_is);
        %bins from 10^-4 to 10^0
        bins = linspace(-4, 0, 21)-0.05;
        %normalized in the x log space to have an area of 1
       % histogram(log_obs_is, bins, 'normalization', 'pdf');
        h = histogram(log_obs_is, 'FaceColor', 'm');
        h.FaceAlpha= .7;
        hold on;

        % for obs_ind
        log_obs_ind = log10(obs_ind);
      %  histogram(log_obs_ind, bins, 'normalization', 'pdf');
        h = histogram(log_obs_ind, 'FaceColor', 'c');
        h.FaceAlpha= .7;
        set(gca, 'FontSize', 20);
        lgd=legend({'Pairwise', 'Independent'});
        lgd.FontSize = 30;
        ax = gca;
        lab = ax.XTick;
        labels = {};
        for b=1:numel(lab)
            labels{end+1} = ['10^' '{' num2str(lab(b)) '}'];
        end 

        set(gca, 'XTickLabel', labels);
        print([ACE_output_dir filesep 'figures' filesep 'JS_hist_better.svg'], '-dsvg');
        close all;
        
     %% 2ND DATASET codeword figure
        old_ACE_output_dir = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181023' filesep '20180917_Ripple_d01_70_30'];
        ACE_output_dir = [base_output filesep '20180917_Ripple_d01_70_30'];
        
        if (exist('ACE_output_dir', 'dir') == 0) 
            mkdir(ACE_output_dir);
            copyfile(old_ACE_output_dir, ACE_output_dir);
        end
        load([ACE_output_dir filesep 'figures' filesep 'pattern_freqs_all.mat']);
        figure();
        l1 = loglog(observed, ind, '.c', 'MarkerSize', 15);
        hold on;
        l2 = loglog(observed, ising, '.m', 'MarkerSize', 15);
        set(gca, 'FontSize', 20);
        x1 = xlim;
        lin = linspace(x1(1), x1(2), 100);
        set(gca,'fontsize',20);
        plot(lin, lin, 'k', 'Linewidth', .75);
        lgd=legend([l1 l2], 'Independent', 'Pairwise', 'Location', 'SouthEast');
        lgd.FontSize = 30;
        print([ACE_output_dir filesep 'figures' filesep 'whole_pattern_frequencies_all.svg'], '-dsvg');
        close all;
        
    %% 2ND DATASET JS Divergence figure
        
        load([ACE_output_dir filesep 'figures' filesep 'JS_patterns.mat']);
        figure();
        % for obs_is
        %convert to log scale
        log_obs_is = log10(obs_is);
        %bins from 10^-4 to 10^0
        bins = linspace(-4, 0, 21)-0.05;
        %normalized in the x log space to have an area of 1
       % histogram(log_obs_is, bins, 'normalization', 'pdf');
        h = histogram(log_obs_is, 'FaceColor', 'm');
        h.FaceAlpha= .7;
        hold on;

        % for obs_ind
        log_obs_ind = log10(obs_ind);
      %  histogram(log_obs_ind, bins, 'normalization', 'pdf');
        h = histogram(log_obs_ind, 'FaceColor', 'c');
        h.FaceAlpha= .7;
        set(gca, 'FontSize', 20);
        lgd=legend({'Pairwise', 'Independent'});
        lgd.FontSize = 30;
        ax = gca;
        lab = ax.XTick;
        labels = {};
        for b=1:numel(lab)
            labels{end+1} = ['10^' '{' num2str(lab(b)) '}'];
        end 
        ylim([0 70]);
        set(gca, 'XTickLabel', labels);
        print([ACE_output_dir filesep 'figures' filesep 'JS_hist_better.svg'], '-dsvg');
        close all;
        
    %% triads
    output_dir = [base_output filesep '20180807_Ripple2_d01_60_40'];
    %setStandardTriadParams;
    %probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path, 1);
    load([output_dir filesep 'triads' filesep 'triad_frequencies.mat']);
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
    print([output_dir filesep 'figures' filesep 'triads_better.svg'], '-dsvg');
    close all;
    
    %% triads strict
    output_dir = [base_output filesep '20180807_Ripple2_d01_60_40'];
    load([output_dir filesep 'triads' filesep 'triad_frequencies_strict.mat']);
    g = figure();
    l1 = loglog(freq_data_strict, freq_pairwise_strict, '.m', 'MarkerSize', 15);
    hold on;
    l2 = loglog(freq_data_strict, freq_indep_strict, '.c', 'MarkerSize', 15);
    set(gca, 'FontSize', 20);
    xlim([1e-4 .5e-3]);
    x1 = xlim;
    
    lin = linspace(x1(1), x1(2), 100);
    plot(lin, lin, 'k', 'Linewidth', .75);
    set(gca,'fontsize',20);
    lgd=legend([l1 l2], 'Pairwise', 'Independent', 'Location', 'NorthWest');
    lgd.FontSize = 30;
    hold off;
    print([output_dir filesep 'figures' filesep 'triads_strict.svg'], '-dsvg');
    close all;
    
    %% JS Divergence & MSE for each dataset
        datasets = [];
    % load probabilities in dataset 1 - 20180807_Ripple2_d01_60_40
        output_dir = '20180807_Ripple2_d01_60_40';
        data_path = [base_output filesep output_dir '/figures/pattern_freqs_all.mat'];
        probs = load(data_path);
    % compute JSD & MSE
        JSD_ind = calculateJSD(probs.observed', probs.ind');
        JSD_ising = calculateJSD(probs.observed', probs.ising');
        dataset = struct;
        dataset.name = output_dir; dataset.JSD_ind = JSD_ind; dataset.JSD_ising = JSD_ising;
        datasets = [datasets; dataset];
    % get differences
    
    
    
    % load probabilities in dataset 2 - 20180917_Ripple_d01_70_30
        output_dir = '20180917_Ripple_d01_70_30';
        data_path = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181023' filesep output_dir '/figures/pattern_freqs_all.mat'];
        probs = load(data_path);
    % compute JSD & MSE
        JSD_ind = calculateJSD(probs.observed', probs.ind');
        JSD_ising = calculateJSD(probs.observed', probs.ising');
        dataset = struct;
        dataset.name = output_dir; dataset.JSD_ind = JSD_ind; dataset.JSD_ising = JSD_ising;
        datasets = [datasets; dataset];
    % get differences
    
    
    
    
    
    % load probabilities in dataset 3 - 20180821_Ripple2_d01
        output_dir = '20180821_Ripple2_d01';
        data_path = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181023' filesep output_dir '/figures/pattern_freqs_all.mat'];
        probs = load(data_path);
    % compute JSD & MSE
        JSD_ind = calculateJSD(probs.observed', probs.ind');
        JSD_ising = calculateJSD(probs.observed', probs.ising');
        dataset = struct;
        dataset.name = output_dir; dataset.JSD_ind = JSD_ind; dataset.JSD_ising = JSD_ising;
        datasets = [datasets; dataset];
   
    % get differences
    
    % load probabilities in dataset 4
        output_dir = '20180820_Ripple2_d03';
        data_path = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181023' filesep output_dir '/figures/pattern_freqs_all.mat'];
        probs = load(data_path);
    % compute JSD & MSE
        JSD_ind = calculateJSD(probs.observed', probs.ind');
        JSD_ising = calculateJSD(probs.observed', probs.ising');
        dataset = struct;
        dataset.name = output_dir; dataset.JSD_ind = JSD_ind; dataset.JSD_ising = JSD_ising;
        datasets = [datasets; dataset];
        
        
    % get differences
    
        graph = bar([1 2 3 4],[datasets(1).JSD_ising/datasets(1).JSD_ising datasets(1).JSD_ind/datasets(1).JSD_ising; ...
            datasets(2).JSD_ising/datasets(2).JSD_ising datasets(2).JSD_ind/datasets(2).JSD_ising; ...
            datasets(3).JSD_ising/datasets(3).JSD_ising datasets(3).JSD_ind/datasets(3).JSD_ising; ...
            datasets(4).JSD_ising/datasets(4).JSD_ising datasets(4).JSD_ind/datasets(4).JSD_ising ...
            ]);
        set(gca,'fontsize',30);
        lgd=legend({'Pairwise', 'Independent'});
        lgd.FontSize = 30;
        xticklabels({'17','18','11','8'});
        graph(1).FaceColor = 'm';
        graph(2).FaceColor = 'c';
        
        output_dir = [base_output filesep 'datasets'];
        if (exist('datasets', 'dir') == 0) 
            mkdir(output_dir);
        end
        print([output_dir filesep 'datasets.svg'], '-dsvg');
        close all;
    %% JS Divergergence & MSE for each combination
    output_dir = [base_output filesep 'combo_comparisons'];
    if (exist('output_dir', 'dir') == 0) 
        mkdir(output_dir);
    end
    % load master output
    analysis_output = analyzeTestParameter;
    % loop through master output
    % calculate JSD in each loop
    % output figure
    
    g = histogram(log10([analysis_output.JSD_pairwise]), 'FaceColor', 'm', 'FaceAlpha', 1);
     hold on
    b  = bar(log10([.0262]), 70, 'FaceColor', 'c', 'EdgeColor', 'c');
    set(b, 'BarWidth', .0025);
    xlim([-1.9 -1.5]);
    set(gca,'fontsize',30);
    ax = gca;
    lab = ax.XTick;
    labels = {};
    for b=1:numel(lab)
        labels{end+1} = ['10^' '{' num2str(lab(b)) '}'];
    end 
    
    set(gca, 'XTickLabel', labels);
    lgd=legend('Pairwise', 'Independent', 'Location', 'SouthEast');
    lgd.FontSize = 30;
    hold off;
    
    % get the current tick labeks
    ticklabels = get(gca,'YTickLabel');
    % prepend a color for each tick label
    ticklabels_new = cell(size(ticklabels));
    for i = 1:length(ticklabels)
        ticklabels_new{i} = ['\color{magenta} ' ticklabels{i}];
    end
    % set the tick labels
    set(gca, 'YTickLabel', ticklabels_new);
    
    print([output_dir filesep 'combos_comparison.svg'], '-dsvg');
    close all;
    
     %% JS Divergence & MSE for each dataset - just dataset 1 & 2
        datasets = [];
    % load probabilities in dataset 1 - 20180807_Ripple2_d01_60_40
        output_dir = '20180807_Ripple2_d01_60_40';
        data_path = [base_output filesep output_dir '/figures/pattern_freqs_all.mat'];
        probs = load(data_path);
    % compute JSD & MSE
        JSD_ind = calculateJSD(probs.observed', probs.ind');
        JSD_ising = calculateJSD(probs.observed', probs.ising');
        dataset = struct;
        dataset.name = output_dir; dataset.JSD_ind = JSD_ind; dataset.JSD_ising = JSD_ising;
        datasets = [datasets; dataset];
    % get differences
    
    
    
    % load probabilities in dataset 2 - 20180917_Ripple_d01_70_30
        output_dir = '20180917_Ripple_d01_70_30';
        data_path = [core_dir filesep 'output' filesep 'ACE_local' filesep '20181023' filesep output_dir '/figures/pattern_freqs_all.mat'];
        probs = load(data_path);
    % compute JSD & MSE
        JSD_ind = calculateJSD(probs.observed', probs.ind');
        JSD_ising = calculateJSD(probs.observed', probs.ising');
        dataset = struct;
        dataset.name = output_dir; dataset.JSD_ind = JSD_ind; dataset.JSD_ising = JSD_ising;
        datasets = [datasets; dataset];
        
    % graph differences
            
        graph = bar([1 2],[datasets(1).JSD_ising/datasets(1).JSD_ising datasets(1).JSD_ind/datasets(1).JSD_ising; ...
            datasets(2).JSD_ising/datasets(2).JSD_ising datasets(2).JSD_ind/datasets(2).JSD_ising]);
        set(gca,'fontsize',30);
        lgd=legend({'Pairwise', 'Independent'});
        lgd.FontSize = 30;
        xticklabels({'17','18','11','8'});
        graph(1).FaceColor = 'm';
        graph(2).FaceColor = 'c';
        
        output_dir = [base_output filesep 'datasets'];
        if (exist('datasets', 'dir') == 0) 
            mkdir(output_dir);
        end
        print([output_dir filesep 'datasets_just1and2.svg'], '-dsvg');
        close all;
        
    %% - LAB: poster ? new figure 5; set correlations to Poisson 
    
        % copy & paste output
            old_output_dir = [base_output filesep '20180807_Ripple2_d01_60_40'];
            output_dir = [base_output filesep '20180807_Ripple2_d01_60_40_indep_cij'];
            if (exist('output_dir', 'dir') == 0) 
                mkdir(output_dir);
                copyfile(old_output_dir, output_dir);
            end
            rmdir([output_dir filesep 'figures'], 's');
            rmdir([output_dir filesep 'triads'], 's');
            delete([output_dir filesep '*.sce']);
            delete([output_dir filesep '*.j']);
        %rerun ACE w/ c_ij to Poisson
            setStandardACEParams;
            output_dir = [base_output filesep '20180807_Ripple2_d01_60_40_indep_cij'];
            edit_ACEinput_P_indep_cij(output_dir);
        % run ACE & learning algorithm on the *.p file
            runACEonCohenData(output_dir, ACE_path);     
        % extract h & J parameters from *.j file & generate figures
            plotACEresult(output_dir, 1, plot_all_points);
            
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
            xlim([1 17]);
            print([output_dir filesep 'figures' filesep 'h_parameters_corrsSetToPoisson.svg'], '-dsvg');
            close all;
        % figure 2 codewords
            load([output_dir filesep 'figures' filesep 'pattern_freqs_all.mat']);
            figure();
            l1 = loglog(observed, ind, '.c', 'MarkerSize', 15);
            hold on;
            l2 = loglog(observed, ising, '.m', 'MarkerSize', 15);
            set(gca, 'FontSize', 20);
            x1 = xlim;
            lin = linspace(x1(1), x1(2), 100);
            set(gca,'fontsize',30);
            plot(lin, lin, 'k', 'Linewidth', .75);
            lgd=legend([l1 l2], 'Independent', 'Pairwise', 'Location', 'SouthEast');
            lgd.FontSize = 40;
            print([output_dir filesep 'figures' filesep 'whole_pattern_frequencies_all_corrsSetToPoisson.svg'], '-dsvg');
            close all;
    %% - LAB: poster ? new figure 5; shift data effect
    