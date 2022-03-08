function [] = Preprocessing_Script(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER, samplingRate)
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
%   - Calcium example traces for each session, reference, gcamp signal, and
%   deltaF
%   - mat files with data for each experimental session labeled as such:
%       baseline_CCK_sessionInfo.mat
%           this contains a ca_data struct for chan1 and chan2:
%                                  .time
%                                  .chan1_ref   (reference signal)
%                                  .chan1_gcamp (raw gcamp signal)
%                                  .chan1_ratio (gcamp to ref signal)
%                                  .chan1_dg    (deltaF/F)
% HISTORY
%   2.1.2022 Reagan Bullins
% TO DO
%   - if add in sessions, figure out better way to go through them - naming
%   and all, hard coded ish right now
%   - if add in GFAP (for astrocytes) will have to change the indicator folder
%   - currently assumes there is only one data file when you get to
%   CCK_animal number directory
%% Set Paths
BASEPATH = 'C:\Users\rcbul\OneDrive - University of North Carolina at Chapel Hill\Song_Lab\';
CODE_REAGAN = [BASEPATH 'Code\'];
RAW_DATA = [BASEPATH 'Data\'];
ANALYZED_DATA= [BASEPATH 'Analyzed_Data\'];
FIGURES = [BASEPATH 'Figures\'];

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
                    ca_data = getDataStruct(THIS_CA_DATA, samplingRate);
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
                    ca_data_left = getDataStruct(THIS_CA_DATA_LEFT, samplingRate,'recSide',"left");
                    ca_data_right = getDataStruct(THIS_CA_DATA_RIGHT,samplingRate,'recSide',"right");
                    %% Reconstruct struct
                    % left side channel 1
                    ca_data.time = ca_data_left.time;
                    ca_data.chan1_ref   = ca_data_left.chan1_ref;
                    ca_data.chan1_gcamp = ca_data_left.chan1_gcamp;
                    ca_data.chan1_ratio = ca_data_left.chan1_ratio;
                    ca_data.chan1_dg    = ca_data_left.chan1_dg;
                    % right side channel 2
                    ca_data.chan2_ref   = ca_data_right.chan2_ref;
                    ca_data.chan2_gcamp = ca_data_right.chan2_gcamp;
                    ca_data.chan2_ratio = ca_data_right.chan2_ratio;
                    ca_data.chan2_dg    = ca_data_right.chan2_dg;
                    
                end
                %% Plot
                % Plot raw example trace for channel 1
                traceFig = figure;
                sgtitle([thisMonth ': ' thisExperCondition ' & ' thisModel ' (' strrep(titleSession(lengthModelName+1:end),'_',' ') ')']);
                subplot(3,2,1);
                plot(ca_data.time,ca_data.chan1_gcamp);
                title('Channel 1: Raw Calcium Signal');
                ylabel('Fluorescence');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                box off;
                subplot(3,2,3);
                plot(ca_data.time,ca_data.chan1_ref);
                title('Channel 1: Reference');
                ylabel('Fluorescence');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                box off;
                subplot(3,2,5);
                plot(ca_data.time,ca_data.chan1_dg);
                title('Channel 1: \Delta F/F');
                ylabel('\Delta F/F (%)');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                box off;
                subplot(3,2,2);
                plot(ca_data.time,ca_data.chan2_gcamp);
                title('Channel 2: Raw Calcium Signal');
                ylabel('Fluorescence');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                box off;
                subplot(3,2,4);
                plot(ca_data.time,ca_data.chan2_ref);
                title('Channel 2: Reference');
                ylabel('Fluorescence');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                box off;
                subplot(3,2,6);
                plot(ca_data.time,ca_data.chan2_dg);
                title('Channel 2: \Delta F/F');
                ylabel('\Delta F/F (%)');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                box off;
                %% Save session data
                save([ANALYZED_DATA INDICATOR_FOLDER thisMonth '/' thisExperCondition '_' thisSession '_data.mat'], 'ca_data');
                %% Save figure
                savefig([FIGURES INDICATOR_FOLDER thisMonth '/Preprocessing/RawTraces/' thisExperCondition '_' titleSession '_Traces.fig']);
                set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                saveas(traceFig,[FIGURES INDICATOR_FOLDER thisMonth '/Preprocessing/RawTraces/' thisExperCondition '_' titleSession '_Traces.png']);
                
                previousSession = titleSession;
            end %session
        end %model
    end %exper condition
end %month
end