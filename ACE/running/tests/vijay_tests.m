% FILE - vija_tests
% 10/11/2018
% Purpose - to run tests on Ising model results that Vijay B. proposed



%% compare J_ij and h_i between my ACE & Eve's ACE
        core_dir = ['..' filesep '..' filesep '..' filesep '..' filesep]; %get to core directory
    % numbirds
        numbirds = 19;
    % load Eve's .j file parameters
        parameters = importdata([core_dir '/data/ACE/Eve_birds/data-out.j']);
        h = parameters(1:numbirds);
        J = parameters(numbirds+1:end);
    % load my .j file parameters
        parameters_matt = importdata([core_dir '/output/ACE_local/20181010_all/201801010_Birds_nosplit/ACEinput-out.j']);
        h_matt = parameters_matt(1:numbirds);
        J_matt = parameters_matt(numbirds+1:end);
    % load error threshold for h & J
        sce = importdata([core_dir '/output/ACE_local/20181010_all/201801010_Birds_nosplit/ACEinput-out.sce']);
        h_error = sce(end,2);
        J_error = sce(end,2);
    % output % of hs that are off by more than the error
        disp('---- Comparing ACE output betwen Eve & Matt ----');
        a = sum(abs(h-h_matt) > h_error);
        disp([num2str(a) ' out of ' num2str(numbirds) ' h_i off by more than the .sce error' ]);
    % output % of Js that are off by more than the error
        % get Js that are nonzero
        J_nonzero = sum(J ~= 0);
        J_nonzero_matt = sum(J_matt ~= 0);
        
        disp(['Nonzero Js: (Eve) ' num2str(J_nonzero) ', (Matt) ' num2str(J_nonzero_matt)]);
        disp(['Positive Js: (Eve) ' num2str(sum(J > 0)) ', (Matt) ' num2str(sum(J_matt > 0))]);
        disp(['Negative Js: (Eve) ' num2str(sum(J < 0)) ', (Matt) ' num2str(sum(J_matt < 0))]);
%% measure how sparse J are after mu=1/bins
    % already ran this
        parameters = importdata([core_dir '/output/ACE_local/20181010_all/201801010_DOMO/chunk_1__10000/ACEinput-out.j']);
        numneurons = 20;
        J = parameters(numneurons+1:end);
        disp('---- Sparsity of J: mu=1/bins ----');
        disp(['Nonzero Js: ' num2str(sum(J ~=0)) '/' num2str(numel(J))]);
        disp(['Positive Js: ' num2str(sum(J >0)) '/' num2str(numel(J))]);
        disp(['Negative Js: ' num2str(sum(J <0)) '/' num2str(numel(J))]);

%% measure how sparse J are after mu=1

%% measure how sparse J are after mu=0