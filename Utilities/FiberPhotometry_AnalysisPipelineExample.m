%% Fiber Photometry Analysis Pipeline
% PURPOSE
%   Example of analysis pipeline for fiber photometry data analysis.
%   This pipeline will go through one specified session at a time.

%   This script includes created functions for fiber photometry analysis. All
%   functions utilized in this script can be found on Github at ...
%   https://github.com/rcbullins/FiberPhotometry

% NOTES
%   Directories of folders and files are indicated by all capitilization.
%   Replace each of the directories/paths before starting.
% HISTORY
%   2.22.2021 - Reagan Bullins
%% Add MATLAB Paths for code and data directories - CHANGE HERE 
% Main directory with data and code folder within
BASEPATH = 'C:\Users\rcbul\OneDrive - University of North Carolina at Chapel Hill\Song_Lab\';
% Code directory - location on computer
CODE = [BASEPATH 'Code\'];
% Data directory - location on computer
DATA = [BASEPATH 'Data\'];
% Adding the paths to MATLAB so they are accessible by MATLAB
addpath(genpath(CODE));
addpath(genpath(DATA));
%% Load in raw data from CSV - CHANGE HERE
% Pick a session directory - place here
CSV_DIRECTORY = 'C:\Users\rcbul\OneDrive - University of North Carolina at Chapel Hill\Song_Lab\Data\20211206_3mon_baseline\hM3D_DioGC\CCK_f6_827\2021_12_06-15_56_48\Fluorescence.csv';
% Load in the data
ca_data = getDataStruct(CSV_DIRECTORY);

%% Define variables (just so easier to work with)
time         = ca_data.time;
chan1_deltaF = ca_data.chan1_dg;
chan2_deltaF = ca_data.chan2_dg;

%% Plot Raw Data
% Plot delta F/F trace for channel 1
figure;                         % create new figure
subplot(2,1,1);                 % first graph in group
plot(time,chan1_deltaF);        % plot(x values, y values)
title('Channel 1: \Delta F/F'); % title of graph
ylabel('\Delta F/F (%)');       % y axis label
xlabel('Time (ms)');            % x axis label
xlim([0 time(end)]);            % limits of x axis [upper_bound lower_bound]
box off;                        % takes box surrounding figure off - looks nicer

% Plot delta F/F trace for channel 2
box off;
subplot(2,1,2);                 % second graph in group 
plot(time, chan2_deltaF);
title('Channel 2: \Delta F/F');
ylabel('\Delta F/F (%)');
xlabel('Time (ms)');
xlim([0 ca_data.time(end)]);
box off;
%% Filter Data
% Set filtering params
samp_freq = 10;
cutoff_freq = .05;
filter_type = 'high'; %'high' 'low' 'bandpass' 'stop'
IIR_order = 3;

% filter data for channel 1
chan1_filt = filter_2sIIR(chan1_deltaF',cutoff_freq,samp_freq,IIR_order,filter_type)+mean(chan1_deltaF(1:100));
% filter data for channel 2
chan2_filt = filter_2sIIR(chan2_deltaF',cutoff_freq,samp_freq,IIR_order,filter_type)+mean(chan2_deltaF(1:100));
%% Plot filtered Data
figure;

% for channel 1
subplot(2,1,1);
plot(time, chan1_deltaF,'r'); % Plot raw data
hold on;                      % hold graph on - want to keep plotting on same graph
plot(time, chan1_filt','b');  % Plot filtered data on top of raw data
title('Channel 1');           % title of figure
legend({'deltaF','Filtered'});% legend for figure
box off;
ylabel('\Delta F/F (%)');     % y axis label
xlabel('Time (ms)');          % x axis label

% for channel 2
subplot(2,1,2);
plot(time, chan2_deltaF,'r');
hold on;
plot(time, chan2_filt','b');
title('Channel 2');
box off;
ylabel('\Delta F/F (%)');
xlabel('Time (ms)');
%% Find calcium events in filtered deltaF/F data
% Find mean and std deviation for channel 1 and 2
stdDev_chan1   = std(chan1_filt);
mean_chan1 = mean(chan1_filt);
stdDev_chan2   = std(cchan2_filt);
mean_chan2 = mean(chan2_filt);

% Find large events over a threshold value of 3 std from mean  (over butterworth filtered data)
thr_large.chan1 = 3*stdDev_chan1;
thr_large.chan2 = 3*stdDev_chan2;

largeEvents.chan1_idx = find(ca_data.chan1_dg >= (dataMean.chan1+thr_large.chan1));
largeEvents.chan1_values = ca_data.chan1_dg(largeEvents.chan1_idx);
largeEvents.chan2_idx = find(ca_data.chan2_dg >= (dataMean.chan2+thr_large.chan2));
largeEvents.chan2_values = ca_data.chan2_dg(largeEvents.chan2_idx);
% Find small events between 1 and 3 std deviations from the mean
thr_small.chan1 = 1*stdDev_chan1;
thr_small.chan2 = 1*stdDev_chan1;

smallEvents.chan1_idx = find(ca_data.chan1_dg >= (dataMean.chan1+thr_small.chan1)...
    & ca_data.chan1_dg < (dataMean.chan1+thr_large.chan1));
smallEvents.chan1_values = ca_data.chan1_dg(smallEvents.chan1_idx);
smallEvents.chan2_idx = find(ca_data.chan2_dg >= (dataMean.chan2+thr_small.chan1)...
    & ca_data.chan2_dg < (dataMean.chan2+thr_large.chan2));
smallEvents.chan2_values = ca_data.chan2_dg(smallEvents.chan2_idx);
%% Plot calcium events for both channels, small vs large
figure;
%plot channel 1 small events
subplot(4,1,1);
plot(ca_data.time,ca_data.chan1_dg,'b');
hold on;
scatter(ca_data.time(smallEvents.chan1_idx),smallEvents.chan1_values,'k');
title('Channel 1: Small Events');
box off;
ylabel('\Delta F/F (%)');
xlabel('Time (ms)');
% plot channel 1 large events
subplot(4,1,2);
plot(ca_data.time,ca_data.chan1_dg,'b');
hold on;
scatter(ca_data.time(largeEvents.chan1_idx),largeEvents.chan1_values,'k');
title('Channel 1: Large Events');
box off;
ylabel('\Delta F/F (%)');
xlabel('Time (ms)');
% plot channel 2 small events
subplot(4,1,3);
plot(ca_data.time,ca_data.chan2_dg,'b');
hold on;
scatter(ca_data.time(smallEvents.chan2_idx),smallEvents.chan2_values,'k');
title('Channel 2: Small Events');
box off;
ylabel('\Delta F/F (%)');
xlabel('Time (ms)');
% plot channel 2 large events
subplot(4,1,4);
plot(ca_data.time,ca_data.chan2_dg,'b');
hold on;
scatter(ca_data.time(largeEvents.chan2_idx),largeEvents.chan2_values,'k');
title('Channel 2: Large Events');
box off;
ylabel('\Delta F/F (%)');
xlabel('Time (ms)');
%% Get small event characteristics
% number of events
smallEventChrts.chan1_ct = length(smallEvents.chan1_idx);
smallEventChrts.chan2_ct = length(smallEvents.chan2_idx);
% frequency of events (divide by amount of seconds) (time
% in ms --> sec)
smallEventChrts.chan1_timefreq = smallEventChrts.chan1_ct/(ca_data.time(end)/1000);
smallEventChrts.chan2_timefreq = smallEventChrts.chan2_ct/(ca_data.time(end)/1000);
% frequency of events (divide by amount of points)
smallEventChrts.chan1_ptfreq = smallEventChrts.chan1_ct/length(ca_data.time);
smallEventChrts.chan2_ptfreq = smallEventChrts.chan2_ct/length(ca_data.time);
% amplitude of events
smallEventChrts.chan1_amp = smallEvents.chan1_values;
smallEventChrts.chan2_amp = smallEvents.chan2_values;
% under the curve (add all amplitude values)
smallEventChrts.chan1_auc = sum(smallEventChrts.chan1_amp);
smallEventChrts.chan2_auc = sum(smallEventChrts.chan2_amp);
%% Get large event characteristics
% number of events
largeEventChrts.chan1_ct = length(largeEvents.chan1_idx);
largeEventChrts.chan2_ct = length(largeEvents.chan2_idx);
% frequency of events (divide by amount of seconds) (time
% in ms --> sec)
largeEventChrts.chan1_timefreq = largeEventChrts.chan1_ct/(ca_data.time(end)/1000);
largeEventChrts.chan2_timefreq = largeEventChrts.chan2_ct/(ca_data.time(end)/1000);
% frequency of events (divide by amount of points)
largeEventChrts.chan1_ptfreq = largeEventChrts.chan1_ct/length(ca_data.time);
largeEventChrts.chan2_ptfreq = largeEventChrts.chan2_ct/length(ca_data.time);
% amplitude of events
largeEventChrts.chan1_amp = largeEvents.chan1_values;
largeEventChrts.chan2_amp = largeEvents.chan2_values;
% under the curve (add all amplitude values)
largeEventChrts.chan1_auc = sum(largeEventChrts.chan1_amp);
largeEventChrts.chan2_auc = sum(largeEventChrts.chan2_amp);
