function [ca_data] = getDataStruct(csv_data_path,samplingRate, varargin)
% PURPOSE
%   - Load in raw data from excel sheet and save in a matlab struct. Can
%   give input if only want to find data struct for channel 1 or channel 2,
%   corresponding to 'left' and 'right' recording side
% INPUT
%   - csv_data_path (string): directory of excel sheet to open for experiment
%                      Example: 'C:\Users\rcbul\Data\sessionNumber\Fluorescence.csv'
% OUTPUT
%   - ca_data (struct): ca_data.time         (timestamps of datapoints of recording)
%                       ca_data.chan1_ref    (reference signal)
%                       ca_data.chan1_gcamp  (gcamp signal)
%                       ca_data.chan1_ratio  (gcamp:reference)
%                       ca_data.chan1_dg     (delta f over f)
%                              ... for channel 2 as well
% EXAMPLE
%                     ca_data_left = getDataStruct(THIS_CA_DATA_LEFT,'recSide','left');
%                     ca_data_right = getDataStruct(THIS_CA_DATA_RIGHT,'recSide','right');
% HISTORY
%   2.22.2022 Reagan Bullins
%% Input Parser
p = inputParser;
addParameter(p,'recSide','both',@isstring);
addParameter(p,'minAnalyze',20,@isnumeric);
addParameter(p,'analyzeAll',0,@isnumeric);
parse(p,varargin{:});
recSide     = p.Results.recSide;
minAnalyze  = p.Results.minAnalyze;
analyzeAll  = p.Results.analyzeAll;

%% how much of recording time to save 
if analyzeAll
    minAnalyze = 100000; %extreme number to analyze, so will just analyze what it can
    samplingPoints = (10*60*minAnalyze)+(1*samplingRate);
elseif ~analyzeAll
    samplingPoints = (10*60*minAnalyze)+(1*samplingRate);
end

if strcmp(recSide,'both')
    %% Load in csv sheet
    this_ca_data = readtable(csv_data_path);
    if size(this_ca_data,1) < samplingPoints
        samplingPoints = size(this_ca_data,1);
    end
    %% Organize data in struct from csv file
    ca_data.time      = this_ca_data.TimeStamp(1:samplingPoints);
    ca_data.chan1_ref = this_ca_data.CH1_410(end-samplingPoints+1:end);
    ca_data.chan1_gcamp = this_ca_data.CH1_470(end-samplingPoints+1:end);
    ca_data.chan2_ref = this_ca_data.CH2_410(end-samplingPoints+1:end);
    ca_data.chan2_gcamp = this_ca_data.CH2_470(end-samplingPoints+1:end);
    %% Get change of fluroscence (corrected for noise) dF/F =( F(t) - F0)/F0
    ca_data.chan1_ratio = ca_data.chan1_gcamp./ca_data.chan1_ref;
    ca_data.chan2_ratio = ca_data.chan2_gcamp./ca_data.chan2_ref;
    
    ca_data.chan1_dg     = (ca_data.chan1_ratio/median(ca_data.chan1_ratio)-1)*100;
    ca_data.chan2_dg     = (ca_data.chan2_ratio/median(ca_data.chan2_ratio)-1)*100;
elseif strcmp(recSide,'left')
    %% Load in csv sheet
    this_ca_data = readtable(csv_data_path);
    if size(this_ca_data,1) < samplingPoints
        samplingPoints = size(this_ca_data,1);
    end
    %% Organize data in struct from csv file
    ca_data.time      = this_ca_data.TimeStamp(1:samplingPoints);
    ca_data.chan1_ref = this_ca_data.CH2_410(end-samplingPoints+1:end);
    ca_data.chan1_gcamp = this_ca_data.CH2_470(end-samplingPoints+1:end);
    %% Get change of fluroscence (corrected for noise) dF/F =( F(t) - F0)/F0
    ca_data.chan1_ratio = ca_data.chan1_gcamp./ca_data.chan1_ref;
    ca_data.chan1_dg     = (ca_data.chan1_ratio/median(ca_data.chan1_ratio)-1)*100;
    
elseif strcmp(recSide,'right')
    %% Load in csv sheet
    this_ca_data = readtable(csv_data_path);
    if size(this_ca_data,1) < samplingPoints
        samplingPoints = size(this_ca_data,1);
    end
    %% Organize data in struct from csv file
    ca_data.time      = this_ca_data.TimeStamp(1:samplingPoints);
    ca_data.chan2_ref = this_ca_data.CH2_410(end-samplingPoints+1:end);
    ca_data.chan2_gcamp = this_ca_data.CH2_470(end-samplingPoints+1:end);

    %% Get change of fluroscence (corrected for noise) dF/F =( F(t) - F0)/F0
    ca_data.chan2_ratio = ca_data.chan2_gcamp./ca_data.chan2_ref;
    ca_data.chan2_dg     = (ca_data.chan2_ratio/median(ca_data.chan2_ratio)-1)*100;
end
end