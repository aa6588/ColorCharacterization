function [participant] = ChromAdapt_Flat_main
% This function represents the starting point for entering into the
% Chromatic Adaptation/Color Constancy in VR Experiment 
  
%% Participant Configuration

% define path to participant folder
addpath(genpath('C:\Users\orange\Documents\GitHub\ColorCharacterization\utils\'))
addpath(genpath('C:\Users\orange\Documents\GitHub\MCSL-Tools\Convert\'))

% A initialize participant
participant = struct();
% Determine new participant ID number
prompt = "Participant ID? ";
pID = input(prompt);
participant.ID = pID;
%VR or Flat 
mode = 'Flat';
participant.mode = mode;
first = input("First experiment? "); %1 if yes 0 if no
participant.first = first;
paths.participant  = append('C:\Users\orange\Documents\GitHub\ColorCharacterization\src\Participants\',mode,'\');

%% Run the Experiment Session
%
% Call the main experiment 
participant = ChromAdapt_Flat_exp(participant,paths);
%Save the participant
save([paths.participant sprintf('Participant_%02g.mat',participant.ID)],'participant');
%
end     