% Filtering script
% PURPOSE
%     Filter gcamp data with butterworth filter - see what parameters work
%     best.
%     4 conditions:
%        - baseline
%               WT vs AD model
%        - increase CCK activity (activated hM3D with CNO)
%               WT vs AD model
% INPUT
%    - mat files with data for each experimental session labeled as such:
%       baseline_CCK_sessionInfo_data.mat (made with preprocessing script)
%           this contains a ca_data struct for chan1 and chan2:
%                                  .time
%                                  .chan1_ref   (reference signal)
%                                  .chan1_gcamp (raw gcamp signal)
%                                  .chan1_ratio (gcamp to ref signal)
%                                  .chan1_dg    (deltaF/F)
% OUTPUTS
%   - filtered data
% DEPENDENCIES
%   filter_2sIIR (Hechen code to bandpass filter calcium traces)
%   run Preprocessing_Script first (or just make sure to have struct as
%   above)
% HISTORY
%   2.1.2022 Reagan Bullins
clear;
clc;
%% Filtering Params
samp_freq = 10;
cutoff_freq = .05;
filter_type = 'high'; %'high' 'low' 'bandpass' 'stop'
IIR_order = 3;
%% Set Paths
BASEPATH = 'C:\Users\rcbul\OneDrive - University of North Carolina at Chapel Hill\Song_Lab\';
CODE_REAGAN = [BASEPATH 'Code\'];
ANALYZED_DATA= [BASEPATH 'Analyzed_Data\'];
FIGURES = [BASEPATH 'Figures\'];

addpath(genpath(CODE_REAGAN));
addpath(genpath(ANALYZED_DATA));

SetGraphDefaults;
%% Set conditions
MODELS           = {'CCK','CCKAD'}; %WT and AD models
EXPER_CONDITIONS = {'baseline','CNO'};
INDICATOR_FOLDER = 'hM3D_DioGC\'; %L_hM3D_DioGC_R_hM3D_GFAPGC
MONTHS = {'3mon'};
%%
for imonth = 1:length(MONTHS)
    thisMonth = MONTHS{imonth};
    % Loop through each condition
    for icondition = 1:length(EXPER_CONDITIONS)
        thisExperCondition = EXPER_CONDITIONS{icondition};
        % loop through each model
        for imodel = 1:length(MODELS)
            thisModel = MODELS{imodel};
            thisDir = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '/'];
            % See how many sessions are in the folder for this condition and
            % model
            modelSearchFolders = sprintf('%s_%s_*_data.mat',thisExperCondition, thisModel);
            allModelFolders = dir(fullfile(thisDir, modelSearchFolders));
            SESSIONS = {allModelFolders.name};
            
            for isession = 1:length(SESSIONS)
                thisSession = SESSIONS{isession};
                %take off .mat
                thisSession = thisSession(1:end-9);
                THIS_SESSION_DIR = [thisDir thisSession '_data.mat'];
                %% Open session data
                load([ANALYZED_DATA INDICATOR_FOLDER thisMonth '/' thisSession '_data.mat'], 'ca_data');
                %% Filter data
                ca_data.chan1_filt = filter_2sIIR(ca_data.chan1_dg',cutoff_freq,samp_freq,IIR_order,filter_type)+ca_data.chan1_dg(1);
                ca_data.chan2_filt = filter_2sIIR(ca_data.chan2_dg',cutoff_freq,samp_freq,IIR_order,filter_type)+ca_data.chan2_dg(1);  %highpass filter
                %% Plot with filter
                figure;
                sgtitle({[thisExperCondition ' & ' thisModel ' (' strrep(thisSession,'_',' ') ')'],...
                    [filter_type ' pass filt, order: ' num2str(IIR_order) ', cutoff freq: ' num2str(cutoff_freq)]});
                % for channel 1
                subplot(2,1,1);
                plot(ca_data.time, ca_data.chan1_dg,'r');
                hold on;
                plot(ca_data.time, ca_data.chan1_filt','b');
                title('Channel 1');
                legend({'Normalized','Filtered'});
                box off;
                ylabel('\Delta F/F (%)');
                xlabel('Time (ms)');
                % for channel 2
                subplot(2,1,2);
                plot(ca_data.time, ca_data.chan2_dg,'r');
                hold on;
                plot(ca_data.time, ca_data.chan2_filt','b');
                title('Channel 2');
                box off;
                ylabel('\Delta F/F (%)');
                xlabel('Time (ms)');
                %% Save filtered data
                save([ANALYZED_DATA INDICATOR_FOLDER thisMonth '/' thisSession '_filtered.mat'], 'ca_data');
            end %session
        end %model
    end %exper condition
end %month
