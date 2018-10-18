function probability_of_triads2(data_path, j_file_path, mc_algorithm_path, triad_output_dir, bird, test_logical_path, strict)
    % Function: probability_of_triads2 - calculates probability of triads
    % between experimental binary data and simulated binary data based on
    % Ising models, with parameters in .j file
    
        %variables 
            % timestamp
                time = datestr(now,'HH_MM_SS.FFF');
                if (exist('bird', 'var') == 0)
                   bird = true;
                end
                if (exist('strict', 'var') == 0)
                   strict = false;
                end
        % directories
            % create output directories for MC algorithm
            if (exist([mc_algorithm_path '/output'], 'dir') == 0)
                mkdir([mc_algorithm_path '/output']);
            end
            if (exist([mc_algorithm_path '/j_files'], 'dir') == 0)
                mkdir([mc_algorithm_path '/j_files']);
            end
            % mc_jfiles
            mc_j_files = [mc_algorithm_path '/j_files/' time];
            if (exist(mc_j_files, 'dir') == 0)
                mkdir(mc_j_files);
            end
            % mc_output
            mc_output = [mc_algorithm_path '/output/' time];
            if (exist(mc_output, 'dir') == 0)
                mkdir(mc_output);
            end
            if (exist([mc_output '/indep'], 'dir') == 0)
                mkdir([mc_output '/indep']);
            end
            if (exist([mc_output '/pairwise'], 'dir') == 0)
                mkdir([mc_output '/pairwise']);
            end
            if (exist(triad_output_dir, 'dir') == 0)
                mkdir(triad_output_dir);
            end
    % copy & paste the pairwise .j file
        copyfile(j_file_path, mc_j_files);
        [~, j_name,~] = fileparts(j_file_path);
        new_pairwise_j_path = [mc_j_files filesep j_name '.j'];
    % independent model -- get indep model .j file of elements
        if (bird)
            data = importdata(data_path);
        else
            data = load(data_path);
            data = cell2mat(data.neuron_trains);
            data = data';
            data(data > 0) = 1;
        end
        data(data > 1) = 1;
        data(data < 1) = 0;
        % now handle test_logical
        if exist('test_logical_path', 'var') == 1
            load(test_logical_path);
            train_data = data(~test_logical,:);
            h_i =log(mean(train_data)./(1-mean(train_data)));
            data = data(test_logical,:);
        else
            h_i =log(mean(data)./(1-mean(data)));
        end 
        h_i = h_i';
        fid = fopen([mc_j_files filesep 'indep.j'], 'wt');
        fprintf(fid,'%1g\n',h_i);
        N = numel(h_i);
        num_j = (N*(N-1))/2;
        J_ij = zeros([num_j 1]);
        fprintf(fid,'%1g\n',J_ij);
        fclose(fid);
    % run MC algorithm
        current_path = pwd;
        cd(mc_algorithm_path);
        disp('Running MC algorithm to generate simulated data on independent model');
        system(['./qee.out -i j_files/' time '/indep -o output/' time '/indep/indep-output -p2']);
        disp('Running MC algorithm to generate simulated data on pairwise model');
        system(['./qee.out -i j_files/' time '/' j_name ' -o output/' time '/pairwise/pairwise-output -p2']);
        cd(current_path);
    % load data
        disp('Loading simulated data.');
        sim_data_indep = importdata([mc_output '/indep/indep-output--1.dat']);
        sim_data_pairwise = importdata([mc_output '/pairwise/pairwise-output--1.dat']);
        disp('Data loaded.');
    % invert numbers
        sim_data_pairwise = sim_data_pairwise*-1+1;
        sim_data_indep = sim_data_indep*-1+1;
    % get possible triad patterns
        num_elements = size(data,2);
        triad_patterns = nchoosek(1:num_elements,3);
        num_patterns = size(triad_patterns,1);
        triad_patterns_binary = zeros([num_patterns num_elements]);
        for i=1:num_patterns
            triad_patterns_binary(i,triad_patterns(i,:)) = 1;
        end
    % measure frequencies over triad patterns

        % bird data
        disp('Counting triads over experimental data');
        freq_data = count_triad_freq(data, triad_patterns_binary, num_patterns);
        if (strict); freq_data_strict = count_triad_freq_strict(data, triad_patterns_binary, num_patterns); end

        % stimulatd data for independent model
        disp('Counting triads over data simulated from independent model');
        freq_indep = count_triad_freq(sim_data_indep, triad_patterns_binary, num_patterns);
        if (strict); freq_indep_strict = count_triad_freq_strict(sim_data_indep, triad_patterns_binary, num_patterns); end
        
        % matt simulated data
        disp('Counting triads over data simulated from pairwise model');
        freq_pairwise = count_triad_freq(sim_data_pairwise, triad_patterns_binary, num_patterns);
        if (strict); freq_pairwise_strict = count_triad_freq_strict(sim_data_pairwise, triad_patterns_binary, num_patterns); end
        % save triad frequencies
        save([triad_output_dir filesep 'triad_frequencies.mat'], 'freq_data', 'freq_indep', 'freq_pairwise');
        if (strict)
            save([triad_output_dir filesep 'triad_frequencies_strict.mat'], 'freq_data_strict', 'freq_indep_strict', 'freq_pairwise_strict'); 
        end
        
        % plot triads
        figure();
        l2 = loglog(freq_data, freq_pairwise, '.r', 'MarkerSize', 15);
        hold on;
        l1 = loglog(freq_data, freq_indep, '.c', 'MarkerSize', 15);
        set(gca, 'FontSize', 14);
        title('Triad Frequencies');
        xlabel('Observed Frequencies');
        ylabel('Predicted Frequencies');
        x1 = xlim;
        lin = linspace(x1(1), x1(2), 100);
        plot(lin, lin, 'k', 'Linewidth', .75);
        legend([l1 l2], 'Independent', 'Pairwise', 'Location', 'SouthEast');
        hold off;
        print([triad_output_dir filesep 'triad_frequencies'], '-dpng');
        if (strict)
            figure();
            l2 = loglog(freq_data_strict, freq_pairwise_strict, '.r', 'MarkerSize', 15);
            hold on;
            l1 = loglog(freq_data_strict, freq_indep_strict, '.c', 'MarkerSize', 15);
            set(gca, 'FontSize', 14);
            title('Triad Frequencies - Strict');
            xlabel('Observed Frequencies');
            ylabel('Predicted Frequencies');
            x1 = xlim;
            lin = linspace(x1(1), x1(2), 100);
            plot(lin, lin, 'k', 'Linewidth', .75);
            legend([l1 l2], 'Independent', 'Pairwise', 'Location', 'SouthEast');
            hold off;
            print([triad_output_dir filesep 'triad_frequencies_strict'], '-dpng');
           
        end
        close all;
     % move mc output & j files
        movefile(mc_output, [triad_output_dir filesep 'mc_output']);
        movefile(mc_j_files, [triad_output_dir filesep 'j_files']);
end