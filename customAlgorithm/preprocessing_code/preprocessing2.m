function preprocessing2(neuron_low, neuron_high)

% get neurons of interest
load FnTNdata_A1.mat;
Ids = neuron_low:neuron_high;
AudNeurons = [];

% get all the auditory neurons
load A1_AuditoryNeurons.mat;

for i = 1:numel(Ids)
    if ismember(Ids(i), Aud)
        AudNeurons(end+1) = Ids(i);
    end
end 

%% 
% for each neuron, want to make a structure that includes vectors of TNR, 
% monkey response, stim_on, spikes centered around stim_on (negative
% before, positive after, 0 at) 

trialIds = dataC.codes.data(:, 11);

% for every neuron
for k = 1:numel(AudNeurons)
    % get neuron ID 
    CohenNeurons(k).ID = AudNeurons(k);
    % get indices of trial info for neuron
    inds = find(trialIds == AudNeurons(k));
    % for each trial
    for m = 1:length(inds)
        % get TNR
        CohenNeurons(k).trials(m).TNR = dataC.codes.data(inds(m), 9);
        % get monkey response 
        CohenNeurons(k).trials(m).monkey_response = dataC.codes.data(inds(m), 8);
        % get stimulus onset time 
        CohenNeurons(k).trials(m).stim_on = dataC.codes.data(inds(m), 4);
        % center spikes times around stimOn time 
        spk_time = dataC.spikes{inds(m), 2};
        spk_time = (spk_time - CohenNeurons(k).trials(m).stim_on) * 1000;
        CohenNeurons(k).trials(m).spike_times = spk_time;
    end 
end 

% then go to spike_train_processing
save('CohenNeurons.mat', 'CohenNeurons');

end
