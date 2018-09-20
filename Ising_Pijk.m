function Ising_Pijk(corr_model, corr_exp, train_corr, train_exp_corr, savepath)

%% Produce plot for 3rd order interactions.

N = size(corr_exp,2);
exp3 = zeros(N,N,N);
mod3 = zeros(N,N,N);

for i = 1:N
    for j = 1:N
        for k = 1:N
            %compute third order correlation
            num = corr_model(i,k)^2 + corr_model(j,k)^2 - 2 * corr_model(i,k)*corr_model(j,k)*corr_model(i,j);
            denom = 1 - corr_model(i,j)^2;
            mod3(i,j,k) = sqrt(num/denom);
            num = corr_exp(i,k)^2 + corr_exp(j,k)^2 - 2 * corr_exp(i,k)*corr_exp(j,k)*corr_exp(i,j);
            denom = 1 - corr_exp(i,j)^2;
            exp3(i,j,k) = sqrt(num/denom);
        end 
    end 
end 

exp3 = (reshape(exp3, [1, numel(exp3)]));
mod3 = (reshape(mod3, [1, numel(mod3)]));

texp3 = zeros(N,N,N);
tmod3 = zeros(N,N,N);

for i = 1:N
    for j = 1:N
        for k = 1:N
            %compute third order correlation
            num = train_corr(i,k)^2 + train_corr(j,k)^2 - 2 * train_corr(i,k)*train_corr(j,k)*train_corr(i,j);
            denom = 1 - train_corr(i,j)^2;
            tmod3(i,j,k) = sqrt(num/denom);
            num = train_exp_corr(i,k)^2 + train_exp_corr(j,k)^2 - 2 * train_exp_corr(i,k)*train_exp_corr(j,k)*train_exp_corr(i,j);
            denom = 1 - train_exp_corr(i,j)^2;
            texp3(i,j,k) = sqrt(num/denom);
        end 
    end 
end 

texp3 = (reshape(exp3, [1, numel(exp3)]));
tmod3 = (reshape(mod3, [1, numel(mod3)]));

figure();
test = plot(exp3, mod3, 'sr', 'MarkerSize', 10);
hold on;
lin = linspace(min(min(exp3),min(mod3)),max(max(exp3),max(mod3)),101);
plot(lin, lin, 'k', 'LineWidth', 1.5);
train = plot(texp3, tmod3, '*b', 'MarkerSize', 10);
set(gca, 'FontSize', 10);
xlabel('Mean Experimental Triplet Correlations');
ylabel('Mean Predicted Triplet Correlations');
title('Predicted vs. Empirical Mean Triplet Correlations');
legend([train, test], {'Train', 'Test'}, 'Location', 'Southeast');
print([savepath filesep 'triplet_correlations'], '-dpng');
end

