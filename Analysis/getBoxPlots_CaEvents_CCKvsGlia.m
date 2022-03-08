function getBoxPlots_CaEvents_CCKvsGlia(MODELS,MONTHS,INDICATOR_FOLDER)
% PURPOSE
%     Get boxplots of large and small calcium events. Break up comparing BL
%     vs CNO recordings. Also color dots on boxplots as sex-specific
%     color.Specific for comparing Glia vs CCK neurons.
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
CODE_REAGAN = [BASEPATH 'Code\'];
RAW_DATA = [BASEPATH 'Data\'];
ANALYZED_DATA= [BASEPATH 'Analyzed_Data\'];
FIGURES = [BASEPATH 'Figures\'];

for imonth = 1:length(MONTHS)
    thisMonth = MONTHS{imonth};
    
    CCK_EVENT_BL = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\baseline_CCK_groupEvents.mat'];
    CCK_EVENT_CNO = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\CNO_CCK_groupEvents.mat'];
    CCKAD_EVENT_BL = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\baseline_CCKAD_groupEvents.mat'];
    CCKAD_EVENT_CNO = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\CNO_CCKAD_groupEvents.mat'];
    
    %% Load Group Events
    load(CCK_EVENT_BL, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
    numSessions = size(largeGroupEvents,2);
    chan1_idx = 1:2:numSessions; % Neurons
    chan2_idx = 2:2:numSessions; % Glia
    IN_CCK_BL_largeEvents = largeGroupEvents(chan1_idx);
    IN_CCK_BL_smallEvents = smallGroupEvents(chan1_idx);
    IN_CCK_BL_superEvents = superGroupEvents(chan1_idx);
    Gl_CCK_BL_largeEvents = largeGroupEvents(chan2_idx);
    Gl_CCK_BL_smallEvents = smallGroupEvents(chan2_idx);
    Gl_CCK_BL_superEvents = superGroupEvents(chan2_idx);
    load(CCK_EVENT_CNO, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
    numSessions = size(largeGroupEvents,2);
    chan1_idx = 1:2:numSessions; % Neurons
    chan2_idx = 2:2:numSessions; % Glia
    IN_CCK_CNO_largeEvents = largeGroupEvents(chan1_idx);
    IN_CCK_CNO_smallEvents = smallGroupEvents(chan1_idx);
    IN_CCK_CNO_superEvents = superGroupEvents(chan1_idx);
    Gl_CCK_CNO_largeEvents = largeGroupEvents(chan2_idx);
    Gl_CCK_CNO_smallEvents = smallGroupEvents(chan2_idx);
    Gl_CCK_CNO_superEvents = superGroupEvents(chan2_idx);
    load(CCKAD_EVENT_BL, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
    numSessions = size(largeGroupEvents,2);
    chan1_idx = 1:2:numSessions; % Neurons
    chan2_idx = 2:2:numSessions; % Glia
    IN_CCKAD_BL_largeEvents = largeGroupEvents(chan1_idx);
    IN_CCKAD_BL_smallEvents = smallGroupEvents(chan1_idx);
    IN_CCKAD_BL_superEvents = superGroupEvents(chan1_idx);
    Gl_CCKAD_BL_largeEvents = largeGroupEvents(chan2_idx);
    Gl_CCKAD_BL_smallEvents = smallGroupEvents(chan2_idx);
    Gl_CCKAD_BL_superEvents = superGroupEvents(chan2_idx);
    load(CCKAD_EVENT_CNO, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
    numSessions = size(largeGroupEvents,2);
    chan1_idx = 1:2:numSessions; % Neurons
    chan2_idx = 2:2:numSessions; % Glia
    IN_CCKAD_CNO_largeEvents = largeGroupEvents(chan1_idx);
    IN_CCKAD_CNO_smallEvents = smallGroupEvents(chan1_idx);
    IN_CCKAD_CNO_superEvents = superGroupEvents(chan1_idx);
    Gl_CCKAD_CNO_largeEvents = largeGroupEvents(chan2_idx);
    Gl_CCKAD_CNO_smallEvents = smallGroupEvents(chan2_idx);
    Gl_CCKAD_CNO_superEvents = superGroupEvents(chan2_idx);
    %% Color Map
    colorMap(1,:) = [0 0 1];
    colorMap(2,:) = [1 0 0];
    colorMap(3,:) = [0 0 1];
    colorMap(4,:) = [1 0 0];
    % Colors for sex difference (F vs M)
    colorSex_CCK_BL = zeros(sum(~cellfun(@isempty,{IN_CCK_BL_largeEvents.s})),3);
    colorSex_CCK_CNO = zeros(sum(~cellfun(@isempty,{IN_CCK_CNO_largeEvents.s})),3);
    colorSex_CCKAD_BL = zeros(sum(~cellfun(@isempty,{IN_CCKAD_BL_largeEvents.s})),3);
    colorSex_CCKAD_CNO = zeros(sum(~cellfun(@isempty,{IN_CCKAD_CNO_largeEvents.s})),3);
    % get color for dots of female vs male
    for i = 1:length(IN_CCK_BL_largeEvents)
        if strcmp(IN_CCK_BL_largeEvents(i).s,'f')
            colorSex_CCK_BL(i,:) = [0 0 0];
        elseif strcmp(IN_CCK_BL_largeEvents(i).s,'m')
            colorSex_CCK_BL(i,:) = [1 1 1];
        end
    end
    % get color for dots of female vs male
    for i = 1:length(IN_CCK_CNO_largeEvents)
        if strcmp(IN_CCK_CNO_largeEvents(i).s,'f')
            colorSex_CCK_CNO(i,:) = [0 0 0];
        elseif strcmp(IN_CCK_CNO_largeEvents(i).s,'m')
            colorSex_CCK_CNO(i,:) = [1 1 1];
        end
    end
    % get color for dots of female vs male
    for i = 1:length(IN_CCKAD_BL_largeEvents)
        if strcmp(IN_CCKAD_BL_largeEvents(i).s,'f')
            colorSex_CCKAD_BL(i,:) = [0 0 0];
        elseif strcmp(IN_CCKAD_BL_largeEvents(i).s,'m')
            colorSex_CCKAD_BL(i,:) = [1 1 1];
        end
    end
    % get color for dots of female vs male
    for i = 1:length(IN_CCKAD_CNO_largeEvents)
        if strcmp(IN_CCKAD_CNO_largeEvents(i).s,'f')
            colorSex_CCKAD_CNO(i,:) = [0 0 0];
        elseif strcmp(IN_CCKAD_CNO_largeEvents(i).s,'m')
            colorSex_CCKAD_CNO(i,:) = [1 1 1];
        end
    end
    
    %% One plot large event Frequency (Neuron vs Glia)
    figure;
    sgtitle({[thisMonth ': Large Calcium Events CCK vs CCKAD'],'Frequency'});
    % Plot Freq - Neurons
    timeFreq(:,1) = vertcat(IN_CCK_BL_largeEvents.timeFreq)';
    timeFreq(:,2) = vertcat(IN_CCK_CNO_largeEvents.timeFreq)';
    tF1.max = max(timeFreq,[],'all');
    tF1.min = min(timeFreq,[],'all');
    timeFreq2(:,1) = vertcat(IN_CCKAD_BL_largeEvents.timeFreq);
    timeFreq2(:,2) = vertcat(IN_CCKAD_CNO_largeEvents.timeFreq);
    tF2.max = max(timeFreq2,[],'all');
    tF2.min = min(timeFreq2,[],'all');
    if tF1.min <= tF2.min
        ymin = tF1.min;
    else
        ymin = tF2.min;
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
    title('CCK Neurons');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    
    for idot = 1:length(vertcat(IN_CCK_BL_largeEvents.timeFreq)')
        scatter(ones(length(vertcat(IN_CCK_BL_largeEvents(idot).timeFreq)'),1), vertcat(IN_CCK_BL_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(IN_CCK_CNO_largeEvents.timeFreq)')
        scatter(2*ones(length(vertcat(IN_CCK_CNO_largeEvents(idot).timeFreq)'),1), vertcat(IN_CCK_CNO_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(IN_CCKAD_BL_largeEvents.timeFreq)')
        scatter(3*ones(length(vertcat(IN_CCKAD_BL_largeEvents(idot).timeFreq)'),1), vertcat(IN_CCKAD_BL_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(IN_CCKAD_CNO_largeEvents.timeFreq)')
        scatter(4*ones(length(vertcat(IN_CCKAD_CNO_largeEvents(idot).timeFreq)'),1), vertcat(IN_CCKAD_CNO_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    % Add lines to boxplots connecting points
    for i = 1:size(IN_CCK_BL_largeEvents,2)
        plot([1 2], [IN_CCK_BL_largeEvents(i).timeFreq IN_CCK_CNO_largeEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    for i = 1:size(IN_CCKAD_BL_largeEvents,2)
        plot([3 4], [IN_CCKAD_BL_largeEvents(i).timeFreq IN_CCKAD_CNO_largeEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    legend([lg1,lg2]);
    %%%%%%%% Glia
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
        ymin = tF2.min;
    end
    if tF1.max >= tF2.max
        ymax = tF1.max;
    else
        ymax = tF2.max;
    end
    subplot(1,2,2);
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
    title('Glia');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(Gl_CCK_BL_largeEvents.timeFreq)')
        scatter(ones(length(vertcat(Gl_CCK_BL_largeEvents(idot).timeFreq)'),1), vertcat(Gl_CCK_BL_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCK_CNO_largeEvents.timeFreq)')
        scatter(2*ones(length(vertcat(Gl_CCK_CNO_largeEvents(idot).timeFreq)'),1), vertcat(Gl_CCK_CNO_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_BL_largeEvents.timeFreq)')
        scatter(3*ones(length(vertcat(Gl_CCKAD_BL_largeEvents(idot).timeFreq)'),1), vertcat(Gl_CCKAD_BL_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_CNO_largeEvents.timeFreq)')
        scatter(4*ones(length(vertcat(Gl_CCKAD_CNO_largeEvents(idot).timeFreq)'),1), vertcat(Gl_CCKAD_CNO_largeEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    % Add lines to boxplots connecting points
    for i = 1:size(Gl_CCK_BL_largeEvents,2)
        plot([1 2], [Gl_CCK_BL_largeEvents(i).timeFreq Gl_CCK_CNO_largeEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    for i = 1:size(Gl_CCKAD_BL_largeEvents,2)
        plot([3 4], [Gl_CCKAD_BL_largeEvents(i).timeFreq Gl_CCKAD_CNO_largeEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    legend([lg1,lg2]);
    %% AUC
    figure;
    sgtitle({[thisMonth ': Large Calcium Events CCK vs CCKAD'],'AUC'});
    % neurons
    auc(:,1) = vertcat(IN_CCK_BL_largeEvents.auc)';
    auc(:,2) = vertcat(IN_CCK_CNO_largeEvents.auc)';
    Yauc.max = max(auc,[],'all');
    Yauc.min = min(auc,[],'all');
    auc2(:,1) = vertcat(IN_CCKAD_BL_largeEvents.auc);
    auc2(:,2) = vertcat(IN_CCKAD_CNO_largeEvents.auc);
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
    subplot(1,2,1);
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
    title('CCK Neurons');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(IN_CCK_BL_largeEvents.auc)')
        scatter(ones(length(vertcat(IN_CCK_BL_largeEvents(idot).auc)'),1), vertcat(IN_CCK_BL_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(IN_CCK_CNO_largeEvents.auc)')
        scatter(2*ones(length(vertcat(IN_CCK_CNO_largeEvents(idot).auc)'),1), vertcat(IN_CCK_CNO_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(IN_CCKAD_BL_largeEvents.auc)')
        scatter(3*ones(length(vertcat(IN_CCKAD_BL_largeEvents(idot).auc)'),1), vertcat(IN_CCKAD_BL_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(IN_CCKAD_CNO_largeEvents.auc)')
        scatter(4*ones(length(vertcat(IN_CCKAD_CNO_largeEvents(idot).auc)'),1), vertcat(IN_CCKAD_CNO_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    % Add lines to boxplots connecting points
    for i = 1:size(IN_CCK_BL_largeEvents,2)
        plot([1 2], [IN_CCK_BL_largeEvents(i).auc IN_CCK_CNO_largeEvents(i).auc],'Color',[0 0 0]+.8);
    end
    for i = 1:size(IN_CCKAD_BL_largeEvents,2)
        plot([3 4], [IN_CCKAD_BL_largeEvents(i).auc IN_CCKAD_CNO_largeEvents(i).auc],'Color',[0 0 0]+.8);
    end
    legend([lg1,lg2]);
    % glia
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
    title('Glia');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(Gl_CCK_BL_largeEvents.auc)')
        scatter(ones(length(vertcat(Gl_CCK_BL_largeEvents(idot).auc)'),1), vertcat(Gl_CCK_BL_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCK_CNO_largeEvents.auc)')
        scatter(2*ones(length(vertcat(Gl_CCK_CNO_largeEvents(idot).auc)'),1), vertcat(Gl_CCK_CNO_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_BL_largeEvents.auc)')
        scatter(3*ones(length(vertcat(Gl_CCKAD_BL_largeEvents(idot).auc)'),1), vertcat(Gl_CCKAD_BL_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_CNO_largeEvents.auc)')
        scatter(4*ones(length(vertcat(Gl_CCKAD_CNO_largeEvents(idot).auc)'),1), vertcat(Gl_CCKAD_CNO_largeEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    % Add lines to boxplots connecting points
    for i = 1:size(IN_CCK_BL_largeEvents,2)
        plot([1 2], [Gl_CCK_BL_largeEvents(i).auc Gl_CCK_CNO_largeEvents(i).auc],'Color',[0 0 0]+.8);
    end
    for i = 1:size(IN_CCKAD_BL_largeEvents,2)
        plot([3 4], [Gl_CCKAD_BL_largeEvents(i).auc Gl_CCKAD_CNO_largeEvents(i).auc],'Color',[0 0 0]+.8);
    end
    legend([lg1,lg2]);
    
    clear timeFreq ptFreq ct amp auc;
    %% small events Frequency
    figure;
    sgtitle({[thisMonth ': Small Calcium Events CCK vs CCKAD'],'Frequency'});
    % Plot time Freq neurons
    timeFreq(:,1) = vertcat(IN_CCK_BL_smallEvents.timeFreq)';
    timeFreq(:,2) = vertcat(IN_CCK_CNO_smallEvents.timeFreq)';
    timeFreq2(:,1) = vertcat(IN_CCKAD_BL_smallEvents.timeFreq);
    timeFreq2(:,2) = vertcat(IN_CCKAD_CNO_smallEvents.timeFreq);
    tF1.max = max(timeFreq,[],'all');
    tF1.min = min(timeFreq,[],'all');
    tF2.max = max(timeFreq2,[],'all');
    tF2.min = min(timeFreq2,[],'all');
    if tF1.min <= tF2.min
        ymin = tF1.min;
    else
        ymin = tF2.min;
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
    title('CCK Neurons');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(IN_CCK_BL_smallEvents.timeFreq)')
        scatter(ones(length(vertcat(IN_CCK_BL_smallEvents(idot).timeFreq)'),1), vertcat(IN_CCK_BL_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(IN_CCK_CNO_smallEvents.timeFreq)')
        scatter(2*ones(length(vertcat(IN_CCK_CNO_smallEvents(idot).timeFreq)'),1), vertcat(IN_CCK_CNO_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(IN_CCKAD_BL_smallEvents.timeFreq)')
        scatter(3*ones(length(vertcat(IN_CCKAD_BL_smallEvents(idot).timeFreq)'),1), vertcat(IN_CCKAD_BL_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(IN_CCKAD_CNO_smallEvents.timeFreq)')
        scatter(4*ones(length(vertcat(IN_CCKAD_CNO_smallEvents(idot).timeFreq)'),1), vertcat(IN_CCKAD_CNO_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    % Add lines to boxplots connecting points
    for i = 1:size(IN_CCK_BL_smallEvents,2)
        plot([1 2], [IN_CCK_BL_smallEvents(i).timeFreq IN_CCK_CNO_smallEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    for i = 1:size(IN_CCKAD_BL_smallEvents,2)
        plot([3 4], [IN_CCKAD_BL_smallEvents(i).timeFreq IN_CCKAD_CNO_smallEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    legend([lg1,lg2]);
    % glia
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
        ymin = tF2.min;
    end
    if tF1.max >= tF2.max
        ymax = tF1.max;
    else
        ymax = tF2.max;
    end
    subplot(1,2,2);
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
    title('Glia');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(Gl_CCK_BL_smallEvents.timeFreq)')
        scatter(ones(length(vertcat(Gl_CCK_BL_smallEvents(idot).timeFreq)'),1), vertcat(Gl_CCK_BL_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCK_CNO_smallEvents.timeFreq)')
        scatter(2*ones(length(vertcat(Gl_CCK_CNO_smallEvents(idot).timeFreq)'),1), vertcat(Gl_CCK_CNO_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_BL_smallEvents.timeFreq)')
        scatter(3*ones(length(vertcat(Gl_CCKAD_BL_smallEvents(idot).timeFreq)'),1), vertcat(Gl_CCKAD_BL_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_CNO_smallEvents.timeFreq)')
        scatter(4*ones(length(vertcat(Gl_CCKAD_CNO_smallEvents(idot).timeFreq)'),1), vertcat(Gl_CCKAD_CNO_smallEvents(idot).timeFreq)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    % Add lines to boxplots connecting points
    for i = 1:size(Gl_CCK_BL_smallEvents,2)
        plot([1 2], [Gl_CCK_BL_smallEvents(i).timeFreq Gl_CCK_CNO_smallEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    for i = 1:size(IN_CCKAD_BL_smallEvents,2)
        plot([3 4], [Gl_CCKAD_BL_smallEvents(i).timeFreq Gl_CCKAD_CNO_smallEvents(i).timeFreq],'Color',[0 0 0]+.8);
    end
    legend([lg1,lg2]);
    %% auc - neurons vs glia
    figure;
    sgtitle({[thisMonth ': Small Calcium Events CCK vs CCKAD'],'AUC'});
    %neurons
    auc(:,1) = vertcat(IN_CCK_BL_smallEvents.auc)';
    auc(:,2) = vertcat(IN_CCK_CNO_smallEvents.auc)';
    auc2(:,1) = vertcat(IN_CCKAD_BL_smallEvents.auc);
    auc2(:,2) = vertcat(IN_CCKAD_CNO_smallEvents.auc);
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
    subplot(1,2,1);
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
    title('CCK Neurons');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(IN_CCK_BL_smallEvents.auc)')
        scatter(ones(length(vertcat(IN_CCK_BL_smallEvents(idot).auc)'),1), vertcat(IN_CCK_BL_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(IN_CCK_CNO_smallEvents.auc)')
        scatter(2*ones(length(vertcat(IN_CCK_CNO_smallEvents(idot).auc)'),1), vertcat(IN_CCK_CNO_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(IN_CCKAD_BL_smallEvents.auc)')
        scatter(3*ones(length(vertcat(IN_CCKAD_BL_smallEvents(idot).auc)'),1), vertcat(IN_CCKAD_BL_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(IN_CCKAD_CNO_smallEvents.auc)')
        scatter(4*ones(length(vertcat(IN_CCKAD_CNO_smallEvents(idot).auc)'),1), vertcat(IN_CCKAD_CNO_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    % Add lines to boxplots connecting points
    for i = 1:size(IN_CCK_BL_smallEvents,2)
        plot([1 2], [IN_CCK_BL_smallEvents(i).auc IN_CCK_CNO_smallEvents(i).auc],'Color',[0 0 0]+.8);
    end
    for i = 1:size(IN_CCKAD_BL_smallEvents,2)
        plot([3 4], [IN_CCKAD_BL_smallEvents(i).auc IN_CCKAD_CNO_smallEvents(i).auc],'Color',[0 0 0]+.8);
    end
    legend([lg1,lg2]);
    
    % glia
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
    title('Glia');
    box off;
    xticks([1.5 3.5]);
    xticklabels({'CCK','CCKAD'});
    xlim([0 5]);
    ylim([ymin ymax]);
    for idot = 1:length(vertcat(Gl_CCK_BL_smallEvents.auc)')
        scatter(ones(length(vertcat(Gl_CCK_BL_smallEvents(idot).auc)'),1), vertcat(Gl_CCK_BL_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCK_CNO_smallEvents.auc)')
        scatter(2*ones(length(vertcat(Gl_CCK_CNO_smallEvents(idot).auc)'),1), vertcat(Gl_CCK_CNO_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_BL_smallEvents.auc)')
        scatter(3*ones(length(vertcat(Gl_CCKAD_BL_smallEvents(idot).auc)'),1), vertcat(Gl_CCKAD_BL_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    for idot = 1:length(vertcat(Gl_CCKAD_CNO_smallEvents.auc)')
        scatter(4*ones(length(vertcat(Gl_CCKAD_CNO_smallEvents(idot).auc)'),1), vertcat(Gl_CCKAD_CNO_smallEvents(idot).auc)',[],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
            'MarkerFaceAlpha',0.2);
    end
    % Add lines to boxplots connecting points
    for i = 1:size(Gl_CCK_BL_smallEvents,2)
        plot([1 2], [Gl_CCK_BL_smallEvents(i).auc Gl_CCK_CNO_smallEvents(i).auc],'Color',[0 0 0]+.8);
    end
    for i = 1:size(IN_CCKAD_BL_smallEvents,2)
        plot([3 4], [Gl_CCKAD_BL_smallEvents(i).auc Gl_CCKAD_CNO_smallEvents(i).auc],'Color',[0 0 0]+.9);
    end
    legend([lg1,lg2]);
    
    clear timeFreq ptFreq ct amp auc;
end %month

end

