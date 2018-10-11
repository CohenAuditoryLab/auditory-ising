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
        parameters = importdata([core_dir '/output/ACE_local/20181010_all/201801010_DOMO_fixedtrain/chunk_1__10000/ACEinput-out.j']);
        numneurons = 20;
        J = parameters(numneurons+1:end);
        disp('---- Sparsity of J: mu=1/bins ----');
        disp(['Nonzero Js: ' num2str(sum(J ~=0)) '/' num2str(numel(J))]);
        disp(['Positive Js: ' num2str(sum(J >0)) '/' num2str(numel(J))]);
        disp(['Negative Js: ' num2str(sum(J <0)) '/' num2str(numel(J))]);

%% measure how sparse J are after mu=1
    % base output
        base_output = [core_dir '/output/ACE_local/20181010_all'];
    % move 1st chunk & delete ACE output
        destination = [base_output filesep '201801010_DOMO_test_reg_1'];
        mkdir(destination);
        source = [base_output filesep '201801010_DOMO_fixedtrain' filesep 'chunk_1__10000'];
        copyfile(source, destination);
        if (exist([destination filesep 'figures'], 'dir')) 
            rmdir([destination filesep 'figures'], 's');
        end
        if (exist([destination filesep 'figures_custom'], 'dir')) 
            rmdir([destination filesep 'figures_custom'], 's');
        end
        file = dir(fullfile(destination, '*.j'));
        if (~isempty(file))
            delete([destination filesep file.name]);
        end
        file = dir(fullfile(destination, '*.sce'));
        if (~isempty(file))
            delete([destination filesep file.name]);
        end
    % run ACE w/ regularization of 1
        ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        regularization = '1e0';
        %runACEonCohenData(destination, ACE_path, regularization);
    %forgot to create the train_logical.mat file
        load([destination filesep 'test_logical.mat']);
        train_logical = ~test_logical;
        save([destination filesep 'train_logical.mat'], 'train_logical');
        runACEonCohenData(destination, ACE_path, regularization);
    % extract parameters & display results
        parameters = importdata([destination filesep 'ACEinput-out.j']);
        numneurons = 20;
        J = parameters(numneurons+1:end);
        disp('---- Sparsity of J: mu=1 ----');
        disp(['Nonzero Js: ' num2str(sum(J ~=0)) '/' num2str(numel(J))]);
        disp(['Positive Js: ' num2str(sum(J >0)) '/' num2str(numel(J))]);
        disp(['Negative Js: ' num2str(sum(J <0)) '/' num2str(numel(J))]);
%% measure how sparse J are after mu=0
    %move 1st chunk & delete ACE output
        destination = [base_output filesep '201801010_DOMO_test_reg_0'];
        mkdir(destination);
        source = [base_output filesep '201801010_DOMO_test_reg_1'];
        copyfile(source, destination);
        if (exist([destination filesep 'figures'], 'dir')) 
            rmdir([destination filesep 'figures'], 's');
        end
        if (exist([destination filesep 'figures_custom'], 'dir')) 
            rmdir([destination filesep 'figures_custom'], 's');
        end
        file = dir(fullfile(destination, '*.j'));
        if (~isempty(file))
            delete([destination filesep file.name]);
        end
        file = dir(fullfile(destination, '*.sce'));
        if (~isempty(file))
            delete([destination filesep file.name]);
        end
    % run ACE w/ regularization of 1
        ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        regularization = '0';
        runACEonCohenData(destination, ACE_path, regularization);
    % extract parameters & display results
        parameters = importdata([destination filesep 'ACEinput-out.j']);
        numneurons = 20;
        J = parameters(numneurons+1:end);
        disp('---- Sparsity of J: mu=0 ----');
        disp(['Nonzero Js: ' num2str(sum(J ~=0)) '/' num2str(numel(J))]);
        disp(['Positive Js: ' num2str(sum(J >0)) '/' num2str(numel(J))]);
        disp(['Negative Js: ' num2str(sum(J <0)) '/' num2str(numel(J))]);