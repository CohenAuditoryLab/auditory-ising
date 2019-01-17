% FIRST - copy Eve & Matt .j files to /Users/mschaff/Documents/REPOS/QEE/j_files
% SECOND - change values
    
    %variables 
        % data bird path
            data_bird_path = '/Users/mschaff/Documents/DISSERTATION/Ising/data/ACE/Eve_birds/data_allBirds_binary_2010M6.txt';
        % MC algorithm path
            mc_algorithm_path = '/Users/mschaff/Documents/REPOS/QEE'; %precompiled
        % triad output path
            triad_output_dir = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/10152018/triads';
    
        % create output directories for MC algorithm
        if (exist([mc_algorithm_path '/output'], 'dir') == 0)
            mkdir([mc_algorithm_path '/output']);
        end
        if (exist([mc_algorithm_path '/output/indep'], 'dir') == 0)
            mkdir([mc_algorithm_path '/output/indep']);
        end
        if (exist([mc_algorithm_path '/output/eve'], 'dir') == 0)
            mkdir([mc_algorithm_path '/output/eve']);
        end
        if (exist([mc_algorithm_path '/output/matt'], 'dir') == 0)
            mkdir([mc_algorithm_path '/output/matt']);
        end
% independent model
    % get indep model .j file of birds
    data_bird = importdata(data_bird_path);
    data_bird(data_bird > 1) = 1;
    h_i =log(mean(data_bird)./(1-mean(data_bird)));
    h_i = h_i';
    fid = fopen([mc_algorithm_path '/j_files' filesep 'indep_bird.j'], 'wt');
    fprintf(fid,'%1g\n',h_i);
    N = numel(h_i);
    num_j = (N*(N-1))/2;
    J_ij = zeros([num_j 1]);
    fprintf(fid,'%1g\n',J_ij);
    fclose(fid);
% run MC algorithm
    cd '/Users/mschaff/Documents/REPOS/QEE';
    disp('Running MC algorithm to generate simulated data');
    system('./qee.out -i j_files/indep_bird -o output/indep/indep-output -p2');
    system('./qee.out -i j_files/eve-out -o output/eve/eve-output -p2');
    system('./qee.out -i j_files/matt-out -o output/matt/matt-output -p2');
% load data
    disp('Loading simulated data.');
    sim_data_indep = importdata([mc_algorithm_path '/output/indep/indep-output--1.dat']);
    sim_data_eve = importdata([mc_algorithm_path '/output/eve/eve-output--1.dat']);
    sim_data_matt = importdata([mc_algorithm_path '/output/matt/matt-output--1.dat']);
    disp('Data loaded.');
% invert numbers
    sim_data_eve = sim_data_eve*-1+1;
    sim_data_matt = sim_data_matt*-1+1;
    sim_data_indep = sim_data_indep*-1+1;
% get possible triad patterns
    num_birds = size(data_bird,2);
    triad_patterns = nchoosek(1:num_birds,3);
    num_patterns = size(triad_patterns,1);
    triad_patterns_binary = zeros([num_patterns num_birds]);
    for i=1:num_patterns
        triad_patterns_binary(i,triad_patterns(i,:)) = 1;
    end
% measure frequencies over triad patterns
    
    % bird data
    disp('Counting triads over bird data');
    freq_data = count_triad_freq(data_bird, triad_patterns_binary, num_patterns);
    
    % stimulatd data for independent model
    disp('Counting triads over bird data simulated from independent model');
    freq_indep = count_triad_freq(sim_data_indep, triad_patterns_binary, num_patterns);
    
    % matt simulated data
    disp('Counting triads over bird data simulated from Matts .j file');
    freq_matt = count_triad_freq(sim_data_matt, triad_patterns_binary, num_patterns);
    
    % eve simulated data
    disp('Counting triads over bird data simulated from Eves .j file');
    freq_eve = count_triad_freq(sim_data_eve, triad_patterns_binary, num_patterns);
    
    % save triad frequencies
    save([triad_output_dir 'triad_frequencies.mat'], 'freq_data', 'freq_indep', 'freq_eve', 'freq_matt');
    
    % plot triads
    figure();
    
    l2 = loglog(freq_data, freq_eve, '.b', 'MarkerSize', 15);
    hold on;
    l3 = loglog(freq_data, freq_matt, '.r', 'MarkerSize', 15);
    l1 = loglog(freq_data, freq_indep, '.c', 'MarkerSize', 15);

    
    set(gca, 'FontSize', 14);
    title('Triad Frequencies');
    xlabel('Observed Frequencies');
    ylabel('Predicted Frequencies');
    x1 = xlim;
    lin = linspace(x1(1), x1(2), 100);
    plot(lin, lin, 'k', 'Linewidth', .75);
    legend([l1 l2 l3], 'Independent', 'Eve Pairwise', 'Matt Pairwise', 'Location', 'SouthEast');
    hold off;