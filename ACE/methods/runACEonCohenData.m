function runACEonCohenData(output_dir, ACE_path)
    % runACEonCohenData - runs ACE algorithm on Cohen lab data
    
    % input variables:
        % output_dir
            % path to directory where *.p file & test_logical.mat are saved
        % ACE_path
            % path to ACE

    %% LOGIC
            
        % initialize variables
        if exist('ACE_path', 'var') == 0
             ACE_path = '/Users/mschaff/Documents/REPOS/ACE';
        end
        addpath(genpath(ACE_path));
        % load data
        chunks = dir(fullfile(output_dir, 'chunk*'));
        if (length(chunks) == 0)
            num_chunks = 1;
            no_chunks = true;
        else
            num_chunks = numel(chunks);
            no_chunks = false;
            disp('Data is chunked.');
        end
        for i =1:num_chunks
            if (~no_chunks)
                output_dir = [chunks(i).folder filesep chunks(i).name];
            end
            b = dir(fullfile(output_dir, '*.p'));
            [~,name,ext] = fileparts([b.folder filesep b.name]);
            % load test_logical and get size of training data
            load([output_dir filesep 'train_logical.mat']);
            num_bins = numel(find(train_logical == 1));
            % run ACE algorithm
            disp(['Running ACE algorithm on ' output_dir]);
            system([ ACE_path '/bin/ace -d ' output_dir ' -i ' name ' -o ' name '-out -b ' num2str(num_bins) ' -g2 ' num2str(1/num_bins)]);
            % run QLS learning on ACE result
            %disp(['Running ACE QLS learning algorithm on ' output_dir]);
            %system([ ACE_path '/bin/qls -d ' output_dir ' -i ' name '-out -o ' name '-out-learn -c ' name ' -g2 ' round(1/num_bins)]);
        end
    

end