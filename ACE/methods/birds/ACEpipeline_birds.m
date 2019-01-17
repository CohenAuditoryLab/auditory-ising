function ACEpipeline_birds(data_path, output_dir, run_custom, ACE_path, split)
% ACEpipeline - runs ACE and generates result files & figures
    % input variables:
        % data_path 
            % path to *.mat file with a variable g 
            % g - (2xNumber of spikes), 
                % column 1 - neuron ID 
                % column 2 - spike times
        % output_dir
            % (string) directory where output should be saved
        % run_custom
            % (boolean) whether to also run custom Ising algorithm
        % ACE_path
            % (string) where ACE is
        % split
            % (boolean) whether to split data

  %% LOGIC
    % add all code to path
        addpath(genpath(fileparts(fileparts(fileparts(mfilename('fullpath'))))));
    % generate ACE input files, with OR WITHOUT a training + test split
        if exist('split', 'var') == 0
             split = 1;
        end
        if (split)
            generateACEinput_birds(data_path, output_dir);  
        else
            generateACEinput_birds_nosplit(data_path, output_dir);
        end
    % run ACE & learning algorithm on the *.p file
        runACEonCohenData(output_dir, ACE_path);     
    % extract h & J parameters from *.j file & generate figures
        plotACEresult(output_dir,1);
    % if custom_algorithm should be run, run it
        if (run_custom) 
            runPlotCustomAlgorithm(output_dir);
        end
end