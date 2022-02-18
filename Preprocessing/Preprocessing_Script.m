function [] = Preprocessing_Script(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER)
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
            for isession = 1:length(SESSIONS)
                thisSession = SESSIONS{isession};
                sessionDir = [thisDir thisSession '\'];
                sessionFolder = dir(fullfile(sessionDir,'*_*'));
                THIS_SESSION_DIR = [thisSession '\' sessionFolder.name '\'];
                %% Load in excel sheets
                % Identify excel sheet to load in
                THIS_CA_DATA = [RAW_DATA DATA_FOLDER INDICATOR_FOLDER THIS_SESSION_DIR 'Fluorescence.csv'];
                this_ca_data = readtable(THIS_CA_DATA);
                
                %% Organize data in struct
                ca_data.time      = this_ca_data.TimeStamp;
                ca_data.chan1_ref = this_ca_data.CH1_410;
                ca_data.chan1_gcamp = this_ca_data.CH1_470;
                ca_data.chan2_ref = this_ca_data.CH2_410;
                ca_data.chan2_gcamp = this_ca_data.CH2_470;
                %% Get change of fluroscence (corrected for noise) dF/F =( F(t) - F0)/F0
                ca_data.chan1_ratio = ca_data.chan1_gcamp./ca_data.chan1_ref;
                ca_data.chan2_ratio = ca_data.chan2_gcamp./ca_data.chan2_ref;
                
                ca_data.chan1_dg     = (ca_data.chan1_ratio/median(ca_data.chan1_ratio)-1)*100;
                ca_data.chan2_dg     = (ca_data.chan2_ratio/median(ca_data.chan2_ratio)-1)*100;
                %% Plot
                % Plot raw example trace for channel 1
                traceFig = figure;
                sgtitle([thisMonth ': ' thisExperCondition ' & ' thisModel ' (' strrep(thisSession,'_',' ') ')']);
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
                savefig([FIGURES INDICATOR_FOLDER thisMonth '/Preprocessing/RawTraces/' thisExperCondition '_' thisSession '_Traces.fig']);
                set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                saveas(traceFig,[FIGURES INDICATOR_FOLDER thisMonth '/Preprocessing/RawTraces/' thisExperCondition '_' thisSession '_Traces.png']);
            end %session
        end %model
    end %exper condition
end %month
end