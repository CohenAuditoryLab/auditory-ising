function JSD = calculateJSD(freq_data, freq_test)        
        P = freq_data;
        Q = freq_test;
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
end