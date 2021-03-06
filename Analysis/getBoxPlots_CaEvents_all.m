function getBoxPlots_CaEvents_all(MONTHS, INDICATOR_FOLDER1, INDICATOR_FOLDER2)
% PURPOSE
%     Get boxplots of large and small calcium events. Break up comparing BL
%     vs CNO recordings. Also color dots on boxplots as sex-specific
%     color.FOR ALL RECORDINGS. includes recording for half right/half
%     left.
% INPUT
%    - mat files group event data
%          groupEvents.mat
%               smallGroupEvents
%               groupEvents
%                   each are structs that contain info for each animal
%                   within a group. Groups include CCK BL, CCK CNO, CCKAD
%                   BL, and CCKAD CNO. Info includes sex of animal,
%                   frequency of events, auc of events, etc.
% OUTPUTS
%  Boxplots comparing CCK baseline and CNO, and boxplots comparing CCKAD
%  BL and CNO. Boxplots have dots overlaying showing individual sessions.
%  Each dot is colored to be sex specific.
% DEPENDENCIES
%   FindEvents_Script
% HISTORY
%   3.3.2022 Reagan Bullins

BASEPATH = 'C:\Users\rcbul\OneDrive - University of North Carolina at Chapel Hill\Song_Lab\';
ANALYZED_DATA= [BASEPATH 'Analyzed_Data\'];
FIGURES = [BASEPATH 'Figures\'];

for imonth = 1:length(MONTHS)
    thisMonth = MONTHS{imonth};
    
    CCK_EVENT_BL1 = [ANALYZED_DATA INDICATOR_FOLDER1 thisMonth '\Events\baseline_CCK_groupEvents.mat'];
    CCK_EVENT_CNO1 = [ANALYZED_DATA INDICATOR_FOLDER1 thisMonth '\Events\CNO_CCK_groupEvents.mat'];
    CCKAD_EVENT_BL1 = [ANALYZED_DATA INDICATOR_FOLDER1 thisMonth '\Events\baseline_CCKAD_groupEvents.mat'];
    CCKAD_EVENT_CNO1 = [ANALYZED_DATA INDICATOR_FOLDER1 thisMonth '\Events\CNO_CCKAD_groupEvents.mat'];
    
    CCK_EVENT_BL2 = [ANALYZED_DATA INDICATOR_FOLDER2 thisMonth '\Events\baseline_CCK_groupEvents.mat'];
    CCK_EVENT_CNO2 = [ANALYZED_DATA INDICATOR_FOLDER2 thisMonth '\Events\CNO_CCK_groupEvents.mat'];
    CCKAD_EVENT_BL2 = [ANALYZED_DATA INDICATOR_FOLDER2 thisMonth '\Events\baseline_CCKAD_groupEvents.mat'];
    CCKAD_EVENT_CNO2 = [ANALYZED_DATA INDICATOR_FOLDER2 thisMonth '\Events\CNO_CCKAD_groupEvents.mat'];
    
    %% Load Group Events
    %indicator 1
    load(CCK_EVENT_BL1, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
    CCK_BL_largeEvents = largeGroupEvents;
    CCK_BL_superEvents = superGroupEvents;
    CCK_BL_smallEvents = smallGroupEvents;
    load(CCK_EVENT_CNO1, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
    CCK_CNO_largeEvents = largeGroupEvents;
    CCK_CNO_superEvents = superGroupEvents;
    CCK_CNO_smallEvents = smallGroupEvents;
    load(CCKAD_EVENT_BL1, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
    CCKAD_BL_largeEvents = largeGroupEvents;
    CCKAD_BL_superEvents = superGroupEvents;
    CCKAD_BL_smallEvents = smallGroupEvents;
    load(CCKAD_EVENT_CNO1, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
    CCKAD_CNO_largeEvents = largeGroupEvents;
    CCKAD_CNO_superEvents = superGroupEvents;
    CCKAD_CNO_smallEvents = smallGroupEvents;
    %indicator 2
    load(CCK_EVENT_BL2, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
    numSessions = size(largeGroupEvents,2);
    chan1_idx = 1:2:numSessions; % Neurons
    chan2_idx = 2:2:numSessions; % Glia
    IN_CCK_BL_largeEvents = largeGroupEvents(chan1_idx);
    IN_CCK_BL_smallEvents = smallGroupEvents(chan1_idx);
    IN_CCK_BL_superEvents = superGroupEvents(chan1_idx);
    Gl_CCK_BL_largeEvents = largeGroupEvents(chan2_idx);
    Gl_CCK_BL_smallEvents = smallGroupEvents(chan2_idx);
    Gl_CCK_BL_superEvents = superGroupEvents(chan2_idx);
    load(CCK_EVENT_CNO2, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
    numSessions = size(largeGroupEvents,2);
    chan1_idx = 1:2:numSessions; % Neurons
    chan2_idx = 2:2:numSessions; % Glia
    IN_CCK_CNO_largeEvents = largeGroupEvents(chan1_idx);
    IN_CCK_CNO_smallEvents = smallGroupEvents(chan1_idx);
    IN_CCK_CNO_superEvents = superGroupEvents(chan1_idx);
    Gl_CCK_CNO_largeEvents = largeGroupEvents(chan2_idx);
    Gl_CCK_CNO_smallEvents = smallGroupEvents(chan2_idx);
    Gl_CCK_CNO_superEvents = superGroupEvents(chan2_idx);
    load(CCKAD_EVENT_BL2, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
    numSessions = size(largeGroupEvents,2);
    chan1_idx = 1:2:numSessions; % Neurons
    chan2_idx = 2:2:numSessions; % Glia
    IN_CCKAD_BL_largeEvents = largeGroupEvents(chan1_idx);
    IN_CCKAD_BL_smallEvents = smallGroupEvents(chan1_idx);
    IN_CCKAD_BL_superEvents = superGroupEvents(chan1_idx);
    Gl_CCKAD_BL_largeEvents = largeGroupEvents(chan2_idx);
    Gl_CCKAD_BL_smallEvents = smallGroupEvents(chan2_idx);
    Gl_CCKAD_BL_superEvents = superGroupEvents(chan2_idx);
    load(CCKAD_EVENT_CNO2, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
    numSessions = size(largeGroupEvents,2);
    chan1_idx = 1:2:numSessions; % Neurons
    chan2_idx = 2:2:numSessions; % Glia
    IN_CCKAD_CNO_largeEvents = largeGroupEvents(chan1_idx);
    IN_CCKAD_CNO_smallEvents = smallGroupEvents(chan1_idx);
    IN_CCKAD_CNO_superEvents = superGroupEvents(chan1_idx);
    Gl_CCKAD_CNO_largeEvents = largeGroupEvents(chan2_idx);
    Gl_CCKAD_CNO_smallEvents = smallGroupEvents(chan2_idx);
    Gl_CCKAD_CNO_superEvents = superGroupEvents(chan2_idx);
    
    %% Restructure into all CCK vs 1/2 astrocytes
    ALL_CCK_BL_largeEvents = [CCK_BL_largeEvents IN_CCK_BL_largeEvents];
    ALL_CCK_BL_superEvents = [CCK_BL_superEvents IN_CCK_BL_superEvents];
    ALL_CCK_BL_smallEvents = [CCK_BL_smallEvents IN_CCK_BL_smallEvents];
    
    ALL_CCK_CNO_largeEvents = [CCK_CNO_largeEvents IN_CCK_CNO_largeEvents];
    ALL_CCK_CNO_superEvents = [CCK_CNO_superEvents IN_CCK_CNO_largeEvents];
    ALL_CCK_CNO_smallEvents = [CCK_CNO_smallEvents IN_CCK_CNO_largeEvents];
    
    ALL_CCKAD_BL_largeEvents = [CCKAD_BL_largeEvents IN_CCKAD_BL_largeEvents];
    ALL_CCKAD_BL_superEvents = [CCKAD_BL_superEvents IN_CCKAD_BL_superEvents];
    ALL_CCKAD_BL_smallEvents = [CCKAD_BL_smallEvents IN_CCKAD_BL_smallEvents];
    
    ALL_CCKAD_CNO_largeEvents = [CCKAD_CNO_largeEvents IN_CCKAD_CNO_largeEvents];
    ALL_CCKAD_CNO_superEvents = [CCKAD_CNO_superEvents IN_CCKAD_CNO_superEvents];
    ALL_CCKAD_CNO_smallEvents = [CCKAD_CNO_smallEvents IN_CCKAD_CNO_smallEvents];
    
    %%%%%%%%%%%%%% INDICATOR 1 %%%%%%%%%%%%%%%%%%%%%
    %% Color Map
    colorMap(1,:) = [0 0 1];
    colorMap(2,:) = [1 0 0];
    colorMap(3,:) = [0 0 1];
    colorMap(4,:) = [1 0 0];
    colorSex_CCK_BL = zeros(sum(~cellfun(@isempty,{ALL_CCK_BL_largeEvents.s})),3);
    colorSex_CCK_CNO = zeros(sum(~cellfun(@isempty,{ALL_CCK_CNO_largeEvents.s})),3);
    colorSex_CCKAD_BL = zeros(sum(~cellfun(@isempty,{ALL_CCKAD_BL_largeEvents.s})),3);
    colorSex_CCKAD_CNO = zeros(sum(~cellfun(@isempty,{ALL_CCKAD_CNO_largeEvents.s})),3);
    % get color for dots of female vs male
    for i = 1:length(ALL_CCK_BL_largeEvents)
        if strcmp(ALL_CCK_BL_largeEvents(i).s,'f')
            colorSex_CCK_BL(i,:) = [0 0 0];
        elseif strcmp(ALL_CCK_BL_largeEvents(i).s,'m')
            colorSex_CCK_BL(i,:) = [1 1 1];
        end
    end
    % get color for dots of female vs male
    for i = 1:length(ALL_CCK_CNO_largeEvents)
        if strcmp(ALL_CCK_CNO_largeEvents(i).s,'f')
            colorSex_CCK_CNO(i,:) = [0 0 0];
        elseif strcmp(ALL_CCK_CNO_largeEvents(i).s,'m')
            colorSex_CCK_CNO(i,:) = [1 1 1];
        end
    end
    % get color for dots of female vs male
    for i = 1:length(ALL_CCKAD_BL_largeEvents)
        if strcmp(ALL_CCKAD_BL_largeEvents(i).s,'f')
            colorSex_CCKAD_BL(i,:) = [0 0 0];
        elseif strcmp(ALL_CCKAD_BL_largeEvents(i).s,'m')
            colorSex_CCKAD_BL(i,:) = [1 1 1];
        end
    end
    % get color for dots of female vs male
    for i = 1:length(ALL_CCKAD_CNO_largeEvents)
        if strcmp(ALL_CCKAD_CNO_largeEvents(i).s,'f')
            colorSex_CCKAD_CNO(i,:) = [0 0 0];
        elseif strcmp(ALL_CCKAD_CNO_largeEvents(i).s,'m')
            colorSex_CCKAD_CNO(i,:) = [1 1 1];
        end
    end
    %% One big plot super events
    supFig = figure;
    sgtitle({[thisMonth ': Super Calcium Events'],' '});
    %% Plot time Freq
    timeFreq(:,1) = vertcat(ALL_CCK_BL_superEvents.timeFreq)';
    timeFreq(:,2) = vertcat(ALL_CCK_CNO_superEvents.timeFreq)';
    tF1.max = max(timeFreq,[],'all');
    tF1.min = min(timeFreq,[],'all');
    timeFreq2(:,1) = vertcat(ALL_CCKAD_BL_superEvents.timeFreq);
    timeFreq2(:,2) = vertcat(ALL_CCKAD_CNO_superEvents.timeFreq);
    tF2.max = max(timeFreq2,[],'all');
    tF2.min = min(timeFreq2,[],'all');
    if tF1.min <= tF2.min
        ymin = tF1.min;
    else
        ymin = tF2.min
    end
    if tF1.max >= tF2.max
        ymax = tF1.max;
    else
        ymax = tF2.max;
    end
    subplot(1,2,1);
    %this is dumb but i just need a color matching legend
    lg1 = plot([100 200 300],[100 100 100],'Color',colorMap(1,:));
    hold on;
    lg2 = plot([100 200 300],[100 100 100],'Color',colorMap(2,:));
    lh = legend('Baseline','CNO');
    % don't make a legend for h2.
    % actual data
    boxplot(timeFreq,'Color',colorMap(1:2,:),'position',[1 2]);
    xlim([0 5]);
    boxplot(timeFreq2,'Color',colorMap(3:4,:),'position',[3 4]);
    
    ylabel('Frequency (Hz)');
    title('Frequency');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    
    for idot = 1:length(vertcat(ALL_CCK_BL_superEvents.timeFreq)')
        scatter(ones(length(vertcat(ALL_CCK_BL_superEvents(idot).timeFreq)'),1), vertcat(ALL_CCK_BL_superEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCK_CNO_superEvents.timeFreq)')
        scatter(2*ones(length(vertcat(ALL_CCK_CNO_superEvents(idot).timeFreq)'),1), vertcat(ALL_CCK_CNO_superEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCKAD_BL_superEvents.timeFreq)')
        scatter(3*ones(length(vertcat(ALL_CCKAD_BL_superEvents(idot).timeFreq)'),1), vertcat(ALL_CCKAD_BL_superEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCKAD_CNO_superEvents.timeFreq)')
        scatter(4*ones(length(vertcat(ALL_CCKAD_CNO_superEvents(idot).timeFreq)'),1), vertcat(ALL_CCKAD_CNO_superEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for i = 1:size(ALL_CCK_BL_superEvents,2)
        plot([1 2], [ALL_CCK_BL_superEvents(i).timeFreq ALL_CCK_CNO_superEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    for i = 1:size(ALL_CCKAD_BL_superEvents,2)
        plot([3 4], [ALL_CCKAD_BL_superEvents(i).timeFreq ALL_CCKAD_CNO_superEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    legend([lg1,lg2]);
    %ttest CCK BL vs CNO
    CCK_temp1 = vertcat(ALL_CCK_BL_superEvents.timeFreq);
    CCK_temp1 = CCK_temp1';
    CCK_temp2 = vertcat(ALL_CCK_CNO_superEvents.timeFreq);
    CCK_temp2 = CCK_temp2';
    [~,p1]= ttest(CCK_temp1,CCK_temp2);
    % ttest CCKAD BL vs CNO
    CCK_temp3 = vertcat(ALL_CCKAD_BL_superEvents.timeFreq);
    CCK_temp3 = CCK_temp3';
    CCK_temp4 = vertcat(ALL_CCKAD_CNO_superEvents.timeFreq);
    CCK_temp4 = CCK_temp4';
    [~,p2]= ttest(CCK_temp3,CCK_temp4);
    
    XTickString{1} = ['$$\begin{array}{c}' ...
        'CCK' '\\'...
        'p=' num2str(round(p1,3)) '\\'...
        '\end{array}$$'];
    XTickString{2} = ['$$\begin{array}{c}' ...
        'CCKAD' '\\'...
        'p=' num2str(round(p2,3)) '\\'...
        '\end{array}$$'];
    x=[1.5 3.5];
    set(gca,'xtick',x,'XTickLabel',XTickString,'TickLabelInterpreter','latex');
    set (gca, 'FontName', 'Arial'); 
    %% auc
    auc(:,1) = vertcat(ALL_CCK_BL_superEvents.auc)';
    auc(:,2) = vertcat(ALL_CCK_CNO_superEvents.auc)';
    Yauc.max = max(auc,[],'all');
    Yauc.min = min(auc,[],'all');
    auc2(:,1) = vertcat(ALL_CCKAD_BL_superEvents.auc);
    auc2(:,2) = vertcat(ALL_CCKAD_CNO_superEvents.auc);
    Yauc2.max = max(auc2,[],'all');
    Yauc2.min = min(auc2,[],'all');
    if Yauc.min <= Yauc2.min
        ymin = Yauc.min;
    else
        ymin = Yauc2.min;
    end
    if Yauc.max >= Yauc2.max
        ymax = Yauc.max;
    else
        ymax = Yauc2.max;
    end
    subplot(1,2,2);
    %this is dumb but i just need a color matching legend
    lg1 = plot([100 200 300],[100 100 100],'Color',colorMap(1,:));
    hold on;
    lg2 = plot([100 200 300],[100 100 100],'Color',colorMap(2,:));
    lh = legend('Baseline','CNO');
    % don't make a legend for h2.
    % actual data
    boxplot(auc,'Color',colorMap(1:2,:),'position',[1 2]);
    xlim([0 5]);
    boxplot(auc2,'Color',colorMap(3:4,:),'position',[3 4]);
    
    ylabel('AUC');
    title('AUC of Events');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(ALL_CCK_BL_superEvents.auc)')
        scatter(ones(length(vertcat(ALL_CCK_BL_superEvents(idot).auc)'),1), vertcat(ALL_CCK_BL_superEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCK_CNO_superEvents.auc)')
        scatter(2*ones(length(vertcat(ALL_CCK_CNO_superEvents(idot).auc)'),1), vertcat(ALL_CCK_CNO_superEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCKAD_BL_superEvents.auc)')
        scatter(3*ones(length(vertcat(ALL_CCKAD_BL_superEvents(idot).auc)'),1), vertcat(ALL_CCKAD_BL_superEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCKAD_CNO_superEvents.auc)')
        scatter(4*ones(length(vertcat(ALL_CCKAD_CNO_superEvents(idot).auc)'),1), vertcat(ALL_CCKAD_CNO_superEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for i = 1:size(ALL_CCK_BL_superEvents,2)
        plot([1 2], [ALL_CCK_BL_superEvents(i).auc ALL_CCK_CNO_superEvents(i).auc],'Color',[0 0 0]+.8);
    end
    for i = 1:size(ALL_CCKAD_BL_superEvents,2)
        plot([3 4], [ALL_CCKAD_BL_superEvents(i).auc ALL_CCKAD_CNO_superEvents(i).auc],'Color',[0 0 0]+.8);
    end
    
    legend([lg1,lg2]);
     %ttest CCK BL vs CNO
    CCK_temp1 = vertcat(ALL_CCK_BL_superEvents.auc);
    CCK_temp1 = CCK_temp1';
    CCK_temp2 = vertcat(ALL_CCK_CNO_superEvents.auc);
    CCK_temp2 = CCK_temp2';
    [~,p1]= ttest(CCK_temp1,CCK_temp2);
    % ttest CCKAD BL vs CNO
    CCK_temp3 = vertcat(ALL_CCKAD_BL_superEvents.auc);
    CCK_temp3 = CCK_temp3';
    CCK_temp4 = vertcat(ALL_CCKAD_CNO_superEvents.auc);
    CCK_temp4 = CCK_temp4';
    [~,p2]= ttest(CCK_temp3,CCK_temp4);
    
    XTickString{1} = ['$$\begin{array}{c}' ...
        'CCK' '\\'...
        'p=' num2str(round(p1,3)) '\\'...
        '\end{array}$$'];
    XTickString{2} = ['$$\begin{array}{c}' ...
        'CCKAD' '\\'...
        'p=' num2str(round(p2,3)) '\\'...
        '\end{array}$$'];
    x=[1.5 3.5];
    set(gca,'xtick',x,'XTickLabel',XTickString,'TickLabelInterpreter','latex');
    
    
    
    savefig([FIGURES thisMonth '_Boxplot_allEvents_Super.fig']);
    saveas(supFig,[FIGURES thisMonth '_Boxplot_allEvents_Super.png']);
    clear timeFreq timeFreq2 ptFreq ct amp auc auc2;
    %% One big plot lareg events
    largeFig = figure;
    sgtitle({[thisMonth ': Large Calcium Events'],' '});
    %% Plot time Freq
    timeFreq(:,1) = vertcat(ALL_CCK_BL_largeEvents.timeFreq)';
    timeFreq(:,2) = vertcat(ALL_CCK_CNO_largeEvents.timeFreq)';
    tF1.max = max(timeFreq,[],'all');
    tF1.min = min(timeFreq,[],'all');
    timeFreq2(:,1) = vertcat(ALL_CCKAD_BL_largeEvents.timeFreq);
    timeFreq2(:,2) = vertcat(ALL_CCKAD_CNO_largeEvents.timeFreq);
    tF2.max = max(timeFreq2,[],'all');
    tF2.min = min(timeFreq2,[],'all');
    if tF1.min <= tF2.min
        ymin = tF1.min;
    else
        ymin = tF2.min
    end
    if tF1.max >= tF2.max
        ymax = tF1.max;
    else
        ymax = tF2.max;
    end
    subplot(1,2,1);
    %this is dumb but i just need a color matching legend
    lg1 = plot([100 200 300],[100 100 100],'Color',colorMap(1,:));
    hold on;
    lg2 = plot([100 200 300],[100 100 100],'Color',colorMap(2,:));
    lh = legend('Baseline','CNO');
    % don't make a legend for h2.
    % actual data
    boxplot(timeFreq,'Color',colorMap(1:2,:),'position',[1 2]);
    xlim([0 5]);
    boxplot(timeFreq2,'Color',colorMap(3:4,:),'position',[3 4]);
    
    ylabel('Frequency (Hz)');
    title('Frequency');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    
    for idot = 1:length(vertcat(ALL_CCK_BL_largeEvents.timeFreq)')
        scatter(ones(length(vertcat(ALL_CCK_BL_largeEvents(idot).timeFreq)'),1), vertcat(ALL_CCK_BL_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCK_CNO_largeEvents.timeFreq)')
        scatter(2*ones(length(vertcat(ALL_CCK_CNO_largeEvents(idot).timeFreq)'),1), vertcat(ALL_CCK_CNO_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCKAD_BL_largeEvents.timeFreq)')
        scatter(3*ones(length(vertcat(ALL_CCKAD_BL_largeEvents(idot).timeFreq)'),1), vertcat(ALL_CCKAD_BL_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCKAD_CNO_largeEvents.timeFreq)')
        scatter(4*ones(length(vertcat(ALL_CCKAD_CNO_largeEvents(idot).timeFreq)'),1), vertcat(ALL_CCKAD_CNO_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for i = 1:size(ALL_CCK_BL_largeEvents,2)
        plot([1 2], [ALL_CCK_BL_largeEvents(i).timeFreq ALL_CCK_CNO_largeEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    for i = 1:size(ALL_CCKAD_BL_largeEvents,2)
        plot([3 4], [ALL_CCKAD_BL_largeEvents(i).timeFreq ALL_CCKAD_CNO_largeEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    legend([lg1,lg2]);
    
     %ttest CCK BL vs CNO
    CCK_temp1 = vertcat(ALL_CCK_BL_largeEvents.timeFreq);
    CCK_temp1 = CCK_temp1';
    CCK_temp2 = vertcat(ALL_CCK_CNO_largeEvents.timeFreq);
    CCK_temp2 = CCK_temp2';
    [~,p1]= ttest(CCK_temp1,CCK_temp2);
    % ttest CCKAD BL vs CNO
    CCK_temp3 = vertcat(ALL_CCKAD_BL_largeEvents.timeFreq);
    CCK_temp3 = CCK_temp3';
    CCK_temp4 = vertcat(ALL_CCKAD_CNO_largeEvents.timeFreq);
    CCK_temp4 = CCK_temp4';
    [~,p2]= ttest(CCK_temp3,CCK_temp4);
    
    XTickString{1} = ['$$\begin{array}{c}' ...
        'CCK' '\\'...
        'p=' num2str(round(p1,3)) '\\'...
        '\end{array}$$'];
    XTickString{2} = ['$$\begin{array}{c}' ...
        'CCKAD' '\\'...
        'p=' num2str(round(p2,3)) '\\'...
        '\end{array}$$'];
    x=[1.5 3.5];
    set(gca,'xtick',x,'XTickLabel',XTickString,'TickLabelInterpreter','latex');
    
    
    %% auc
    auc(:,1) = vertcat(ALL_CCK_BL_largeEvents.auc)';
    auc(:,2) = vertcat(ALL_CCK_CNO_largeEvents.auc)';
    Yauc.max = max(auc,[],'all');
    Yauc.min = min(auc,[],'all');
    auc2(:,1) = vertcat(ALL_CCKAD_BL_largeEvents.auc);
    auc2(:,2) = vertcat(ALL_CCKAD_CNO_largeEvents.auc);
    Yauc2.max = max(auc2,[],'all');
    Yauc2.min = min(auc2,[],'all');
    if Yauc.min <= Yauc2.min
        ymin = Yauc.min;
    else
        ymin = Yauc2.min;
    end
    if Yauc.max >= Yauc2.max
        ymax = Yauc.max;
    else
        ymax = Yauc2.max;
    end
    subplot(1,2,2);
    %this is dumb but i just need a color matching legend
    lg1 = plot([100 200 300],[100 100 100],'Color',colorMap(1,:));
    hold on;
    lg2 = plot([100 200 300],[100 100 100],'Color',colorMap(2,:));
    lh = legend('Baseline','CNO');
    % don't make a legend for h2.
    % actual data
    boxplot(auc,'Color',colorMap(1:2,:),'position',[1 2]);
    xlim([0 5]);
    boxplot(auc2,'Color',colorMap(3:4,:),'position',[3 4]);
    
    ylabel('AUC');
    title('AUC of Events');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(ALL_CCK_BL_largeEvents.auc)')
        scatter(ones(length(vertcat(ALL_CCK_BL_largeEvents(idot).auc)'),1), vertcat(ALL_CCK_BL_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCK_CNO_largeEvents.auc)')
        scatter(2*ones(length(vertcat(ALL_CCK_CNO_largeEvents(idot).auc)'),1), vertcat(ALL_CCK_CNO_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCKAD_BL_largeEvents.auc)')
        scatter(3*ones(length(vertcat(ALL_CCKAD_BL_largeEvents(idot).auc)'),1), vertcat(ALL_CCKAD_BL_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCKAD_CNO_largeEvents.auc)')
        scatter(4*ones(length(vertcat(ALL_CCKAD_CNO_largeEvents(idot).auc)'),1), vertcat(ALL_CCKAD_CNO_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for i = 1:size(ALL_CCK_BL_largeEvents,2)
        plot([1 2], [ALL_CCK_BL_largeEvents(i).auc ALL_CCK_CNO_largeEvents(i).auc],'Color',[0 0 0]+.8);
    end
    for i = 1:size(ALL_CCKAD_BL_largeEvents,2)
        plot([3 4], [ALL_CCKAD_BL_largeEvents(i).auc ALL_CCKAD_CNO_largeEvents(i).auc],'Color',[0 0 0]+.8);
    end
    
    legend([lg1,lg2]);
    
     %ttest CCK BL vs CNO
    CCK_temp1 = vertcat(ALL_CCK_BL_largeEvents.auc);
    CCK_temp1 = CCK_temp1';
    CCK_temp2 = vertcat(ALL_CCK_CNO_largeEvents.auc);
    CCK_temp2 = CCK_temp2';
    [~,p1]= ttest(CCK_temp1,CCK_temp2);
    % ttest CCKAD BL vs CNO
    CCK_temp3 = vertcat(ALL_CCKAD_BL_largeEvents.auc);
    CCK_temp3 = CCK_temp3';
    CCK_temp4 = vertcat(ALL_CCKAD_CNO_largeEvents.auc);
    CCK_temp4 = CCK_temp4';
    [~,p2]= ttest(CCK_temp3,CCK_temp4);
    
    XTickString{1} = ['$$\begin{array}{c}' ...
        'CCK' '\\'...
        'p=' num2str(round(p1,3)) '\\'...
        '\end{array}$$'];
    XTickString{2} = ['$$\begin{array}{c}' ...
        'CCKAD' '\\'...
        'p=' num2str(round(p2,3)) '\\'...
        '\end{array}$$'];
    x=[1.5 3.5];
    set(gca,'xtick',x,'XTickLabel',XTickString,'TickLabelInterpreter','latex');
    
    saveas(largeFig,[FIGURES thisMonth '_Boxplot_allEvents_Large.png']);
    savefig([FIGURES thisMonth '_Boxplot_allEvents_Large.fig']);
    clear timeFreq timeFreq2 ptFreq ct amp auc auc2;
    %% One big plot for small events
    smallFig = figure;
    sgtitle({[thisMonth ': Small Calcium Events'],' '});
    %% Plot time Freq
    timeFreq(:,1) = vertcat(ALL_CCK_BL_smallEvents.timeFreq)';
    timeFreq(:,2) = vertcat(ALL_CCK_CNO_smallEvents.timeFreq)';
    timeFreq2(:,1) = vertcat(ALL_CCKAD_BL_smallEvents.timeFreq);
    timeFreq2(:,2) = vertcat(ALL_CCKAD_CNO_smallEvents.timeFreq);
    tF1.max = max(timeFreq,[],'all');
    tF1.min = min(timeFreq,[],'all');
    tF2.max = max(timeFreq2,[],'all');
    tF2.min = min(timeFreq2,[],'all');
    if tF1.min <= tF2.min
        ymin = tF1.min;
    else
        ymin = tF2.min
    end
    if tF1.max >= tF2.max
        ymax = tF1.max;
    else
        ymax = tF2.max;
    end
    subplot(1,2,1);
    %this is dumb but i just need a color matching legend
    lg1 = plot([100 200 300],[100 100 100],'Color',colorMap(1,:));
    hold on;
    lg2 = plot([100 200 300],[100 100 100],'Color',colorMap(2,:));
    lh = legend('Baseline','CNO');
    % don't make a legend for h2.
    % actual data
    boxplot(timeFreq,'Color',colorMap(1:2,:),'position',[1 2]);
    xlim([0 5]);
    boxplot(timeFreq2,'Color',colorMap(3:4,:),'position',[3 4]);
    
    ylabel('Frequency (Hz)');
    title('Frequency');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(ALL_CCK_BL_smallEvents.timeFreq)')
        scatter(ones(length(vertcat(ALL_CCK_BL_smallEvents(idot).timeFreq)'),1), vertcat(ALL_CCK_BL_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCK_CNO_smallEvents.timeFreq)')
        scatter(2*ones(length(vertcat(ALL_CCK_CNO_smallEvents(idot).timeFreq)'),1), vertcat(ALL_CCK_CNO_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCKAD_BL_smallEvents.timeFreq)')
        scatter(3*ones(length(vertcat(ALL_CCKAD_BL_smallEvents(idot).timeFreq)'),1), vertcat(ALL_CCKAD_BL_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCKAD_CNO_smallEvents.timeFreq)')
        scatter(4*ones(length(vertcat(ALL_CCKAD_CNO_smallEvents(idot).timeFreq)'),1), vertcat(ALL_CCKAD_CNO_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for i = 1:size(ALL_CCK_BL_smallEvents,2)
        plot([1 2], [ALL_CCK_BL_smallEvents(i).timeFreq ALL_CCK_CNO_smallEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    for i = 1:size(ALL_CCKAD_BL_smallEvents,2)
        plot([3 4], [ALL_CCKAD_BL_smallEvents(i).timeFreq ALL_CCKAD_CNO_smallEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    
    legend([lg1,lg2]);
    
     %ttest CCK BL vs CNO
    CCK_temp1 = vertcat(ALL_CCK_BL_smallEvents.timeFreq);
    CCK_temp1 = CCK_temp1';
    CCK_temp2 = vertcat(ALL_CCK_CNO_smallEvents.timeFreq);
    CCK_temp2 = CCK_temp2';
    [~,p1]= ttest(CCK_temp1,CCK_temp2);
    % ttest CCKAD BL vs CNO
    CCK_temp3 = vertcat(ALL_CCKAD_BL_smallEvents.timeFreq);
    CCK_temp3 = CCK_temp3';
    CCK_temp4 = vertcat(ALL_CCKAD_CNO_smallEvents.timeFreq);
    CCK_temp4 = CCK_temp4';
    [~,p2]= ttest(CCK_temp3,CCK_temp4);
    
    XTickString{1} = ['$$\begin{array}{c}' ...
        'CCK' '\\'...
        'p=' num2str(round(p1,3)) '\\'...
        '\end{array}$$'];
    XTickString{2} = ['$$\begin{array}{c}' ...
        'CCKAD' '\\'...
        'p=' num2str(round(p2,3)) '\\'...
        '\end{array}$$'];
    x=[1.5 3.5];
    set(gca,'xtick',x,'XTickLabel',XTickString,'TickLabelInterpreter','latex');
    %% auc
    auc(:,1) = vertcat(ALL_CCK_BL_smallEvents.auc)';
    auc(:,2) = vertcat(ALL_CCK_CNO_smallEvents.auc)';
    auc2(:,1) = vertcat(ALL_CCKAD_BL_smallEvents.auc);
    auc2(:,2) = vertcat(ALL_CCKAD_CNO_smallEvents.auc);
    Yauc.max = max(auc,[],'all');
    Yauc.min = min(auc,[],'all');
    Yauc2.max = max(auc2,[],'all');
    Yauc2.min = min(auc2,[],'all');
    if Yauc.min <= Yauc2.min
        ymin = Yauc.min;
    else
        ymin = Yauc2.min;
    end
    if Yauc.max >= Yauc2.max
        ymax = Yauc.max;
    else
        ymax = Yauc2.max;
    end
    subplot(1,2,2);
    %this is dumb but i just need a color matching legend
    lg1 = plot([100 200 300],[100 100 100],'Color',colorMap(1,:));
    hold on;
    lg2 = plot([100 200 300],[100 100 100],'Color',colorMap(2,:));
    lh = legend('Baseline','CNO');
    % don't make a legend for h2.
    % actual data
    boxplot(auc,'Color',colorMap(1:2,:),'position',[1 2]);
    xlim([0 5]);
    boxplot(auc2,'Color',colorMap(3:4,:),'position',[3 4]);
    
    ylabel('AUC');
    title('AUC of Events');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(ALL_CCK_BL_smallEvents.auc)')
        scatter(ones(length(vertcat(ALL_CCK_BL_smallEvents(idot).auc)'),1), vertcat(ALL_CCK_BL_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCK_CNO_smallEvents.auc)')
        scatter(2*ones(length(vertcat(ALL_CCK_CNO_smallEvents(idot).auc)'),1), vertcat(ALL_CCK_CNO_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCKAD_BL_smallEvents.auc)')
        scatter(3*ones(length(vertcat(ALL_CCKAD_BL_smallEvents(idot).auc)'),1), vertcat(ALL_CCKAD_BL_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(ALL_CCKAD_CNO_smallEvents.auc)')
        scatter(4*ones(length(vertcat(ALL_CCKAD_CNO_smallEvents(idot).auc)'),1), vertcat(ALL_CCKAD_CNO_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for i = 1:size(ALL_CCK_BL_smallEvents,2)
        plot([1 2], [ALL_CCK_BL_smallEvents(i).auc ALL_CCK_CNO_smallEvents(i).auc],'Color',[0 0 0]+.8);
    end
    for i = 1:size(ALL_CCKAD_BL_smallEvents,2)
        plot([3 4], [ALL_CCKAD_BL_smallEvents(i).auc ALL_CCKAD_CNO_smallEvents(i).auc],'Color',[0 0 0]+.8);
    end
    
    legend([lg1,lg2]);
    
     %ttest CCK BL vs CNO
    CCK_temp1 = vertcat(ALL_CCK_BL_smallEvents.auc);
    CCK_temp1 = CCK_temp1';
    CCK_temp2 = vertcat(ALL_CCK_CNO_smallEvents.auc);
    CCK_temp2 = CCK_temp2';
    [~,p1]= ttest(CCK_temp1,CCK_temp2);
    % ttest CCKAD BL vs CNO
    CCK_temp3 = vertcat(ALL_CCKAD_BL_smallEvents.auc);
    CCK_temp3 = CCK_temp3';
    CCK_temp4 = vertcat(ALL_CCKAD_CNO_smallEvents.auc);
    CCK_temp4 = CCK_temp4';
    [~,p2]= ttest(CCK_temp3,CCK_temp4);
    
    XTickString{1} = ['$$\begin{array}{c}' ...
        'CCK' '\\'...
        'p=' num2str(round(p1,3)) '\\'...
        '\end{array}$$'];
    XTickString{2} = ['$$\begin{array}{c}' ...
        'CCKAD' '\\'...
        'p=' num2str(round(p2,3)) '\\'...
        '\end{array}$$'];
    x=[1.5 3.5];
    set(gca,'xtick',x,'XTickLabel',XTickString,'TickLabelInterpreter','latex');
    
    saveas(smallFig,[FIGURES thisMonth '_Boxplot_allEvents_Small.png']);
    savefig([FIGURES thisMonth '_Boxplot_allEvents_Small.fig']);
    clear timeFreq timeFreq2 ptFreq ct amp auc auc2;
    %%
    %%%%%%%%%%%%% INDICATOR 2 %%%%%%%%%%%%%%%%%%%%%
    %% Color Map
    colorMap(1,:) = [0 0 1];
    colorMap(2,:) = [1 0 0];
    colorMap(3,:) = [0 0 1];
    colorMap(4,:) = [1 0 0];
    colorSex_CCK_BL2 = zeros(sum(~cellfun(@isempty,{Gl_CCK_BL_largeEvents.s})),3);
    colorSex_CCK_CNO2 = zeros(sum(~cellfun(@isempty,{Gl_CCK_CNO_largeEvents.s})),3);
    colorSex_CCKAD_BL2 = zeros(sum(~cellfun(@isempty,{Gl_CCKAD_BL_largeEvents.s})),3);
    colorSex_CCKAD_CNO2 = zeros(sum(~cellfun(@isempty,{Gl_CCKAD_CNO_largeEvents.s})),3);
    % get color for dots of female vs male
    for i = 1:length(Gl_CCK_BL_largeEvents)
        if strcmp(Gl_CCK_BL_largeEvents(i).s,'f')
            colorSex_CCK_BL2(i,:) = [0 0 0];
        elseif strcmp(Gl_CCK_BL_largeEvents(i).s,'m')
            colorSex_CCK_BL2(i,:) = [1 1 1];
        end
    end
    % get color for dots of female vs male
    for i = 1:length(Gl_CCK_CNO_largeEvents)
        if strcmp(Gl_CCK_CNO_largeEvents(i).s,'f')
            colorSex_CCK_CNO2(i,:) = [0 0 0];
        elseif strcmp(Gl_CCK_CNO_largeEvents(i).s,'m')
            colorSex_CCK_CNO2(i,:) = [1 1 1];
        end
    end
    % get color for dots of female vs male
    for i = 1:length(Gl_CCKAD_BL_largeEvents)
        if strcmp(Gl_CCKAD_BL_largeEvents(i).s,'f')
            colorSex_CCKAD_BL2(i,:) = [0 0 0];
        elseif strcmp(Gl_CCKAD_BL_largeEvents(i).s,'m')
            colorSex_CCKAD_BL2(i,:) = [1 1 1];
        end
    end
    % get color for dots of female vs male
    for i = 1:length(Gl_CCKAD_CNO_largeEvents)
        if strcmp(Gl_CCKAD_CNO_largeEvents(i).s,'f')
            colorSex_CCKAD_CNO2(i,:) = [0 0 0];
        elseif strcmp(Gl_CCKAD_CNO_largeEvents(i).s,'m')
            colorSex_CCKAD_CNO2(i,:) = [1 1 1];
        end
    end
    %% One big plot super events
    superFig2 = figure;
    sgtitle({[thisMonth ': Super Calcium Events Astrocytes'],' '});
    %% Plot time Freq
    timeFreq(:,1) = vertcat(Gl_CCK_BL_superEvents.timeFreq)';
    timeFreq(:,2) = vertcat(Gl_CCK_CNO_superEvents.timeFreq)';
    tF1.max = max(timeFreq,[],'all');
    tF1.min = min(timeFreq,[],'all');
    timeFreq2(:,1) = vertcat(Gl_CCKAD_BL_superEvents.timeFreq);
    timeFreq2(:,2) = vertcat(Gl_CCKAD_CNO_superEvents.timeFreq);
    tF2.max = max(timeFreq2,[],'all');
    tF2.min = min(timeFreq2,[],'all');
    if tF1.min <= tF2.min
        ymin = tF1.min;
    else
        ymin = tF2.min
    end
    if tF1.max >= tF2.max
        ymax = tF1.max;
    else
        ymax = tF2.max;
    end
    subplot(1,2,1);
    %this is dumb but i just need a color matching legend
    lg1 = plot([100 200 300],[100 100 100],'Color',colorMap(1,:));
    hold on;
    lg2 = plot([100 200 300],[100 100 100],'Color',colorMap(2,:));
    lh = legend('Baseline','CNO');
    % don't make a legend for h2.
    % actual data
    boxplot(timeFreq,'Color',colorMap(1:2,:),'position',[1 2]);
    xlim([0 5]);
    boxplot(timeFreq2,'Color',colorMap(3:4,:),'position',[3 4]);
    
    ylabel('Frequency (Hz)');
    title('Frequency');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    
    for idot = 1:length(vertcat(Gl_CCK_BL_superEvents.timeFreq)')
        scatter(ones(length(vertcat(Gl_CCK_BL_superEvents(idot).timeFreq)'),1), vertcat(Gl_CCK_BL_superEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCK_CNO_superEvents.timeFreq)')
        scatter(2*ones(length(vertcat(Gl_CCK_CNO_superEvents(idot).timeFreq)'),1), vertcat(Gl_CCK_CNO_superEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_BL_superEvents.timeFreq)')
        scatter(3*ones(length(vertcat(Gl_CCKAD_BL_superEvents(idot).timeFreq)'),1), vertcat(Gl_CCKAD_BL_superEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_CNO_superEvents.timeFreq)')
        scatter(4*ones(length(vertcat(Gl_CCKAD_CNO_superEvents(idot).timeFreq)'),1), vertcat(Gl_CCKAD_CNO_superEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for i = 1:size(Gl_CCK_BL_superEvents,2)
        plot([1 2], [Gl_CCK_BL_superEvents(i).timeFreq Gl_CCK_CNO_superEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    for i = 1:size(Gl_CCKAD_BL_superEvents,2)
        plot([3 4], [Gl_CCKAD_BL_superEvents(i).timeFreq Gl_CCKAD_CNO_superEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    legend([lg1,lg2]);
    
     %ttest CCK BL vs CNO
    CCK_temp1 = vertcat(Gl_CCK_BL_superEvents.timeFreq);
    CCK_temp1 = CCK_temp1';
    CCK_temp2 = vertcat(Gl_CCK_CNO_superEvents.timeFreq);
    CCK_temp2 = CCK_temp2';
    [~,p1]= ttest(CCK_temp1,CCK_temp2);
    % ttest CCKAD BL vs CNO
    CCK_temp3 = vertcat(Gl_CCKAD_BL_superEvents.timeFreq);
    CCK_temp3 = CCK_temp3';
    CCK_temp4 = vertcat(Gl_CCKAD_CNO_superEvents.timeFreq);
    CCK_temp4 = CCK_temp4';
    [~,p2]= ttest(CCK_temp3,CCK_temp4);
    
    XTickString{1} = ['$$\begin{array}{c}' ...
        'CCK' '\\'...
        'p=' num2str(round(p1,3)) '\\'...
        '\end{array}$$'];
    XTickString{2} = ['$$\begin{array}{c}' ...
        'CCKAD' '\\'...
        'p=' num2str(round(p2,3)) '\\'...
        '\end{array}$$'];
    x=[1.5 3.5];
    set(gca,'xtick',x,'XTickLabel',XTickString,'TickLabelInterpreter','latex');
    %% auc
    auc(:,1) = vertcat(Gl_CCK_BL_superEvents.auc)';
    auc(:,2) = vertcat(Gl_CCK_CNO_superEvents.auc)';
    Yauc.max = max(auc,[],'all');
    Yauc.min = min(auc,[],'all');
    auc2(:,1) = vertcat(Gl_CCKAD_BL_superEvents.auc);
    auc2(:,2) = vertcat(Gl_CCKAD_CNO_superEvents.auc);
    Yauc2.max = max(auc2,[],'all');
    Yauc2.min = min(auc2,[],'all');
    if Yauc.min <= Yauc2.min
        ymin = Yauc.min;
    else
        ymin = Yauc2.min;
    end
    if Yauc.max >= Yauc2.max
        ymax = Yauc.max;
    else
        ymax = Yauc2.max;
    end
    subplot(1,2,2);
    %this is dumb but i just need a color matching legend
    lg1 = plot([100 200 300],[100 100 100],'Color',colorMap(1,:));
    hold on;
    lg2 = plot([100 200 300],[100 100 100],'Color',colorMap(2,:));
    lh = legend('Baseline','CNO');
    % don't make a legend for h2.
    % actual data
    boxplot(auc,'Color',colorMap(1:2,:),'position',[1 2]);
    xlim([0 5]);
    boxplot(auc2,'Color',colorMap(3:4,:),'position',[3 4]);
    
    ylabel('AUC');
    title('AUC of Events');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(Gl_CCK_BL_superEvents.auc)')
        scatter(ones(length(vertcat(Gl_CCK_BL_superEvents(idot).auc)'),1), vertcat(Gl_CCK_BL_superEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCK_CNO_superEvents.auc)')
        scatter(2*ones(length(vertcat(Gl_CCK_CNO_superEvents(idot).auc)'),1), vertcat(Gl_CCK_CNO_superEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_BL_superEvents.auc)')
        scatter(3*ones(length(vertcat(Gl_CCKAD_BL_superEvents(idot).auc)'),1), vertcat(Gl_CCKAD_BL_superEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_CNO_superEvents.auc)')
        scatter(4*ones(length(vertcat(Gl_CCKAD_CNO_superEvents(idot).auc)'),1), vertcat(Gl_CCKAD_CNO_superEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for i = 1:size(Gl_CCK_BL_superEvents,2)
        plot([1 2], [Gl_CCK_BL_superEvents(i).auc Gl_CCK_CNO_superEvents(i).auc],'Color',[0 0 0]+.8);
    end
    for i = 1:size(Gl_CCKAD_BL_superEvents,2)
        plot([3 4], [Gl_CCKAD_BL_superEvents(i).auc Gl_CCKAD_CNO_superEvents(i).auc],'Color',[0 0 0]+.8);
    end
    
    legend([lg1,lg2]);
    
        %ttest CCK BL vs CNO
    CCK_temp1 = vertcat(Gl_CCK_BL_superEvents.auc);
    CCK_temp1 = CCK_temp1';
    CCK_temp2 = vertcat(Gl_CCK_CNO_superEvents.auc);
    CCK_temp2 = CCK_temp2';
    [~,p1]= ttest(CCK_temp1,CCK_temp2);
    % ttest CCKAD BL vs CNO
    CCK_temp3 = vertcat(Gl_CCKAD_BL_superEvents.auc);
    CCK_temp3 = CCK_temp3';
    CCK_temp4 = vertcat(Gl_CCKAD_CNO_superEvents.auc);
    CCK_temp4 = CCK_temp4';
    [~,p2]= ttest(CCK_temp3,CCK_temp4);
    
    XTickString{1} = ['$$\begin{array}{c}' ...
        'CCK' '\\'...
        'p=' num2str(round(p1,3)) '\\'...
        '\end{array}$$'];
    XTickString{2} = ['$$\begin{array}{c}' ...
        'CCKAD' '\\'...
        'p=' num2str(round(p2,3)) '\\'...
        '\end{array}$$'];
    x=[1.5 3.5];
    set(gca,'xtick',x,'XTickLabel',XTickString,'TickLabelInterpreter','latex');
    saveas(superFig2,[FIGURES thisMonth '_Boxplot_GliaEvents_Super.png']);
    savefig([FIGURES thisMonth '_Boxplot_GliaEvents_Super.fig']);
    clear timeFreq ptFreq ct amp auc;
    %% One big plot lareg events
    largeFig2 = figure;
    sgtitle({[thisMonth ': Large Calcium Events Astrocytes'],' '});
    %% Plot time Freq
    timeFreq(:,1) = vertcat(Gl_CCK_BL_largeEvents.timeFreq)';
    timeFreq(:,2) = vertcat(Gl_CCK_CNO_largeEvents.timeFreq)';
    tF1.max = max(timeFreq,[],'all');
    tF1.min = min(timeFreq,[],'all');
    timeFreq2(:,1) = vertcat(Gl_CCKAD_BL_largeEvents.timeFreq);
    timeFreq2(:,2) = vertcat(Gl_CCKAD_CNO_largeEvents.timeFreq);
    tF2.max = max(timeFreq2,[],'all');
    tF2.min = min(timeFreq2,[],'all');
    if tF1.min <= tF2.min
        ymin = tF1.min;
    else
        ymin = tF2.min
    end
    if tF1.max >= tF2.max
        ymax = tF1.max;
    else
        ymax = tF2.max;
    end
    subplot(1,2,1);
    %this is dumb but i just need a color matching legend
    lg1 = plot([100 200 300],[100 100 100],'Color',colorMap(1,:));
    hold on;
    lg2 = plot([100 200 300],[100 100 100],'Color',colorMap(2,:));
    lh = legend('Baseline','CNO');
    % don't make a legend for h2.
    % actual data
    boxplot(timeFreq,'Color',colorMap(1:2,:),'position',[1 2]);
    xlim([0 5]);
    boxplot(timeFreq2,'Color',colorMap(3:4,:),'position',[3 4]);
    
    ylabel('Frequency (Hz)');
    title('Frequency');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    
    for idot = 1:length(vertcat(Gl_CCK_BL_largeEvents.timeFreq)')
        scatter(ones(length(vertcat(Gl_CCK_BL_largeEvents(idot).timeFreq)'),1), vertcat(Gl_CCK_BL_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCK_CNO_largeEvents.timeFreq)')
        scatter(2*ones(length(vertcat(Gl_CCK_CNO_largeEvents(idot).timeFreq)'),1), vertcat(Gl_CCK_CNO_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_BL_largeEvents.timeFreq)')
        scatter(3*ones(length(vertcat(Gl_CCKAD_BL_largeEvents(idot).timeFreq)'),1), vertcat(Gl_CCKAD_BL_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_CNO_largeEvents.timeFreq)')
        scatter(4*ones(length(vertcat(Gl_CCKAD_CNO_largeEvents(idot).timeFreq)'),1), vertcat(Gl_CCKAD_CNO_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for i = 1:size(Gl_CCK_BL_largeEvents,2)
        plot([1 2], [Gl_CCK_BL_largeEvents(i).timeFreq Gl_CCK_CNO_largeEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    for i = 1:size(Gl_CCKAD_BL_largeEvents,2)
        plot([3 4], [Gl_CCKAD_BL_largeEvents(i).timeFreq Gl_CCKAD_CNO_largeEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    legend([lg1,lg2]);
        %ttest CCK BL vs CNO
    CCK_temp1 = vertcat(Gl_CCK_BL_largeEvents.timeFreq);
    CCK_temp1 = CCK_temp1';
    CCK_temp2 = vertcat(Gl_CCK_CNO_largeEvents.timeFreq);
    CCK_temp2 = CCK_temp2';
    [~,p1]= ttest(CCK_temp1,CCK_temp2);
    % ttest CCKAD BL vs CNO
    CCK_temp3 = vertcat(Gl_CCKAD_BL_largeEvents.timeFreq);
    CCK_temp3 = CCK_temp3';
    CCK_temp4 = vertcat(Gl_CCKAD_CNO_largeEvents.timeFreq);
    CCK_temp4 = CCK_temp4';
    [~,p2]= ttest(CCK_temp3,CCK_temp4);
    
    XTickString{1} = ['$$\begin{array}{c}' ...
        'CCK' '\\'...
        'p=' num2str(round(p1,3)) '\\'...
        '\end{array}$$'];
    XTickString{2} = ['$$\begin{array}{c}' ...
        'CCKAD' '\\'...
        'p=' num2str(round(p2,3)) '\\'...
        '\end{array}$$'];
    x=[1.5 3.5];
    set(gca,'xtick',x,'XTickLabel',XTickString,'TickLabelInterpreter','latex');
    %% auc
    auc(:,1) = vertcat(Gl_CCK_BL_largeEvents.auc)';
    auc(:,2) = vertcat(Gl_CCK_CNO_largeEvents.auc)';
    Yauc.max = max(auc,[],'all');
    Yauc.min = min(auc,[],'all');
    auc2(:,1) = vertcat(Gl_CCKAD_BL_largeEvents.auc);
    auc2(:,2) = vertcat(Gl_CCKAD_CNO_largeEvents.auc);
    Yauc2.max = max(auc2,[],'all');
    Yauc2.min = min(auc2,[],'all');
    if Yauc.min <= Yauc2.min
        ymin = Yauc.min;
    else
        ymin = Yauc2.min;
    end
    if Yauc.max >= Yauc2.max
        ymax = Yauc.max;
    else
        ymax = Yauc2.max;
    end
    subplot(1,2,2);
    %this is dumb but i just need a color matching legend
    lg1 = plot([100 200 300],[100 100 100],'Color',colorMap(1,:));
    hold on;
    lg2 = plot([100 200 300],[100 100 100],'Color',colorMap(2,:));
    lh = legend('Baseline','CNO');
    % don't make a legend for h2.
    % actual data
    boxplot(auc,'Color',colorMap(1:2,:),'position',[1 2]);
    xlim([0 5]);
    boxplot(auc2,'Color',colorMap(3:4,:),'position',[3 4]);
    
    ylabel('AUC');
    title('AUC of Events');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(Gl_CCK_BL_largeEvents.auc)')
        scatter(ones(length(vertcat(Gl_CCK_BL_largeEvents(idot).auc)'),1), vertcat(Gl_CCK_BL_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCK_CNO_largeEvents.auc)')
        scatter(2*ones(length(vertcat(Gl_CCK_CNO_largeEvents(idot).auc)'),1), vertcat(Gl_CCK_CNO_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_BL_largeEvents.auc)')
        scatter(3*ones(length(vertcat(Gl_CCKAD_BL_largeEvents(idot).auc)'),1), vertcat(Gl_CCKAD_BL_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_CNO_largeEvents.auc)')
        scatter(4*ones(length(vertcat(Gl_CCKAD_CNO_largeEvents(idot).auc)'),1), vertcat(Gl_CCKAD_CNO_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for i = 1:size(Gl_CCK_BL_largeEvents,2)
        plot([1 2], [Gl_CCK_BL_largeEvents(i).auc Gl_CCK_CNO_largeEvents(i).auc],'Color',[0 0 0]+.8);
    end
    for i = 1:size(Gl_CCKAD_BL_largeEvents,2)
        plot([3 4], [Gl_CCKAD_BL_largeEvents(i).auc Gl_CCKAD_CNO_largeEvents(i).auc],'Color',[0 0 0]+.8);
    end
    
    legend([lg1,lg2]);
        %ttest CCK BL vs CNO
    CCK_temp1 = vertcat(Gl_CCK_BL_largeEvents.auc);
    CCK_temp1 = CCK_temp1';
    CCK_temp2 = vertcat(Gl_CCK_CNO_largeEvents.auc);
    CCK_temp2 = CCK_temp2';
    [~,p1]= ttest(CCK_temp1,CCK_temp2);
    % ttest CCKAD BL vs CNO
    CCK_temp3 = vertcat(Gl_CCKAD_BL_largeEvents.auc);
    CCK_temp3 = CCK_temp3';
    CCK_temp4 = vertcat(Gl_CCKAD_CNO_largeEvents.auc);
    CCK_temp4 = CCK_temp4';
    [~,p2]= ttest(CCK_temp3,CCK_temp4);
    
    XTickString{1} = ['$$\begin{array}{c}' ...
        'CCK' '\\'...
        'p=' num2str(round(p1,3)) '\\'...
        '\end{array}$$'];
    XTickString{2} = ['$$\begin{array}{c}' ...
        'CCKAD' '\\'...
        'p=' num2str(round(p2,3)) '\\'...
        '\end{array}$$'];
    x=[1.5 3.5];
    set(gca,'xtick',x,'XTickLabel',XTickString,'TickLabelInterpreter','latex');
    
    saveas(largeFig2,[FIGURES thisMonth '_Boxplot_GliaEvents_Large.png']);
    savefig([FIGURES thisMonth '_Boxplot_GliaEvents_Large.fig']);
    clear timeFreq ptFreq ct amp auc;
    %% One big plot for small events
    smallFig2 = figure;
    sgtitle({[thisMonth ': Small Calcium Events Astrocytes'],' '});
    %% Plot time Freq
    timeFreq(:,1) = vertcat(Gl_CCK_BL_smallEvents.timeFreq)';
    timeFreq(:,2) = vertcat(Gl_CCK_CNO_smallEvents.timeFreq)';
    timeFreq2(:,1) = vertcat(Gl_CCKAD_BL_smallEvents.timeFreq);
    timeFreq2(:,2) = vertcat(Gl_CCKAD_CNO_smallEvents.timeFreq);
    tF1.max = max(timeFreq,[],'all');
    tF1.min = min(timeFreq,[],'all');
    tF2.max = max(timeFreq2,[],'all');
    tF2.min = min(timeFreq2,[],'all');
    if tF1.min <= tF2.min
        ymin = tF1.min;
    else
        ymin = tF2.min
    end
    if tF1.max >= tF2.max
        ymax = tF1.max;
    else
        ymax = tF2.max;
    end
    subplot(1,2,1);
    %this is dumb but i just need a color matching legend
    lg1 = plot([100 200 300],[100 100 100],'Color',colorMap(1,:));
    hold on;
    lg2 = plot([100 200 300],[100 100 100],'Color',colorMap(2,:));
    lh = legend('Baseline','CNO');
    % don't make a legend for h2.
    % actual data
    boxplot(timeFreq,'Color',colorMap(1:2,:),'position',[1 2]);
    xlim([0 5]);
    boxplot(timeFreq2,'Color',colorMap(3:4,:),'position',[3 4]);
    
    ylabel('Frequency (Hz)');
    title('Frequency');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(Gl_CCK_BL_smallEvents.timeFreq)')
        scatter(ones(length(vertcat(Gl_CCK_BL_smallEvents(idot).timeFreq)'),1), vertcat(Gl_CCK_BL_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCK_CNO_smallEvents.timeFreq)')
        scatter(2*ones(length(vertcat(Gl_CCK_CNO_smallEvents(idot).timeFreq)'),1), vertcat(Gl_CCK_CNO_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_BL_smallEvents.timeFreq)')
        scatter(3*ones(length(vertcat(Gl_CCKAD_BL_smallEvents(idot).timeFreq)'),1), vertcat(Gl_CCKAD_BL_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_CNO_smallEvents.timeFreq)')
        scatter(4*ones(length(vertcat(Gl_CCKAD_CNO_smallEvents(idot).timeFreq)'),1), vertcat(Gl_CCKAD_CNO_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for i = 1:size(Gl_CCK_BL_smallEvents,2)
        plot([1 2], [Gl_CCK_BL_smallEvents(i).timeFreq Gl_CCK_CNO_smallEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    for i = 1:size(Gl_CCKAD_BL_smallEvents,2)
        plot([3 4], [Gl_CCKAD_BL_smallEvents(i).timeFreq Gl_CCKAD_CNO_smallEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    
    legend([lg1,lg2]);
        %ttest CCK BL vs CNO
    CCK_temp1 = vertcat(Gl_CCK_BL_smallEvents.timeFreq);
    CCK_temp1 = CCK_temp1';
    CCK_temp2 = vertcat(Gl_CCK_CNO_smallEvents.timeFreq);
    CCK_temp2 = CCK_temp2';
    [~,p1]= ttest(CCK_temp1,CCK_temp2);
    % ttest CCKAD BL vs CNO
    CCK_temp3 = vertcat(Gl_CCKAD_BL_smallEvents.timeFreq);
    CCK_temp3 = CCK_temp3';
    CCK_temp4 = vertcat(Gl_CCKAD_CNO_smallEvents.timeFreq);
    CCK_temp4 = CCK_temp4';
    [~,p2]= ttest(CCK_temp3,CCK_temp4);
    
    XTickString{1} = ['$$\begin{array}{c}' ...
        'CCK' '\\'...
        'p=' num2str(round(p1,3)) '\\'...
        '\end{array}$$'];
    XTickString{2} = ['$$\begin{array}{c}' ...
        'CCKAD' '\\'...
        'p=' num2str(round(p2,3)) '\\'...
        '\end{array}$$'];
    x=[1.5 3.5];
    set(gca,'xtick',x,'XTickLabel',XTickString,'TickLabelInterpreter','latex');
    %% auc
    auc(:,1) = vertcat(Gl_CCK_BL_smallEvents.auc)';
    auc(:,2) = vertcat(Gl_CCK_CNO_smallEvents.auc)';
    auc2(:,1) = vertcat(Gl_CCKAD_BL_smallEvents.auc);
    auc2(:,2) = vertcat(Gl_CCKAD_CNO_smallEvents.auc);
    Yauc.max = max(auc,[],'all');
    Yauc.min = min(auc,[],'all');
    Yauc2.max = max(auc2,[],'all');
    Yauc2.min = min(auc2,[],'all');
    if Yauc.min <= Yauc2.min
        ymin = Yauc.min;
    else
        ymin = Yauc2.min;
    end
    if Yauc.max >= Yauc2.max
        ymax = Yauc.max;
    else
        ymax = Yauc2.max;
    end
    subplot(1,2,2);
    %this is dumb but i just need a color matching legend
    lg1 = plot([100 200 300],[100 100 100],'Color',colorMap(1,:));
    hold on;
    lg2 = plot([100 200 300],[100 100 100],'Color',colorMap(2,:));
    lh = legend('Baseline','CNO');
    % don't make a legend for h2.
    % actual data
    boxplot(auc,'Color',colorMap(1:2,:),'position',[1 2]);
    xlim([0 5]);
    boxplot(auc2,'Color',colorMap(3:4,:),'position',[3 4]);
    
    ylabel('AUC');
    title('AUC of Events');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(Gl_CCK_BL_smallEvents.auc)')
        scatter(ones(length(vertcat(Gl_CCK_BL_smallEvents(idot).auc)'),1), vertcat(Gl_CCK_BL_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCK_CNO_smallEvents.auc)')
        scatter(2*ones(length(vertcat(Gl_CCK_CNO_smallEvents(idot).auc)'),1), vertcat(Gl_CCK_CNO_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_BL_smallEvents.auc)')
        scatter(3*ones(length(vertcat(Gl_CCKAD_BL_smallEvents(idot).auc)'),1), vertcat(Gl_CCKAD_BL_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_CNO_smallEvents.auc)')
        scatter(4*ones(length(vertcat(Gl_CCKAD_CNO_smallEvents(idot).auc)'),1), vertcat(Gl_CCKAD_CNO_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO2(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for i = 1:size(Gl_CCK_BL_smallEvents,2)
        plot([1 2], [Gl_CCK_BL_smallEvents(i).auc Gl_CCK_CNO_smallEvents(i).auc],'Color',[0 0 0]+.8);
    end
    for i = 1:size(Gl_CCKAD_BL_smallEvents,2)
        plot([3 4], [Gl_CCKAD_BL_smallEvents(i).auc Gl_CCKAD_CNO_smallEvents(i).auc],'Color',[0 0 0]+.8);
    end
    
    legend([lg1,lg2]);
    
        %ttest CCK BL vs CNO
    CCK_temp1 = vertcat(Gl_CCK_BL_smallEvents.auc);
    CCK_temp1 = CCK_temp1';
    CCK_temp2 = vertcat(Gl_CCK_CNO_smallEvents.auc);
    CCK_temp2 = CCK_temp2';
    [~,p1]= ttest(CCK_temp1,CCK_temp2);
    % ttest CCKAD BL vs CNO
    CCK_temp3 = vertcat(Gl_CCKAD_BL_smallEvents.auc);
    CCK_temp3 = CCK_temp3';
    CCK_temp4 = vertcat(Gl_CCKAD_CNO_smallEvents.auc);
    CCK_temp4 = CCK_temp4';
    [~,p2]= ttest(CCK_temp3,CCK_temp4);
    
    XTickString{1} = ['$$\begin{array}{c}' ...
        'CCK' '\\'...
        'p=' num2str(round(p1,3)) '\\'...
        '\end{array}$$'];
    XTickString{2} = ['$$\begin{array}{c}' ...
        'CCKAD' '\\'...
        'p=' num2str(round(p2,3)) '\\'...
        '\end{array}$$'];
    x=[1.5 3.5];
    set(gca,'xtick',x,'XTickLabel',XTickString,'TickLabelInterpreter','latex');
    saveas(smallFig2,[FIGURES thisMonth '_Boxplot_GliaEvents_Small.png']);
    savefig([FIGURES thisMonth '_Boxplot_GliaEvents_Small.fig']);
    clear timeFreq ptFreq ct amp auc;
end %month

end
