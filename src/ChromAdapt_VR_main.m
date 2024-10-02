function [participant] = ChromAdapt_VR_main
% This function represents the starting point for entering into the
% Chromatic Adaptation/Color Constancy in VR Experiment 
  
%% Participant Configuration
% Adapted from 'Ambient_main.m' by Jaclyn Pytlarz
%
% set --action ('train','session')
%temptag = 'session';
%
% define path to participant folder
paths.participant  = 'C:\Users\orange\Documents\GitHub\ColorCharacterization\src\Participants\';
addpath(genpath('C:\Users\orange\Documents\GitHub\ColorCharacterization\utils\'))
addpath(genpath('C:\Users\orange\Documents\GitHub\MCSL-Tools\Convert\'))
% cd into the folde  r
cd(paths.participant); cd('..\');
% A dummy participant is defaultly created for initial testing
participant = [];
%
% Determine new pa rticipant ID number
lastParticipant = dir([paths.participant 'Participant_*.mat']);
if isempty(lastParticipant)
    pID = 1;
else
      tmp = lastParticipant(end).name;
    [~,name,~] = fileparts(tmp);
    tmp = strsplit(name,{'_'});
    pID = str2double(tmp{end})+1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    if isnan(pID)                                                                                                                                                                                                                      
        pID = 1;
    end
end
participant.ID = pID;
clear tmp name lastParticipant;
%
% Gather user data
% if strcmpi(temptag,'train') ~= 1
%     [f,participant]=uiGui_guide(participant,paths); waitfor(f);
%     save([paths.participant sprintf('Participant_%03g.mat',participant.ID)],'participant');
% end
%
%% Run the Experiment Session
%
% Call the main experiment 
participant = HK_2AFC_Exp_V2(participant,paths);
%Save the participant
save([paths.participant sprintf('Participant_%03g.mat',participant.ID)],'participant');
%
end     