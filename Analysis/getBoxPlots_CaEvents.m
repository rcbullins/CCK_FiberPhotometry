function getBoxPlots_CaEvents(MODELS,MONTHS, INDICATOR_FOLDER)


BASEPATH = 'C:\Users\rcbul\OneDrive - University of North Carolina at Chapel Hill\Song_Lab\';
CODE_REAGAN = [BASEPATH 'Code\'];
RAW_DATA = [BASEPATH 'Data\'];
ANALYZED_DATA= [BASEPATH 'Analyzed_Data\'];
FIGURES = [BASEPATH 'Figures\'];


groupModelBoxplots = 1;
if ~groupModelBoxplots
    for imonth = 1:length(MONTHS)
        thisMonth = MONTHS{imonth};
        for imodel = 1:length(MODELS)
            thisModel = MODELS{imodel};
            EVENT_BL = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\baseline_' thisModel '_groupEvents.mat'];
            EVENT_CNO = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\CNO_' thisModel '_groupEvents.mat'];
            %% Load Group Events
            load(EVENT_BL, 'groupEvents','smallGroupEvents');
            BL_largeEvents = groupEvents;
            BL_smallEvents = smallGroupEvents;
            load(EVENT_CNO, 'groupEvents','smallGroupEvents');
            CNO_largeEvents = groupEvents;
            CNO_smallEvents = smallGroupEvents;
            %% Color Map
            colorMap(1,:) = [0 0 1];
            colorMap(2,:) = [1 0 0];
            %% One big plot
            figure;
            sgtitle([thisMonth ': Large Events - ' thisModel ': Baseline vs CNO']);
            %% Plot time Freq
            timeFreq(:,1) = vertcat(BL_largeEvents.timeFreq)';
            timeFreq(:,2) = vertcat(CNO_largeEvents.timeFreq)';
            subplot(2,2,1);
            boxplot(timeFreq,'Color',colorMap);
            hold on;
            ylabel('Frequency (Events/sec)');
            title('Event Frequency');
            box off;
            xticklabels({'Baseline','CNO'});
            scatter(ones(length(vertcat(BL_largeEvents.timeFreq)'),1), vertcat(BL_largeEvents.timeFreq)');
            scatter(2*ones(length(vertcat(CNO_largeEvents.timeFreq)'),1), vertcat(CNO_largeEvents.timeFreq)');
            
            
            %% Plot point freq
            ptFreq(:,1) = vertcat(BL_largeEvents.ptFreq)';
            ptFreq(:,2) = vertcat(CNO_largeEvents.ptFreq)';
            subplot(2,2,2);
            boxplot(ptFreq,'Color',colorMap);
            hold on;
            ylabel('Frequency (Events/samples)');
            title('Event Frequency Samples');
            box off;
            xticklabels({'Baseline','CNO'});
            scatter(ones(length(vertcat(BL_largeEvents.ptFreq)'),1), vertcat(BL_largeEvents.ptFreq)');
            scatter(2*ones(length(vertcat(CNO_largeEvents.ptFreq)'),1), vertcat(CNO_largeEvents.ptFreq)');
            
            %% Plot count
            ct(:,1) = vertcat(BL_largeEvents.ct)';
            ct(:,2) = vertcat(CNO_largeEvents.ct)';
            subplot(2,2,3);
            boxplot(ct,'Color',colorMap);
            hold on;
            ylabel('Count');
            title('Number of Events');
            box off;
            xticklabels({'Baseline','CNO'});
            scatter(ones(length(vertcat(BL_largeEvents.ct)'),1), vertcat(BL_largeEvents.ct)');
            scatter(2*ones(length(vertcat(CNO_largeEvents.ct)'),1), vertcat(CNO_largeEvents.ct)');
            
            %% Plot auc
            auc(:,1) = vertcat(BL_largeEvents.auc)';
            auc(:,2) = vertcat(CNO_largeEvents.auc)';
            subplot(2,2,4);
            boxplot(auc,'Color',colorMap);
            hold on;
            ylabel('AUC');
            title('AUC of Events');
            box off;
            xticklabels({'Baseline','CNO'});
            scatter(ones(length(vertcat(BL_largeEvents.auc)'),1), vertcat(BL_largeEvents.auc)');
            scatter(2*ones(length(vertcat(CNO_largeEvents.auc)'),1), vertcat(CNO_largeEvents.auc)');
            
            %% Plot amplitudes
            %         amp(:,1) = vertcat(groupEventsBL.amp)';
            %         amp(:,2) = vertcat(groupEventsCNO.amp)';
            %         figure;
            %         boxplot(amp,'Color',colorMap);
            %         ylabel('Amplitude');
            %         title({'Event Amplitude', [thisModel ': Baseline vs CNO']});
            %         box off;
            %         xticklabels({'Baseline','CNO'});
            clear timeFreq ptFreq ct amp auc;
            %% One big plot for small events
            figure;
            sgtitle([thisMonth ': Small Events - ' thisModel ': Baseline vs CNO']);
            %% Plot time Freq
            timeFreq(:,1) = vertcat(BL_smallEvents.timeFreq)';
            timeFreq(:,2) = vertcat(CNO_smallEvents.timeFreq)';
            subplot(2,2,1);
            boxplot(timeFreq,'Color',colorMap);
            hold on;
            ylabel('Frequency (Events/sec)');
            title('Event Frequency');
            box off;
            xticklabels({'Baseline','CNO'});
            scatter(ones(length(vertcat(BL_smallEvents.timeFreq)'),1), vertcat(BL_smallEvents.timeFreq)');
            scatter(2*ones(length(vertcat(CNO_smallEvents.timeFreq)'),1), vertcat(CNO_smallEvents.timeFreq)');
            
            %% Plot point freq
            ptFreq(:,1) = vertcat(BL_smallEvents.ptFreq)';
            ptFreq(:,2) = vertcat(CNO_smallEvents.ptFreq)';
            subplot(2,2,2);
            boxplot(ptFreq,'Color',colorMap);
            hold on;
            ylabel('Frequency (Events/samples)');
            title('Event Frequency Samples');
            box off;
            xticklabels({'Baseline','CNO'});
            scatter(ones(length(vertcat(BL_smallEvents.ptFreq)'),1), vertcat(BL_smallEvents.ptFreq)');
            scatter(2*ones(length(vertcat(CNO_smallEvents.ptFreq)'),1), vertcat(CNO_smallEvents.ptFreq)');
            
            %% Plot count
            ct(:,1) = vertcat(BL_smallEvents.ct)';
            ct(:,2) = vertcat(CNO_smallEvents.ct)';
            subplot(2,2,3);
            boxplot(ct,'Color',colorMap);
            hold on;
            ylabel('Count');
            title('Number of Events');
            box off;
            xticklabels({'Baseline','CNO'});
            scatter(ones(length(vertcat(BL_smallEvents.ct)'),1), vertcat(BL_smallEvents.ct)');
            scatter(2*ones(length(vertcat(CNO_smallEvents.ct)'),1), vertcat(CNO_smallEvents.ct)');
            
            %% Plot auc
            auc(:,1) = vertcat(BL_smallEvents.auc)';
            auc(:,2) = vertcat(CNO_smallEvents.auc)';
            subplot(2,2,4);
            boxplot(auc,'Color',colorMap);
            hold on;
            ylabel('AUC');
            title('AUC of Events');
            box off;
            xticklabels({'Baseline','CNO'});
            scatter(ones(length(vertcat(BL_smallEvents.auc)'),1), vertcat(BL_smallEvents.auc)');
            scatter(2*ones(length(vertcat(CNO_smallEvents.auc)'),1), vertcat(CNO_smallEvents.auc)');
            clear timeFreq ptFreq ct amp auc;
        end %model
    end %month
elseif groupModelBoxplots
    for imonth = 1:length(MONTHS)
        thisMonth = MONTHS{imonth};
        
        CCK_EVENT_BL = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\baseline_CCK_groupEvents.mat'];
        CCK_EVENT_CNO = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\CNO_CCK_groupEvents.mat'];
        CCKAD_EVENT_BL = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\baseline_CCKAD_groupEvents.mat'];
        CCKAD_EVENT_CNO = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\CNO_CCKAD_groupEvents.mat'];
        
        %% Load Group Events
        load(CCK_EVENT_BL, 'groupEvents','smallGroupEvents');
        CCK_BL_largeEvents = groupEvents;
        CCK_BL_smallEvents = smallGroupEvents;
        load(CCK_EVENT_CNO, 'groupEvents','smallGroupEvents');
        CCK_CNO_largeEvents = groupEvents;
        CCK_CNO_smallEvents = smallGroupEvents;
        load(CCKAD_EVENT_BL, 'groupEvents','smallGroupEvents');
        CCKAD_BL_largeEvents = groupEvents;
        CCKAD_BL_smallEvents = smallGroupEvents;
        load(CCKAD_EVENT_CNO, 'groupEvents','smallGroupEvents');
        CCKAD_CNO_largeEvents = groupEvents;
        CCKAD_CNO_smallEvents = smallGroupEvents;
        %% Color Map
        colorMap(1,:) = [0 0 1];
        colorMap(2,:) = [1 0 0];
        colorMap(3,:) = [0 0 1];
        colorMap(4,:) = [1 0 0];
        %% One big plot lareg events
        figure;
        sgtitle({[thisMonth ': Large Calcium Events CCK vs CCKAD'],' '});
        %% Plot time Freq
        timeFreq(:,1) = vertcat(CCK_BL_largeEvents.timeFreq)';
        timeFreq(:,2) = vertcat(CCK_CNO_largeEvents.timeFreq)';
        tF1.max = max(timeFreq,[],'all');
        tF1.min = min(timeFreq,[],'all');
        timeFreq2(:,1) = vertcat(CCKAD_BL_largeEvents.timeFreq);
        timeFreq2(:,2) = vertcat(CCKAD_CNO_largeEvents.timeFreq);
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
        
        scatter(ones(length(vertcat(CCK_BL_largeEvents.timeFreq)'),1), vertcat(CCK_BL_largeEvents.timeFreq)',[],colorMap(1,:));
        scatter(2*ones(length(vertcat(CCK_CNO_largeEvents.timeFreq)'),1), vertcat(CCK_CNO_largeEvents.timeFreq)',[],colorMap(2,:));
        scatter(3*ones(length(vertcat(CCKAD_BL_largeEvents.timeFreq)'),1), vertcat(CCKAD_BL_largeEvents.timeFreq)',[],colorMap(3,:));
        scatter(4*ones(length(vertcat(CCKAD_CNO_largeEvents.timeFreq)'),1), vertcat(CCKAD_CNO_largeEvents.timeFreq)',[],colorMap(4,:));
        
        legend([lg1,lg2]);
        %% auc
        auc(:,1) = vertcat(CCK_BL_largeEvents.auc)';
        auc(:,2) = vertcat(CCK_CNO_largeEvents.auc)';
        Yauc.max = max(auc,[],'all');
        Yauc.min = min(auc,[],'all');
        auc2(:,1) = vertcat(CCKAD_BL_largeEvents.auc);
        auc2(:,2) = vertcat(CCKAD_CNO_largeEvents.auc);
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
        
        scatter(ones(length(vertcat(CCK_BL_largeEvents.auc)'),1), vertcat(CCK_BL_largeEvents.auc)',[],colorMap(1,:));
        scatter(2*ones(length(vertcat(CCK_CNO_largeEvents.auc)'),1), vertcat(CCK_CNO_largeEvents.auc)',[],colorMap(2,:));
        scatter(3*ones(length(vertcat(CCKAD_BL_largeEvents.auc)'),1), vertcat(CCKAD_BL_largeEvents.auc)',[],colorMap(3,:));
        scatter(4*ones(length(vertcat(CCKAD_CNO_largeEvents.auc)'),1), vertcat(CCKAD_CNO_largeEvents.auc)',[],colorMap(4,:));
        
        legend([lg1,lg2]);
        clear timeFreq ptFreq ct amp auc;
        %% One big plot for small events
        figure;
        sgtitle({[thisMonth ': Small Calcium Events CCK vs CCKAD'],' '});
        %% Plot time Freq
        timeFreq(:,1) = vertcat(CCK_BL_smallEvents.timeFreq)';
        timeFreq(:,2) = vertcat(CCK_CNO_smallEvents.timeFreq)';
        timeFreq2(:,1) = vertcat(CCKAD_BL_smallEvents.timeFreq);
        timeFreq2(:,2) = vertcat(CCKAD_CNO_smallEvents.timeFreq);
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
        
        scatter(ones(length(vertcat(CCK_BL_smallEvents.timeFreq)'),1), vertcat(CCK_BL_smallEvents.timeFreq)',[],colorMap(1,:));
        scatter(2*ones(length(vertcat(CCK_CNO_smallEvents.timeFreq)'),1), vertcat(CCK_CNO_smallEvents.timeFreq)',[],colorMap(2,:));
        scatter(3*ones(length(vertcat(CCKAD_BL_smallEvents.timeFreq)'),1), vertcat(CCKAD_BL_smallEvents.timeFreq)',[],colorMap(3,:));
        scatter(4*ones(length(vertcat(CCKAD_CNO_smallEvents.timeFreq)'),1), vertcat(CCKAD_CNO_smallEvents.timeFreq)',[],colorMap(4,:));
        
        legend([lg1,lg2]);
        %% auc
        auc(:,1) = vertcat(CCK_BL_smallEvents.auc)';
        auc(:,2) = vertcat(CCK_CNO_smallEvents.auc)';
        auc2(:,1) = vertcat(CCKAD_BL_smallEvents.auc);
        auc2(:,2) = vertcat(CCKAD_CNO_smallEvents.auc);
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
        
        scatter(ones(length(vertcat(CCK_BL_smallEvents.auc)'),1), vertcat(CCK_BL_smallEvents.auc)',[],colorMap(1,:));
        scatter(2*ones(length(vertcat(CCK_CNO_smallEvents.auc)'),1), vertcat(CCK_CNO_smallEvents.auc)',[],colorMap(2,:));
        scatter(3*ones(length(vertcat(CCKAD_BL_smallEvents.auc)'),1), vertcat(CCKAD_BL_smallEvents.auc)',[],colorMap(3,:));
        scatter(4*ones(length(vertcat(CCKAD_CNO_smallEvents.auc)'),1), vertcat(CCKAD_CNO_smallEvents.auc)',[],colorMap(4,:));
        
        legend([lg1,lg2]);
        clear timeFreq ptFreq ct amp auc;
    end %month
    
end
end