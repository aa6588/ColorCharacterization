function [participant] = ChromAdapt_VR_main
% This function represents the starting point for entering into the
% Chromatic Adaptation/Color Constancy in VR Experiment 
  
%% Participant Configuration

% define path to participant folder
paths.participant  = 'C:\Users\orange\Documents\GitHub\ColorCharacterization\src\ParticipantsVR\';
addpath(genpath('C:\Users\orange\Documents\GitHub\ColorCharacterization\utils\'))
addpath(genpath('C:\Users\orange\Documents\GitHub\MCSL-Tools\Convert\'))
% cd into the folder
cd(paths.participant); 
% A initialize participant
participant = struct();
% Determine new participant ID number
prompt = "Participant ID? ";
pID = input(prompt);
participant.ID = pID;
%VR or Flat 
mode = input("VR or Flat? ", 's');
participant.mode = mode;

%% Run the Experiment Session
%
% Call the main experiment 
participant = ChromAdapt_VR_exp(participant,paths);
%Save the participant
save([paths.participant sprintf('Participant_%02g.mat',participant.ID)],'participant');
%
end     