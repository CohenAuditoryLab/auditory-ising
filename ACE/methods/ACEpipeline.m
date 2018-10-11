function ACEpipeline(data_path, output_dir, time_units, bin_size, use_chunks, run_custom, ACE_path, indep_c_ij)
% ACEpipeline - runs ACE and generates result files & figures
    % input variables:
        % data_path 
            % path to *.mat file with a variable g 
            % g - (2xNumber of spikes), 
                % column 1 - neuron ID 
                % column 2 - spike times
        % output_dir
            % (string) directory where output should be saved
        % time_units
            % (double) units in time of the data (e.g. 1e-3, which would correspond
            % to ms)
        % bin_size
            % (double) size of bin in seconds (e.g. 20e-3, or 20 ms bins)
        % use_chunks
            % (boolean) whether to chunk the data by 10,000 bin chunks
            % note - ACE seems to fail when you give it more than 10k bins
        % run_custom
            % (boolean) whether to also run custom Ising algorithm
        % ACE_path
            % (string) where ACE is
        % indep_c_ij
            % (boolean) whether c_ij should just be independent (for
            % testing)

  %% LOGIC
    % set up vars
        if exist('indep_c_ij', 'var') == 0
          indep_c_ij = false;
        end
    % add all code to path
        addpath(genpath(fileparts(fileparts(fileparts(mfilename('fullpath'))))));
    % generate ACE input files, with a training + test split
        generateACEinputSpikeTimes(data_path, time_units, bin_size, output_dir,use_chunks, indep_c_ij); 
    % run ACE & learning algorithm on the *.p file
        runACEonCohenData(output_dir, ACE_path);     
    % extract h & J parameters from *.j file & generate figures
        plotACEresult(output_dir, 1);
    % if custom_algorithm should be run, run it
        if (run_custom) 
            runPlotCustomAlgorithm(output_dir);
        end
end