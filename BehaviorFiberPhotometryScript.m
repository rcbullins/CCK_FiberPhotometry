%Behavior script

%% Set Paths
BASEPATH_EXCEL = 'E:\UNC\SongLab\Behavior_NPR\';

BASEPATH = 'C:\Users\rcbul\OneDrive - University of North Carolina at Chapel Hill\Song_Lab\';
CODE_REAGAN = [BASEPATH 'Code\'];
RAW_DATA = [BASEPATH 'Data\'];
ANALYZED_DATA= [BASEPATH 'Analyzed_Data\'];
FIGURES = [BASEPATH 'Figures\'];

addpath(genpath(CODE_REAGAN));
addpath(genpath(RAW_DATA));
addpath(genpath(ANALYZED_DATA));

SetGraphDefaults;
%% Data to run
dataEncoding{1} = 'E:\UNC\SongLab\Behavior_NPR\20220310_5mon_EncodingDay\hM3D_DioGC\CCK_f6_827\2022_03_10-13_56_32\';
dataEncoding{2} = 'E:\UNC\SongLab\Behavior_NPR\20220310_5mon_EncodingDay\hM3D_DioGC\CCK_m3_830\2022_03_10-14_16_31\';
dataEncoding{3} = 'E:\UNC\SongLab\Behavior_NPR\20220310_5mon_EncodingDay\hM3D_DioGC\CCKAD_m2_827\2022_03_10-13_14_33\';
dataEncoding{4} = 'E:\UNC\SongLab\Behavior_NPR\20220310_5mon_EncodingDay\L_hM3D_DioGC_R_hM3D_GFAPGC\CCK_f2_828\2022_03_15-14_14_32\';
dataEncoding{5} = 'E:\UNC\SongLab\Behavior_NPR\20220310_5mon_EncodingDay\L_hM3D_DioGC_R_hM3D_GFAPGC\CCK_f3_828\2022_03_15-14_33_26\';

dataRetrieval{1} = 'E:\UNC\SongLab\Behavior_NPR\20220311_5mon_RetrievalDay\hM3D_DioGC\CCK_f6_827\2022_03_11-13_56_27\';
dataRetrieval{2} = 'E:\UNC\SongLab\Behavior_NPR\20220311_5mon_RetrievalDay\hM3D_DioGC\CCK_m3_830\2022_03_11-14_16_56\';
dataRetrieval{3} = 'E:\UNC\SongLab\Behavior_NPR\20220311_5mon_RetrievalDay\hM3D_DioGC\CCKAD_m2_827\2022_03_11-13_15_54\';
dataRetrieval{4} = 'E:\UNC\SongLab\Behavior_NPR\20220311_5mon_RetrievalDay\L_hM3D_DioGC_R_hM3D_GFAPGC\CCK_f2_828\2022_03_16-14_19_03\';
dataRetrieval{5} = 'E:\UNC\SongLab\Behavior_NPR\20220311_5mon_RetrievalDay\L_hM3D_DioGC_R_hM3D_GFAPGC\CCK_f3_828\2022_03_16-14_35_50\';

for isession = 1:length(dataEncoding)
    THIS_ENCODING  = dataEncoding{isession};
    THIS_RETRIEVAL = dataRetrieval{isession};
    
    NEURAL_ENCODING    = [THIS_ENCODING 'Fluorescence.csv'];
    NEURAL_RETRIEVAL   = [THIS_RETRIEVAL 'Fluorescence.csv'];
    
    BEHAVIOR_ENCODING  = [THIS_ENCODING 'MarkedBehavior.xlsx'];
    BEHAVIOR_RETRIEVAL = [THIS_RETRIEVAL 'MarkedBehavior.xlsx'];
    
    enc_data = readtable(BEHAVIOR_ENCODING);
    ret_data = readtable(BEHAVIOR_RETRIEVAL);
    
    % Prep Matrices
    plotNum=50;
    matrixA_enc_c1 = zeros(plotNum*2+1,length(find(cell2mat(enc_data.Object)' == 'A')));
    matrixB_enc_c1 = zeros(plotNum*2+1,length(find(cell2mat(enc_data.Object)' == 'B')));
    matrixA_enc_c2 = zeros(plotNum*2+1,length(find(cell2mat(enc_data.Object)' == 'A')));
    matrixB_enc_c2 = zeros(plotNum*2+1,length(find(cell2mat(enc_data.Object)' == 'B')));
  
    matrixA_ret_c1 = zeros(plotNum*2+1,length(find(cell2mat(ret_data.Object)' == 'A')));
    matrixB_ret_c1 = zeros(plotNum*2+1,length(find(cell2mat(ret_data.Object)' == 'B')));
    matrixA_ret_c2 = zeros(plotNum*2+1,length(find(cell2mat(ret_data.Object)' == 'A')));
    matrixB_ret_c2 = zeros(plotNum*2+1,length(find(cell2mat(ret_data.Object)' == 'B')));
    
    objectList_enc = cell2mat(enc_data.Object)';
    trialA_ct = 0;
    trialB_ct = 0;
    % Encoding plot
    for itrial = 1:length(enc_data.StartMinute)
    %% Conversion
    msC = 1000;
    fps = 1000/30;
    
    minInterval = enc_data.StartMinute(itrial);
    secInterval = enc_data.StartSecond(itrial);
    frameInterval = enc_data.StartFrame(itrial);
    
    event2plot(1) = (minInterval(1)*60*msC)+(secInterval(1)*msC)+(frameInterval(1)*fps);
    
    %% Get Data Struct
    samplingRate = 10;
    ca_data = getDataStruct(NEURAL_ENCODING, samplingRate);
    ca_data.chan1 = ca_data.chan1_dg;
    ca_data.chan2 = ca_data.chan2_dg;
    %% Run Filtering
    % Filtering Params
    samp_freq = 10;
    cutoff_freq = [0.05];
    filter_type = 'high'; % 'low' 'bandpass' 'stop';
    IIR_order = 3;
    data_temp.chan1_filt = filter_2sIIR(ca_data.chan1',cutoff_freq,samp_freq,IIR_order,filter_type)+mean(ca_data.chan1(1:100));
    data_temp.chan2_filt = filter_2sIIR(ca_data.chan2',cutoff_freq,samp_freq,IIR_order,filter_type)+mean(ca_data.chan2(1:100));  %highpass filter
    
    cutoff_freq = [2];
    filter_type = 'low' ;% 'low' 'bandpass' 'stop'
    IIR_order = 3;
    ca_data.chan1_filt = filter_2sIIR(data_temp.chan1_filt,cutoff_freq,samp_freq,IIR_order,filter_type)+mean(data_temp.chan1_filt(1:100));
    ca_data.chan2_filt = filter_2sIIR(data_temp.chan2_filt,cutoff_freq,samp_freq,IIR_order,filter_type)+mean(data_temp.chan2_filt(1:100));  %highpass filter
    ca_data.chan1_filt = ca_data.chan1_filt';
    ca_data.chan2_filt = ca_data.chan2_filt';
    
    %% Align Video and Neural
    % Find closest time point in calcium data to video data
    start_dist    = abs(ca_data.time - event2plot(1));
    start_minDist = min(start_dist);
    start_minIdx  = (start_dist == start_minDist);
    start_minVal  = ca_data.time(start_minIdx);
    
    startIdx = find(ca_data.time==start_minVal);
   
    % now plot around this with start in red and end in blue
    % before plot, define how many data points to plot before and after start
   
    % see if plot num is in bounds of vector (not beggining or end)
    if startIdx-plotNum < 1
        plotNumStart = length(1:startIdx)-1;
    else
        plotNumStart = plotNum;
    end
 %% Plot encoding
    % Plot
    figure;
    subplot(2,1,1);
    plot(ca_data.time(startIdx-plotNumStart:startIdx+plotNumStart), ca_data.chan1_filt(startIdx-plotNumStart:startIdx+plotNumStart));
    hold on;
    plot(ca_data.time(startIdx-plotNumStart:startIdx+plotNumStart), ca_data.chan1(startIdx-plotNumStart:startIdx+plotNumStart));
    xline(ca_data.time(startIdx),'r');
    ylabel('DeltaF');
    xlabel('Time (ms)');
    title('Channel 1');
    
    subplot(2,1,2);
    plot(ca_data.time(startIdx-plotNumStart:startIdx+plotNumStart), ca_data.chan2_filt(startIdx-plotNumStart:startIdx+plotNumStart));
    hold on;
    plot(ca_data.time(startIdx-plotNumStart:startIdx+plotNumStart), ca_data.chan2(startIdx-plotNumStart:startIdx+plotNumStart));
    xline(ca_data.time(startIdx),'r');
    ylabel('DeltaF');
    xlabel('Time (ms)');
    title('Channel 2');
    if startIdx-plotNum < 1
       continue;
    else
        plotNumStart = plotNum;
    end
    %% Save to a matrix
     if strcmp(objectList_enc(itrial),'A')
        trialA_ct = trialA_ct+1;
        matrixA_enc_c1(:,trialA_ct) = ca_data.chan1_filt(startIdx-plotNumStart:startIdx+plotNumStart);
        matrixA_enc_c2(:,trialA_ct) = ca_data.chan2_filt(startIdx-plotNumStart:startIdx+plotNumStart);
    elseif strcmp(objectList_enc(itrial),'B')
        trialB_ct = trialB_ct+1;
        matrixB_enc_c1(:,trialB_ct) = ca_data.chan1_filt(startIdx-plotNumStart:startIdx+plotNumStart);
        matrixB_enc_c2(:,trialB_ct) = ca_data.chan2_filt(startIdx-plotNumStart:startIdx+plotNumStart);
     end
     
    end %encoding trials
   %% Retrieval trials 
    trialA_ct = 0;
    trialB_ct = 0;
    objectList_ret = cell2mat(ret_data.Object)';
    for itrial = 1:length(ret_data.StartMinute)
    %% Conversion
    msC = 1000;
    fps = 1000/30;
    
    minInterval = ret_data.StartMinute(itrial);
    secInterval = ret_data.StartSecond(itrial);
    frameInterval = ret_data.StartFrame(itrial);
    
    event2plot(1) = (minInterval(1)*60*msC)+(secInterval(1)*msC)+(frameInterval(1)*fps);
    
    %% Get Data Struct
    samplingRate = 10;
    ca_data = getDataStruct(NEURAL_RETRIEVAL, samplingRate);
    ca_data.chan1 = ca_data.chan1_dg;
    ca_data.chan2 = ca_data.chan2_dg;
    %% Run Filtering
    % Filtering Params
    samp_freq = 10;
    cutoff_freq = [0.05];
    filter_type = 'high'; % 'low' 'bandpass' 'stop';
    IIR_order = 3;
    data_temp.chan1_filt = filter_2sIIR(ca_data.chan1',cutoff_freq,samp_freq,IIR_order,filter_type)+mean(ca_data.chan1(1:100));
    data_temp.chan2_filt = filter_2sIIR(ca_data.chan2',cutoff_freq,samp_freq,IIR_order,filter_type)+mean(ca_data.chan2(1:100));  %highpass filter
    
    cutoff_freq = [2];
    filter_type = 'low' ;% 'low' 'bandpass' 'stop'
    IIR_order = 3;
    ca_data.chan1_filt = filter_2sIIR(data_temp.chan1_filt,cutoff_freq,samp_freq,IIR_order,filter_type)+mean(data_temp.chan1_filt(1:100));
    ca_data.chan2_filt = filter_2sIIR(data_temp.chan2_filt,cutoff_freq,samp_freq,IIR_order,filter_type)+mean(data_temp.chan2_filt(1:100));  %highpass filter
    ca_data.chan1_filt = ca_data.chan1_filt';
    ca_data.chan2_filt = ca_data.chan2_filt';
    
    %% Align Video and Neural
    % Find closest time point in calcium data to video data
    start_dist    = abs(ca_data.time - event2plot(1));
    start_minDist = min(start_dist);
    start_minIdx  = (start_dist == start_minDist);
    start_minVal  = ca_data.time(start_minIdx);
    
    startIdx = find(ca_data.time==start_minVal);
   
    % now plot around this with start in red and end in blue
    % before plot, define how many data points to plot before and after start
   
    % see if plot num is in bounds of vector (not beggining or end)
    if startIdx-plotNum < 1
        plotNumStart = length(1:startIdx)-1;
    else
        plotNumStart = plotNum;
    end
 %% Plot retrieval
    % Plot
    figure;
    subplot(2,1,1);
    plot(ca_data.time(startIdx-plotNumStart:startIdx+plotNumStart), ca_data.chan1_filt(startIdx-plotNumStart:startIdx+plotNumStart));
    hold on;
    plot(ca_data.time(startIdx-plotNumStart:startIdx+plotNumStart), ca_data.chan1(startIdx-plotNumStart:startIdx+plotNumStart));
    xline(ca_data.time(startIdx),'r');
    ylabel('DeltaF');
    xlabel('Time (ms)');
    title('Channel 1');
    
    subplot(2,1,2);
    plot(ca_data.time(startIdx-plotNumStart:startIdx+plotNumStart), ca_data.chan2_filt(startIdx-plotNumStart:startIdx+plotNumStart));
    hold on;
    plot(ca_data.time(startIdx-plotNumStart:startIdx+plotNumStart), ca_data.chan2(startIdx-plotNumStart:startIdx+plotNumStart));
    xline(ca_data.time(startIdx),'r');
    ylabel('DeltaF');
    xlabel('Time (ms)');
    title('Channel 2');
     if startIdx-plotNum < 1
       continue;
    else
        plotNumStart = plotNum;
    end
    %% Save to a matrix
     if strcmp(objectList_ret(itrial),'A')
        trialA_ct = trialA_ct+1;
        matrixA_ret_c1(:,trialA_ct) = ca_data.chan1_filt(startIdx-plotNumStart:startIdx+plotNumStart);
        matrixA_ret_c2(:,trialA_ct) = ca_data.chan2_filt(startIdx-plotNumStart:startIdx+plotNumStart);
    elseif strcmp(objectList_ret(itrial),'B')
        trialB_ct = trialB_ct+1;
        matrixB_ret_c1(:,trialB_ct) = ca_data.chan1_filt(startIdx-plotNumStart:startIdx+plotNumStart);
        matrixB_ret_c2(:,trialB_ct) = ca_data.chan2_filt(startIdx-plotNumStart:startIdx+plotNumStart);
     end
     
    end %retrieval trials
    %% Plot encoding mean of trials 
    % Object A: Channel 1
    objA_enc_c1 = mean(matrixA_enc_c1,2);
    timeAlign = [-plotNumStart:plotNumStart];
    
    OBJA_ENC_C1 = plot(timeAlign,objA_enc_c1);
    hold on;
    options.x_axis = timeAlign;
    options.error = 'sem';
    options.handle= figure(1);    %
    options.color_area='r';
    options.color_line = 'b';
    options.alpha=.5;
    options.line_width = 1;
    plot_areaerrorbar(matrixA_enc_c1',options);
    
    
end

% %% Plotting end and stop times
% minInterval = [enc_data.StartMinute{itrial} enc];
%     secInterval = [37 38];
%     frameInterval = [4 30];
%     
%     event2plot(1) = (minInterval(1)*60*msC)+(secInterval(1)*msC)+(frameInterval(1)*fps);
%     event2plot(2) = (minInterval(2)*60*msC)+(secInterval(2)*msC)+(frameInterval(2)*fps); %ms
%     
%     %% Get Data Struct
%     samplingRate = 10;
%     ca_data = getDataStruct(THIS_ENCODING, samplingRate);
%     ca_data.chan1 = ca_data.chan1_dg;
%     ca_data.chan2 = ca_data.chan2_dg;
%     %% Run Filtering
%     % Filtering Params
%     samp_freq = 10;
%     cutoff_freq = [0.05];
%     filter_type = 'high'; % 'low' 'bandpass' 'stop';
%     IIR_order = 3;
%     data_temp.chan1_filt = filter_2sIIR(ca_data.chan1',cutoff_freq,samp_freq,IIR_order,filter_type)+mean(ca_data.chan1(1:100));
%     data_temp.chan2_filt = filter_2sIIR(ca_data.chan2',cutoff_freq,samp_freq,IIR_order,filter_type)+mean(ca_data.chan2(1:100));  %highpass filter
%     
%     cutoff_freq = [2];
%     filter_type = 'low' ;% 'low' 'bandpass' 'stop'
%     IIR_order = 3;
%     ca_data.chan1_filt = filter_2sIIR(data_temp.chan1_filt,cutoff_freq,samp_freq,IIR_order,filter_type)+mean(data_temp.chan1_filt(1:100));
%     ca_data.chan2_filt = filter_2sIIR(data_temp.chan2_filt,cutoff_freq,samp_freq,IIR_order,filter_type)+mean(data_temp.chan2_filt(1:100));  %highpass filter
%     ca_data.chan1_filt = ca_data.chan1_filt';
%     ca_data.chan2_filt = ca_data.chan2_filt';
%     figure;
%     % for channel 1
%     subplot(2,1,1);
%     plot(ca_data.time, ca_data.chan1,'r');
%     hold on;
%     plot(ca_data.time, ca_data.chan1_filt,'b');
%     title('Channel 1');
%     box off;
%     ylabel('\Delta F/F (%)');
%     xlabel('Time (ms)');
%     % for channel 2
%     subplot(2,1,2);
%     plot(ca_data.time, ca_data.chan2,'r');
%     hold on;
%     plot(ca_data.time, ca_data.chan2_filt,'b');
%     title('Channel 2');
%     box off;
%     ylabel('\Delta F/F (%)');
%     xlabel('Time (ms)');
%     
%     %% Plot around event
%     % Find closest time point in calcium data to video data
%     start_dist    = abs(ca_data.time - event2plot(1));
%     start_minDist = min(start_dist);
%     start_minIdx  = (start_dist == start_minDist);
%     start_minVal  = ca_data.time(start_minIdx);
%     
%     end_dist    = abs(ca_data.time - event2plot(2));
%     end_minDist = min(end_dist);
%     end_minIdx  = (end_dist == end_minDist);
%     end_minVal  = ca_data.time(end_minIdx);
%     
%     startIdx = find(ca_data.time==start_minVal);
%     endIdx = find(ca_data.time==end_minVal);
%     % now plot around this with start in red and end in blue
%     % before plot, define how many data points to plot before and after start
%    
%     % see if plot num is in bounds of vector (not beggining or end)
%     if startIdx-plotNum < 1
%         plotNumStart = length(1:startIdx)-1;
%     else
%         plotNumStart = plotNum;
%     end
%     if endIdx+plotNum > length(ca_data.time)
%         plotNumEnd = length(ca_data.time)-endIdx;
%     else
%         plotNumEnd = plotNum;
%     end
%     % now plot
%     figure;
%     subplot(2,1,1);
%     
%     plot(ca_data.time(startIdx-plotNumStart:endIdx+plotNumEnd), ca_data.chan1_filt(startIdx-plotNumStart:endIdx+plotNumEnd));
%     hold on;
%     plot(ca_data.time(startIdx-plotNumStart:endIdx+plotNumEnd), ca_data.chan1(startIdx-plotNumStart:endIdx+plotNumEnd));
%     
%     xline(ca_data.time(startIdx),'r');
%     xline(ca_data.time(endIdx),'b');
%     ylabel('DeltaF');
%     xlabel('Time (ms)');
%     title('Channel 1');
%     
%     subplot(2,1,2);
%     plot(ca_data.time(startIdx-plotNumStart:endIdx+plotNumEnd), ca_data.chan2_filt(startIdx-plotNumStart:endIdx+plotNumEnd));
%     hold on;
%     plot(ca_data.time(startIdx-plotNumStart:endIdx+plotNumEnd), ca_data.chan2(startIdx-plotNumStart:endIdx+plotNumEnd));
%     
%     xline(ca_data.time(startIdx),'r');
%     xline(ca_data.time(endIdx),'b');
%     ylabel('DeltaF');
%     xlabel('Time (ms)');
%     title('Channel 2');
 %% Optional plotting of data set
%     figure;
%     % for channel 1
%     subplot(2,1,1);
%     plot(ca_data.time, ca_data.chan1,'r');
%     hold on;
%     plot(ca_data.time, ca_data.chan1_filt,'b');
%     title('Channel 1');
%     box off;
%     ylabel('\Delta F/F (%)');
%     xlabel('Time (ms)');
%     % for channel 2
%     subplot(2,1,2);
%     plot(ca_data.time, ca_data.chan2,'r');
%     hold on;
%     plot(ca_data.time, ca_data.chan2_filt,'b');
%     title('Channel 2');
%     box off;
%     ylabel('\Delta F/F (%)');
%     xlabel('Time (ms)');