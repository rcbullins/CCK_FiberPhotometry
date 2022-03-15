function [] = plotDeltaF(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER, samplingRate)
% PURPOSE
%     Preprocess calcium recording from CCK interneurons in dentate gyrus of
%     hippocampus. Load in raw data and save in mat structs for easy access
%     later.
%     4 conditions:
%        - baseline
%               WT vs AD model
%        - increase CCK activity (activated hM3D with CNO)
%               WT vs AD model
% INPUT
%   - Raw excel files with data
%       Each has time, 2 data channels, & 2 corresponding reference channels
%               TimeStamp
%               CH1-410 (all light being given)
%               CH1-470 (light from calcium)
%               CH2-410
%               CH2-470
%   - 20211206_3mon_baseline
%     20211207_3mon_CNO_1mgkg_40min > hM3d_DioGC > CCK_f6_827 > ... > Fluorescence
%                                            ... > CCKAD_f6_827 > ...

% OUTPUTS
%   - Calcium example traces for each session
% HISTORY
%   3.10.2022 Reagan Bullins
%% Set Paths
BASEPATH = 'C:\Users\rcbul\OneDrive - University of North Carolina at Chapel Hill\Song_Lab\';
CODE_REAGAN = [BASEPATH 'Code\'];
RAW_DATA = [BASEPATH 'Data\'];
ANALYZED_DATA= [BASEPATH 'Analyzed_Data\'];

addpath(genpath(CODE_REAGAN));
addpath(genpath(RAW_DATA));
addpath(genpath(ANALYZED_DATA));

SetGraphDefaults;
%%
for imonth = 1:length(MONTHS)
    thisMonth = MONTHS{imonth};
    % Loop through each condition
    for icondition = 1:length(EXPER_CONDITIONS)
        thisExperCondition = EXPER_CONDITIONS{icondition};
        thisDir = [RAW_DATA '\'];
        animalSessionsSearch = sprintf('*_%s_%s*',thisMonth,thisExperCondition);
        allAnimalFolders = dir(fullfile(thisDir, animalSessionsSearch));
        DATA_FOLDER = [allAnimalFolders.name '\'];
        
        % loop through each model
        for imodel = 1:length(MODELS)
            thisModel = MODELS{imodel};
            thisDir = [RAW_DATA DATA_FOLDER INDICATOR_FOLDER];
            % See how many sessions are in the folder for this condition and
            % model
            modelSearchFolders = sprintf('%s_*',thisModel);
            allModelFolders = dir(fullfile(thisDir, modelSearchFolders));
            % get all folder names
            SESSIONS = {allModelFolders.name};
            
            previousSession = '';
            for isession = 1:length(SESSIONS)
                thisSession = SESSIONS{isession};
                lengthModelName = length(thisModel);
                titleSession = thisSession(1:lengthModelName+7);
                if strcmp(titleSession, previousSession)
                    continue;
                end
                %  if left and right channels - combo time flag it for if
                %  statement
                recSplit = 0;
                if contains(thisSession, 'left')
                    recSplit = 1;
                    recLeft =1;
                elseif contains(thisSession, 'right')
                    recSplit = 1;
                    recLeft =0;
                end
                if ~recSplit % recordig left and right at same time
                    sessionDir = [thisDir thisSession '\'];
                    sessionFolder = dir(fullfile(sessionDir,'*_*'));
                    THIS_SESSION_DIR = [thisSession '\' sessionFolder.name '\'];
                    %% Load in excel sheets
                    % Identify excel sheet to load in
                    THIS_CA_DATA = [RAW_DATA DATA_FOLDER INDICATOR_FOLDER THIS_SESSION_DIR 'Fluorescence.csv'];
                    %% Get Data Struct
                    ca_data = getDataStruct(THIS_CA_DATA, samplingRate,'analyzeAll',1);
                    ca_data.chan1_time  = ca_data.time;
                    ca_data.chan2_time  = ca_data.time;
                else % recording left and right at different times
                    if recLeft
                        sessionDirLeft = [thisDir thisSession '\'];
                        sessionFolderLeft = dir(fullfile(sessionDirLeft,'*_*'));
                        THIS_SESSION_DIR_LEFT = [thisSession '\' sessionFolderLeft.name '\'];
                        % load in corresponding session for right side
                        sessionDirRight = [thisDir thisSession(1:end-4) 'right\'];
                        sessionFolderRight = dir(fullfile(sessionDirRight,'*_*'));
                        THIS_SESSION_DIR_RIGHT = [thisSession(1:end-4) 'right\' sessionFolderRight.name '\'];
                    else
                        sessionDirRight = [thisDir thisSession '\'];
                        sessionFolderRight = dir(fullfile(sessionDirRight,'*_*'));
                        THIS_SESSION_DIR_RIGHT = [thisSession '\' sessionFolderRight.name '\'];
                        % load in corresponding session for left side
                        sessionDirLeft = [thisDir thisSession(1:end-5) 'left\'];
                        sessionFolderLeft = dir(fullfile(sessionDirLeft,'*_*'));
                        THIS_SESSION_DIR_LEFT = [thisSession(1:end-5) 'left\' sessionFolderLeft.name '\'];
                    end
                    %% Load in excel sheets
                    % Identify excel sheet to load in
                    THIS_CA_DATA_RIGHT = [RAW_DATA DATA_FOLDER INDICATOR_FOLDER THIS_SESSION_DIR_RIGHT 'Fluorescence.csv'];
                    THIS_CA_DATA_LEFT = [RAW_DATA DATA_FOLDER INDICATOR_FOLDER THIS_SESSION_DIR_LEFT 'Fluorescence.csv'];
                    %% Get Data Struct
                    ca_data_left = getDataStruct(THIS_CA_DATA_LEFT, samplingRate,'recSide',"left",'analyzeAll',1);
                    ca_data_right = getDataStruct(THIS_CA_DATA_RIGHT,samplingRate,'recSide',"right",'analyzeAll',1);
                    %% Reconstruct struct
                    % left side channel 1
                    ca_data.chan1_time  = ca_data_left.time;
                    ca_data.chan1_ref   = ca_data_left.chan1_ref;
                    ca_data.chan1_gcamp = ca_data_left.chan1_gcamp;
                    ca_data.chan1_ratio = ca_data_left.chan1_ratio;
                    ca_data.chan1_dg    = ca_data_left.chan1_dg;
                    % right side channel 2
                    ca_data.chan2_time  = ca_data_right.time;
                    ca_data.chan2_ref   = ca_data_right.chan2_ref;
                    ca_data.chan2_gcamp = ca_data_right.chan2_gcamp;
                    ca_data.chan2_ratio = ca_data_right.chan2_ratio;
                    ca_data.chan2_dg    = ca_data_right.chan2_dg;
                    
                end
                %% Plot
                % Plot raw example trace for channel 1
                figure;
                sgtitle([thisMonth ': ' thisExperCondition ' & ' thisModel ' (' strrep(titleSession(lengthModelName+1:end),'_',' ') ')']);
   
                subplot(2,1,1);
                plot(ca_data.chan1_time,ca_data.chan1_dg);
                title('Channel 1: \Delta F/F');
                ylabel('\Delta F/F (%)');
                xlabel('Time (ms)');
                xlim([0 ca_data.chan1_time(end)]);
                box off;
                
                subplot(2,1,2);
                plot(ca_data.chan2_time,ca_data.chan2_dg);
                title('Channel 2: \Delta F/F');
                ylabel('\Delta F/F (%)');
                xlabel('Time (ms)');
                xlim([0 ca_data.chan2_time(end)]);
                box off;
                
                previousSession = titleSession;
            end %session
        end %model
    end %exper condition
end %month
end