function [] = getPowerSpectrum(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER)
clear;
clc;
%% Set conditions
MODELS           = {'CCK','CCKAD'}; %WT and AD models
EXPER_CONDITIONS = {'baseline','CNO'};
INDICATOR_FOLDER = 'hM3D_DioGC\'; %L_hM3D_DioGC_R_hM3D_GFAPGC
MONTHS           = {'3mon','4mon'};
%% Variables
sampFreq = 10;
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
    % loop through each model
    for imodel = 1:length(MODELS)
        thisModel = MODELS{imodel};
        thisDir = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\'];
        % for baseline
        animalSessionsSearch_bl = sprintf('baseline_%s_*_data.mat',thisModel);
        allAnimalFolders_bl = dir(fullfile(thisDir, animalSessionsSearch_bl));
        SESSIONS_BL = {allAnimalFolders_bl.name};
        % for CNO
        animalSessionsSearch_CNO = sprintf('CNO_%s_*_data.mat',thisModel);
        allAnimalFolders_CNO = dir(fullfile(thisDir, animalSessionsSearch_CNO));
        SESSIONS_CNO = {allAnimalFolders_CNO.name};
        
        for isession = 1:length(SESSIONS_BL)
            thisSession = SESSIONS_BL{isession};
            %take off baseline and filtered.mat
            animalInfo = thisSession(10:end-9);
            % define directories to load
            THIS_SESSION_BL = [thisDir thisSession];
            THIS_SESSION_CNO = [thisDir 'CNO_' animalInfo '_data.mat'];
            %% Load raw data
            load(THIS_SESSION_BL);
            BL_data = ca_data;
            load(THIS_SESSION_CNO);
            CNO_data = ca_data;
            %% FT
            dt=1/sampFreq; % Sampling interval (line 2)
            rec_time_BL =length(BL_data.time)./sampFreq; % total recording time (line 3)
            % Chan 1 baseline
            freq_chan1_BL= fft(BL_data.chan1_dg); %Calculate the Fourier Transform (line 4)
            Pow_chan1_BL=(2*(dt^2)/rec_time_BL)*abs(freq_chan1_BL); %Do the calculation for
            Pow_chan1_BL_2=Pow_chan1_BL(1:(length(BL_data.chan1_dg)/(2))+1); % Only use the
            df_BL=1/max(rec_time_BL); % Frequency resolution (line 7)
            fnq= sampFreq/2; % Nyquist frequency= half the sampling
            freq_axis_BL=(0:df_BL:fnq); %Gives you the frequency axis. (line 9)
            % Chan 2 Baseline
            freq_chan2_BL= fft(BL_data.chan2_dg); %Calculate the Fourier Transform (line 4)
            Pow_chan2_BL=(2*(dt^2)/rec_time_BL)*abs(freq_chan2_BL); %Do the calculation for
            Pow_chan2_BL_2=Pow_chan2_BL(1:(length(BL_data.chan2_dg)/(2))+1); % Only use the
            % Chan1 CNO
            rec_time_CNO=length(CNO_data.time)./sampFreq; % total recording time (line 3)
            freq_chan1_CNO= fft(CNO_data.chan1_dg); %Calculate the Fourier Transform (line 4)
            Pow_chan1_CNO=(2*(dt^2)/rec_time_CNO)*abs(freq_chan1_CNO); %Do the calculation for
            Pow_chan1_CNO_2=Pow_chan1_CNO(1:(length(CNO_data.chan1_dg)/(2))+1); % Only use the
            df_CNO=1/max(rec_time_CNO); % Frequency resolution (line 7)
            fnq= sampFreq/2; % Nyquist frequency= half the sampling
            freq_axis_CNO=(0:df_CNO:fnq); %Gives you the frequency axis. (line 9)
            % Chan 2 CNO
            freq_chan2_CNO= fft(CNO_data.chan1_dg); %Calculate the Fourier Transform (line 4)
            Pow_chan2_CNO=(2*(dt^2)/rec_time_CNO)*abs(freq_chan2_CNO); %Do the calculation for
            Pow_chan2_CNO_2=Pow_chan2_CNO(1:(length(CNO_data.chan2_dg)/(2))+1); % Only use the
   
            % Find max y
            maxYgraph = max(Pow_chan1_BL_2);
            if maxYgraph < max(Pow_chan2_BL_2)
                maxYgraph = max(Pow_chan2_BL_2);
            end
            if maxYgraph < max(Pow_chan1_CNO_2)
                maxYgraph = max(Pow_chan1_CNO_2);
            end
            if maxYgraph < max(Pow_chan2_CNO_2)
                maxYgraph = max(Pow_chan2_CNO_2);
            end
            
            %Plot all
            figure;
            sgtitle({[thisMonth ': Powerspectrum Baseline vs CNO'],[strrep(animalInfo,'_',' ')]});
            % Chan 1 baseline
            subplot(2,2,1);
            plot(freq_axis_BL,Pow_chan1_BL_2,'b') % Plot power spectrum (line 10)
            hold on;
            xlabel('Frequency Hz') % (line 12)
            ylabel ('Power') %(line 13)
            title('BL Chan1');
            xlim([0 sampFreq/2]);
            ylim([0 maxYgraph]);
            % Chan 2 baseline
            subplot(2,2,2);
            plot(freq_axis_BL,Pow_chan2_BL_2,'b') % Plot power spectrum (line 10)
            hold on;
            xlabel('Frequency Hz') % (line 12)
            ylabel ('Power') %(line 13)
            title('BL Chan2');
            xlim([0 sampFreq/2]);
            ylim([0 maxYgraph]);
            % Chan 1 CNO
            subplot(2,2,3);
            plot(freq_axis_CNO,Pow_chan1_CNO_2,'r') % Plot power spectrum (line 10)
            hold on;
            xlabel('Frequency Hz') % (line 12)
            ylabel ('Power') %(line 13)
            title('CNO Chan1');
            xlim([0 sampFreq/2]);
             ylim([0 maxYgraph]);
            % Chan 2 CNO
            subplot(2,2,4);
            plot(freq_axis_CNO,Pow_chan2_CNO_2,'r') % Plot power spectrum (line 10)
            hold on;
            xlabel('Frequency Hz') % (line 12)
            ylabel ('Power') %(line 13)
            title('CNO Chan2');
            xlim([0 sampFreq/2]);
             ylim([0 maxYgraph]);
           

        end %session
    end %model
end %month
end