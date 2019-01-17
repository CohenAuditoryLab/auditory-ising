function analysis_output = analyzeTestParameter(output_path)
    % set default data
    if (exist('output_path', 'var') ==0) 
        output_path = '/Users/mschaff/Documents/DISSERTATION/Ising/output/ACE_local/20181022/20180807_Ripple2_d01_Jparam_test/testParameterEffectOnACE_output.mat';    
    end
    % load data
    disp('Loading data.');
    load(output_path);
    disp('Data loaded.');
    % initialize vars
    analysis_output = [];
    % loop through output
   pb = CmdLineProgressBar(['Computing JS divergence across '  num2str(numel(output_master)) ' combinations: ']); 
   count = 0; 
   for r=1:numel(output_master)
        pb.print(r,numel(output_master));
        % ignore element if i and j are equal
        if (output_master(r).i == output_master(r).j)
            continue;
        elseif (~isempty(analysis_output))
            past = [[analysis_output.i]; [analysis_output.j]]';
            if (ismember([output_master(r).j output_master(r).i], past, 'rows'))
                continue;
            end
        end
        count = count+1;
        analysis = struct;
        analysis.i = output_master(r).i; analysis.j = output_master(r).j;
       
        %% get JS divergence between observed and pairwise
        P = output_master(r).observed';
        Q = output_master(r).ising';
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
        analysis.JSD_pairwise = JSD;
        
        %% get JS divergence between observed and independent
        P = output_master(r).observed';
        Q = output_master(r).ind';
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
        analysis.JSD_indep = JSD;
        
        %% get mean-squared error between observed and pairwise
        P = output_master(r).observed';
        Q = output_master(r).ising';
        analysis.error_pairwise = mean((P-Q).^2);
        
        %% get mean-squared error between observed and independent
        P = output_master(r).observed';
        Q = output_master(r).ind';
        analysis.error_indep = mean((P-Q).^2);
        analysis_output = [analysis_output; analysis];
    end
end