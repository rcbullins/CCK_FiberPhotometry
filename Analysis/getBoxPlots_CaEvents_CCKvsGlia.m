function getBoxPlots_CaEvents_CCKvsGlia(MODELS,MONTHS,INDICATOR_FOLDER)
% Makes box plots compring glia vs cck neurons activity
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
    load(CCK_EVENT_BL, 'groupEvents','smallGroupEvents');
    numSessions = size(groupEvents,2);
    chan1_idx = 1:2:numSessions; % Neurons
    chan2_idx = 2:2:numSessions; % Glia
    IN_CCK_BL_largeEvents = groupEvents(chan1_idx);
    IN_CCK_BL_smallEvents = smallGroupEvents(chan1_idx);
    Gl_CCK_BL_largeEvents = groupEvents(chan2_idx);
    Gl_CCK_BL_smallEvents = smallGroupEvents(chan2_idx);
    load(CCK_EVENT_CNO, 'groupEvents','smallGroupEvents');
    numSessions = size(groupEvents,2);
    chan1_idx = 1:2:numSessions; % Neurons
    chan2_idx = 2:2:numSessions; % Glia
    IN_CCK_CNO_largeEvents = groupEvents(chan1_idx);
    IN_CCK_CNO_smallEvents = smallGroupEvents(chan1_idx);
    Gl_CCK_CNO_largeEvents = groupEvents(chan2_idx);
    Gl_CCK_CNO_smallEvents = smallGroupEvents(chan2_idx);
    load(CCKAD_EVENT_BL, 'groupEvents','smallGroupEvents');
    numSessions = size(groupEvents,2);
    chan1_idx = 1:2:numSessions; % Neurons
    chan2_idx = 2:2:numSessions; % Glia
    IN_CCKAD_BL_largeEvents = groupEvents(chan1_idx);
    IN_CCKAD_BL_smallEvents = smallGroupEvents(chan1_idx);
    Gl_CCKAD_BL_largeEvents = groupEvents(chan2_idx);
    Gl_CCKAD_BL_smallEvents = smallGroupEvents(chan2_idx);
    load(CCKAD_EVENT_CNO, 'groupEvents','smallGroupEvents');
    numSessions = size(groupEvents,2);
    chan1_idx = 1:2:numSessions; % Neurons
    chan2_idx = 2:2:numSessions; % Glia
    IN_CCKAD_CNO_largeEvents = groupEvents(chan1_idx);
    IN_CCKAD_CNO_smallEvents = smallGroupEvents(chan1_idx);
    Gl_CCKAD_CNO_largeEvents = groupEvents(chan2_idx);
    Gl_CCKAD_CNO_smallEvents = smallGroupEvents(chan2_idx);
    %% Color Map
    colorMap(1,:) = [0 0 1];
    colorMap(2,:) = [1 0 0];
    colorMap(3,:) = [0 0 1];
    colorMap(4,:) = [1 0 0];
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
    
    scatter(ones(length(vertcat(IN_CCK_BL_largeEvents.timeFreq)'),1), vertcat(IN_CCK_BL_largeEvents.timeFreq)',[],colorMap(1,:));
    scatter(2*ones(length(vertcat(IN_CCK_CNO_largeEvents.timeFreq)'),1), vertcat(IN_CCK_CNO_largeEvents.timeFreq)',[],colorMap(2,:));
    scatter(3*ones(length(vertcat(IN_CCKAD_BL_largeEvents.timeFreq)'),1), vertcat(IN_CCKAD_BL_largeEvents.timeFreq)',[],colorMap(3,:));
    scatter(4*ones(length(vertcat(IN_CCKAD_CNO_largeEvents.timeFreq)'),1), vertcat(IN_CCKAD_CNO_largeEvents.timeFreq)',[],colorMap(4,:));
    
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
    
    scatter(ones(length(vertcat(Gl_CCK_BL_largeEvents.timeFreq)'),1), vertcat(Gl_CCK_BL_largeEvents.timeFreq)',[],colorMap(1,:));
    scatter(2*ones(length(vertcat(Gl_CCK_CNO_largeEvents.timeFreq)'),1), vertcat(Gl_CCK_CNO_largeEvents.timeFreq)',[],colorMap(2,:));
    scatter(3*ones(length(vertcat(Gl_CCKAD_BL_largeEvents.timeFreq)'),1), vertcat(Gl_CCKAD_BL_largeEvents.timeFreq)',[],colorMap(3,:));
    scatter(4*ones(length(vertcat(Gl_CCKAD_CNO_largeEvents.timeFreq)'),1), vertcat(Gl_CCKAD_CNO_largeEvents.timeFreq)',[],colorMap(4,:));
    
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
    
    scatter(ones(length(vertcat(IN_CCK_BL_largeEvents.auc)'),1), vertcat(IN_CCK_BL_largeEvents.auc)',[],colorMap(1,:));
    scatter(2*ones(length(vertcat(IN_CCK_CNO_largeEvents.auc)'),1), vertcat(IN_CCK_CNO_largeEvents.auc)',[],colorMap(2,:));
    scatter(3*ones(length(vertcat(IN_CCKAD_BL_largeEvents.auc)'),1), vertcat(IN_CCKAD_BL_largeEvents.auc)',[],colorMap(3,:));
    scatter(4*ones(length(vertcat(IN_CCKAD_CNO_largeEvents.auc)'),1), vertcat(IN_CCKAD_CNO_largeEvents.auc)',[],colorMap(4,:));
    
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
    
    scatter(ones(length(vertcat(Gl_CCK_BL_largeEvents.auc)'),1), vertcat(Gl_CCK_BL_largeEvents.auc)',[],colorMap(1,:));
    scatter(2*ones(length(vertcat(Gl_CCK_CNO_largeEvents.auc)'),1), vertcat(Gl_CCK_CNO_largeEvents.auc)',[],colorMap(2,:));
    scatter(3*ones(length(vertcat(Gl_CCKAD_BL_largeEvents.auc)'),1), vertcat(Gl_CCKAD_BL_largeEvents.auc)',[],colorMap(3,:));
    scatter(4*ones(length(vertcat(Gl_CCKAD_CNO_largeEvents.auc)'),1), vertcat(Gl_CCKAD_CNO_largeEvents.auc)',[],colorMap(4,:));
    
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
    
    scatter(ones(length(vertcat(IN_CCK_BL_smallEvents.timeFreq)'),1), vertcat(IN_CCK_BL_smallEvents.timeFreq)',[],colorMap(1,:));
    scatter(2*ones(length(vertcat(IN_CCK_CNO_smallEvents.timeFreq)'),1), vertcat(IN_CCK_CNO_smallEvents.timeFreq)',[],colorMap(2,:));
    scatter(3*ones(length(vertcat(IN_CCKAD_BL_smallEvents.timeFreq)'),1), vertcat(IN_CCKAD_BL_smallEvents.timeFreq)',[],colorMap(3,:));
    scatter(4*ones(length(vertcat(IN_CCKAD_CNO_smallEvents.timeFreq)'),1), vertcat(IN_CCKAD_CNO_smallEvents.timeFreq)',[],colorMap(4,:));
    
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
    
    scatter(ones(length(vertcat(Gl_CCK_BL_smallEvents.timeFreq)'),1), vertcat(Gl_CCK_BL_smallEvents.timeFreq)',[],colorMap(1,:));
    scatter(2*ones(length(vertcat(Gl_CCK_CNO_smallEvents.timeFreq)'),1), vertcat(Gl_CCK_CNO_smallEvents.timeFreq)',[],colorMap(2,:));
    scatter(3*ones(length(vertcat(Gl_CCKAD_BL_smallEvents.timeFreq)'),1), vertcat(Gl_CCKAD_BL_smallEvents.timeFreq)',[],colorMap(3,:));
    scatter(4*ones(length(vertcat(Gl_CCKAD_CNO_smallEvents.timeFreq)'),1), vertcat(Gl_CCKAD_CNO_smallEvents.timeFreq)',[],colorMap(4,:));
    
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
    
    scatter(ones(length(vertcat(IN_CCK_BL_smallEvents.auc)'),1), vertcat(IN_CCK_BL_smallEvents.auc)',[],colorMap(1,:));
    scatter(2*ones(length(vertcat(IN_CCK_CNO_smallEvents.auc)'),1), vertcat(IN_CCK_CNO_smallEvents.auc)',[],colorMap(2,:));
    scatter(3*ones(length(vertcat(IN_CCKAD_BL_smallEvents.auc)'),1), vertcat(IN_CCKAD_BL_smallEvents.auc)',[],colorMap(3,:));
    scatter(4*ones(length(vertcat(IN_CCKAD_CNO_smallEvents.auc)'),1), vertcat(IN_CCKAD_CNO_smallEvents.auc)',[],colorMap(4,:));
    
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
    
    scatter(ones(length(vertcat(Gl_CCK_BL_smallEvents.auc)'),1), vertcat(Gl_CCK_BL_smallEvents.auc)',[],colorMap(1,:));
    scatter(2*ones(length(vertcat(Gl_CCK_CNO_smallEvents.auc)'),1), vertcat(Gl_CCK_CNO_smallEvents.auc)',[],colorMap(2,:));
    scatter(3*ones(length(vertcat(Gl_CCKAD_BL_smallEvents.auc)'),1), vertcat(Gl_CCKAD_BL_smallEvents.auc)',[],colorMap(3,:));
    scatter(4*ones(length(vertcat(Gl_CCKAD_CNO_smallEvents.auc)'),1), vertcat(Gl_CCKAD_CNO_smallEvents.auc)',[],colorMap(4,:));
    
    legend([lg1,lg2]);
    
    clear timeFreq ptFreq ct amp auc;
end %month

end

