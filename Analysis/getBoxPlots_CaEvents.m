function getBoxPlots_CaEvents(MODELS,MONTHS, INDICATOR_FOLDER)
% PURPOSE
%     Get boxplots of large and small calcium events. Break up comparing BL
%     vs CNO recordings. Also color dots on boxplots as sex-specific color.
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


groupModelBoxplots = 1;
if ~groupModelBoxplots
    for imonth = 1:length(MONTHS)
        thisMonth = MONTHS{imonth};
        for imodel = 1:length(MODELS)
            thisModel = MODELS{imodel};
            EVENT_BL = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\baseline_' thisModel '_groupEvents.mat'];
            EVENT_CNO = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\CNO_' thisModel '_groupEvents.mat'];
            %% Load Group Events
            load(EVENT_BL, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
            BL_largeEvents = largeGroupEvents;
            BL_superEvents = superGroupEvents;
            BL_smallEvents = smallGroupEvents;
            load(EVENT_CNO, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
            CNO_largeEvents = largeGroupEvents;
            CNO_superEvents = superGroupEvents;
            CNO_smallEvents = smallGroupEvents;
            %% Color Map
            colorMap(1,:) = [0 0 1];
            colorMap(2,:) = [1 0 0];
            colorSex_BL = zeros(length(BL_largeEvents.s),3);
            colorSex_CNO = zeros(length(CNO_largeEvents.s),3);
            % get color for dots of female vs male
            for i = 1:length(BL_largeEvents)
                if strcmp(BL_largeEvents(i).s,'f')
                    colorSex_BL(i,:) = [0 0 0];
                elseif strcmp(BL_largeEvents(i).s,'m')
                    colorSex_BL(i,:) = [1 1 1];
                end
            end
                        % get color for dots of female vs male
            for i = 1:length(CNO_largeEvents)
                if strcmp(CNO_largeEvents(i).s,'f')
                    colorSex_CNO(i,:) = [0 0 0];
                elseif strcmp(CNO_largeEvents(i).s,'m')
                    colorSex_CNO(i,:) = [1 1 1];
                end
            end
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
            for idot = 1:length(vertcat(BL_largeEvents.timeFreq)')
            scatter(ones(length(vertcat(BL_largeEvents(idot).timeFreq)'),1), vertcat(BL_largeEvents(idot).timeFreq)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_BL(idot),...
                'MarkerFaceAlpha',0.2);
            end
            for idot = 1:length(vertcat(CNO_largeEvents.timeFreq)')
            scatter(2*ones(length(vertcat(CNO_largeEvents(idot).timeFreq)'),1), vertcat(CNO_largeEvents(idot).timeFreq)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            
            
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
            scatter(ones(length(vertcat(BL_largeEvents.ptFreq)'),1), vertcat(BL_largeEvents.ptFreq)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_BL,...
                'MarkerFaceAlpha',0.2);
            scatter(2*ones(length(vertcat(CNO_largeEvents.ptFreq)'),1), vertcat(CNO_largeEvents.ptFreq)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CNO,...
                'MarkerFaceAlpha',0.2);
            
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
            for idot = 1:length(vertcat(BL_largeEvents.ct)')
            scatter(ones(length(vertcat(BL_largeEvents(idot).ct)'),1), vertcat(BL_largeEvents(idot).ct)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            for idot = 1:length(vertcat(CNO_largeEvents.ct)')
            scatter(2*ones(length(vertcat(CNO_largeEvents(idot).ct)'),1), vertcat(CNO_largeEvents(idot).ct)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            
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
            for idot = 1:length(vertcat(BL_largeEvents.auc)')
            scatter(ones(length(vertcat(BL_largeEvents(idot).auc)'),1), vertcat(BL_largeEvents(idot).auc)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            for idot = 1:length(vertcat(CNO_largeEvents.auc)')
            scatter(2*ones(length(vertcat(CNO_largeEvents(idot).auc)'),1), vertcat(CNO_largeEvents(idot).auc)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            
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
            for idot = 1:length(vertcat(BL_smallEvents.timeFreq)')
            scatter(ones(length(vertcat(BL_smallEvents(idot).timeFreq)'),1), vertcat(BL_smallEvents(idot).timeFreq)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            for idot = 1:length(vertcat(CNO_smallEvents.timeFreq)')
            scatter(2*ones(length(vertcat(CNO_smallEvents(idot).timeFreq)'),1), vertcat(CNO_smallEvents(idot).timeFreq)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            
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
            for idot = 1:length(vertcat(BL_smallEvents.ptFreq)')
            scatter(ones(length(vertcat(BL_smallEvents(idot).ptFreq)'),1), vertcat(BL_smallEvents(idot).ptFreq)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            for idot = 1:length(vertcat(CNO_smallEvents.ptFreq)')
            scatter(2*ones(length(vertcat(CNO_smallEvents(idot).ptFreq)'),1), vertcat(CNO_smallEvents(idot).ptFreq)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
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
            for idot = 1:length(vertcat(BL_smallEvents.ct)')
            scatter(ones(length(vertcat(BL_smallEvents(idot).ct)'),1), vertcat(BL_smallEvents(idot).ct)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            for idot = 1:length(vertcat(CNO_smallEvents(idot).ct)')
            scatter(2*ones(length(vertcat(CNO_smallEvents(idot).ct)'),1), vertcat(CNO_smallEvents(idot).ct)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            
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
            for idot = 1:length(vertcat(BL_smallEvents.auc)')
            scatter(ones(length(vertcat(BL_smallEvents(idot).auc)'),1), vertcat(BL_smallEvents(idot).auc)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            for idot = 1:length(vertcat(CNO_smallEvents.auc)')
            scatter(2*ones(length(vertcat(CNO_smallEvents(idot).auc)'),1), vertcat(CNO_smallEvents(idot).auc)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            clear timeFreq ptFreq ct amp auc;
            
            %% One big plot for super events
            figure;
            sgtitle([thisMonth ': super Events - ' thisModel ': Baseline vs CNO']);
            %% Plot time Freq
            timeFreq(:,1) = vertcat(BL_superEvents.timeFreq)';
            timeFreq(:,2) = vertcat(CNO_superEvents.timeFreq)';
            subplot(2,2,1);
            boxplot(timeFreq,'Color',colorMap);
            hold on;
            ylabel('Frequency (Events/sec)');
            title('Event Frequency');
            box off;
            xticklabels({'Baseline','CNO'});
            for idot = 1:length(vertcat(BL_superEvents.timeFreq)')
            scatter(ones(length(vertcat(BL_superEvents(idot).timeFreq)'),1), vertcat(BL_superEvents(idot).timeFreq)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_BL(idot),...
                'MarkerFaceAlpha',0.2);
            end
            for idot = 1:length(vertcat(CNO_superEvents.timeFreq)')
            scatter(2*ones(length(vertcat(CNO_superEvents(idot).timeFreq)'),1), vertcat(CNO_superEvents(idot).timeFreq)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            
            
            %% Plot point freq
            ptFreq(:,1) = vertcat(BL_superEvents.ptFreq)';
            ptFreq(:,2) = vertcat(CNO_superEvents.ptFreq)';
            subplot(2,2,2);
            boxplot(ptFreq,'Color',colorMap);
            hold on;
            ylabel('Frequency (Events/samples)');
            title('Event Frequency Samples');
            box off;
            xticklabels({'Baseline','CNO'});
            scatter(ones(length(vertcat(BL_superEvents.ptFreq)'),1), vertcat(BL_superEvents.ptFreq)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_BL,...
                'MarkerFaceAlpha',0.2);
            scatter(2*ones(length(vertcat(CNO_superEvents.ptFreq)'),1), vertcat(CNO_superEvents.ptFreq)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CNO,...
                'MarkerFaceAlpha',0.2);
            
            %% Plot count
            ct(:,1) = vertcat(BL_superEvents.ct)';
            ct(:,2) = vertcat(CNO_superEvents.ct)';
            subplot(2,2,3);
            boxplot(ct,'Color',colorMap);
            hold on;
            ylabel('Count');
            title('Number of Events');
            box off;
            xticklabels({'Baseline','CNO'});
            for idot = 1:length(vertcat(BL_superEvents.ct)')
            scatter(ones(length(vertcat(BL_superEvents(idot).ct)'),1), vertcat(BL_superEvents(idot).ct)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            for idot = 1:length(vertcat(CNO_superEvents.ct)')
            scatter(2*ones(length(vertcat(CNO_superEvents(idot).ct)'),1), vertcat(CNO_superEvents(idot).ct)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            
            %% Plot auc
            auc(:,1) = vertcat(BL_superEvents.auc)';
            auc(:,2) = vertcat(CNO_superEvents.auc)';
            subplot(2,2,4);
            boxplot(auc,'Color',colorMap);
            hold on;
            ylabel('AUC');
            title('AUC of Events');
            box off;
            xticklabels({'Baseline','CNO'});
            for idot = 1:length(vertcat(BL_superEvents.auc)')
            scatter(ones(length(vertcat(BL_superEvents(idot).auc)'),1), vertcat(BL_superEvents(idot).auc)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            for idot = 1:length(vertcat(CNO_superEvents.auc)')
            scatter(2*ones(length(vertcat(CNO_superEvents(idot).auc)'),1), vertcat(CNO_superEvents(idot).auc)',...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
            end
            
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
        load(CCK_EVENT_BL, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
        CCK_BL_largeEvents = largeGroupEvents;
        CCK_BL_superEvents = superGroupEvents;
        CCK_BL_smallEvents = smallGroupEvents;
        load(CCK_EVENT_CNO, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
        CCK_CNO_largeEvents = largeGroupEvents;
        CCK_CNO_superEvents = superGroupEvents;
        CCK_CNO_smallEvents = smallGroupEvents;
        load(CCKAD_EVENT_BL, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
        CCKAD_BL_largeEvents = largeGroupEvents;
        CCKAD_BL_superEvents = superGroupEvents;
        CCKAD_BL_smallEvents = smallGroupEvents;
        load(CCKAD_EVENT_CNO, 'largeGroupEvents','superGroupEvents','smallGroupEvents');
        CCKAD_CNO_largeEvents = largeGroupEvents;
        CCKAD_CNO_superEvents = superGroupEvents;
        CCKAD_CNO_smallEvents = smallGroupEvents;
        %% Color Map
        colorMap(1,:) = [0 0 1];
        colorMap(2,:) = [1 0 0];
        colorMap(3,:) = [0 0 1];
        colorMap(4,:) = [1 0 0];
        colorSex_CCK_BL = zeros(sum(~cellfun(@isempty,{CCK_BL_largeEvents.s})),3);
        colorSex_CCK_CNO = zeros(sum(~cellfun(@isempty,{CCK_CNO_largeEvents.s})),3);
        colorSex_CCKAD_BL = zeros(sum(~cellfun(@isempty,{CCKAD_BL_largeEvents.s})),3);
        colorSex_CCKAD_CNO = zeros(sum(~cellfun(@isempty,{CCKAD_CNO_largeEvents.s})),3);
            % get color for dots of female vs male
            for i = 1:length(CCK_BL_largeEvents)
                if strcmp(CCK_BL_largeEvents(i).s,'f')
                    colorSex_CCK_BL(i,:) = [0 0 0];
                elseif strcmp(CCK_BL_largeEvents(i).s,'m')
                    colorSex_CCK_BL(i,:) = [1 1 1];
                end
            end
            % get color for dots of female vs male
            for i = 1:length(CCK_CNO_largeEvents)
                if strcmp(CCK_CNO_largeEvents(i).s,'f')
                    colorSex_CCK_CNO(i,:) = [0 0 0];
                elseif strcmp(CCK_CNO_largeEvents(i).s,'m')
                    colorSex_CCK_CNO(i,:) = [1 1 1];
                end
            end
                        % get color for dots of female vs male
            for i = 1:length(CCKAD_BL_largeEvents)
                if strcmp(CCKAD_BL_largeEvents(i).s,'f')
                    colorSex_CCKAD_BL(i,:) = [0 0 0];
                elseif strcmp(CCKAD_BL_largeEvents(i).s,'m')
                    colorSex_CCKAD_BL(i,:) = [1 1 1];
                end
            end
            % get color for dots of female vs male
            for i = 1:length(CCKAD_CNO_largeEvents)
                if strcmp(CCKAD_CNO_largeEvents(i).s,'f')
                    colorSex_CCKAD_CNO(i,:) = [0 0 0];
                elseif strcmp(CCKAD_CNO_largeEvents(i).s,'m')
                    colorSex_CCKAD_CNO(i,:) = [1 1 1];
                end
            end
        %% One big plot super events
        figure;
        sgtitle({[thisMonth ': super Calcium Events CCK vs CCKAD'],' '});
        %% Plot time Freq
        timeFreq(:,1) = vertcat(CCK_BL_superEvents.timeFreq)';
        timeFreq(:,2) = vertcat(CCK_CNO_superEvents.timeFreq)';
        tF1.max = max(timeFreq,[],'all');
        tF1.min = min(timeFreq,[],'all');
        timeFreq2(:,1) = vertcat(CCKAD_BL_superEvents.timeFreq);
        timeFreq2(:,2) = vertcat(CCKAD_CNO_superEvents.timeFreq);
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
        
        for idot = 1:length(vertcat(CCK_BL_superEvents.timeFreq)')
        scatter(ones(length(vertcat(CCK_BL_superEvents(idot).timeFreq)'),1), vertcat(CCK_BL_superEvents(idot).timeFreq)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCK_CNO_superEvents.timeFreq)')
        scatter(2*ones(length(vertcat(CCK_CNO_superEvents(idot).timeFreq)'),1), vertcat(CCK_CNO_superEvents(idot).timeFreq)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCKAD_BL_superEvents.timeFreq)')
        scatter(3*ones(length(vertcat(CCKAD_BL_superEvents(idot).timeFreq)'),1), vertcat(CCKAD_BL_superEvents(idot).timeFreq)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCKAD_CNO_superEvents.timeFreq)')
        scatter(4*ones(length(vertcat(CCKAD_CNO_superEvents(idot).timeFreq)'),1), vertcat(CCKAD_CNO_superEvents(idot).timeFreq)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
                 'MarkerFaceAlpha',0.2);
        end
        for i = 1:size(CCK_BL_superEvents,2)
            plot([1 2], [CCK_BL_superEvents(i).timeFreq CCK_CNO_superEvents(i).timeFreq],'Color',[0 0 0]+.8);
        end
        for i = 1:size(CCKAD_BL_superEvents,2)
            plot([3 4], [CCKAD_BL_superEvents(i).timeFreq CCKAD_CNO_superEvents(i).timeFreq],'Color',[0 0 0]+.8);
        end
        legend([lg1,lg2]);
        %% auc
        auc(:,1) = vertcat(CCK_BL_superEvents.auc)';
        auc(:,2) = vertcat(CCK_CNO_superEvents.auc)';
        Yauc.max = max(auc,[],'all');
        Yauc.min = min(auc,[],'all');
        auc2(:,1) = vertcat(CCKAD_BL_superEvents.auc);
        auc2(:,2) = vertcat(CCKAD_CNO_superEvents.auc);
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
        for idot = 1:length(vertcat(CCK_BL_superEvents.auc)')
        scatter(ones(length(vertcat(CCK_BL_superEvents(idot).auc)'),1), vertcat(CCK_BL_superEvents(idot).auc)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCK_CNO_superEvents.auc)')
        scatter(2*ones(length(vertcat(CCK_CNO_superEvents(idot).auc)'),1), vertcat(CCK_CNO_superEvents(idot).auc)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCKAD_BL_superEvents.auc)')
        scatter(3*ones(length(vertcat(CCKAD_BL_superEvents(idot).auc)'),1), vertcat(CCKAD_BL_superEvents(idot).auc)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCKAD_CNO_superEvents.auc)')
        scatter(4*ones(length(vertcat(CCKAD_CNO_superEvents(idot).auc)'),1), vertcat(CCKAD_CNO_superEvents(idot).auc)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for i = 1:size(CCK_BL_superEvents,2)
            plot([1 2], [CCK_BL_superEvents(i).auc CCK_CNO_superEvents(i).auc],'Color',[0 0 0]+.8);
        end
        for i = 1:size(CCKAD_BL_superEvents,2)
            plot([3 4], [CCKAD_BL_superEvents(i).auc CCKAD_CNO_superEvents(i).auc],'Color',[0 0 0]+.8);
        end
        
        legend([lg1,lg2]);
        clear timeFreq ptFreq ct amp auc;
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
        
        for idot = 1:length(vertcat(CCK_BL_largeEvents.timeFreq)')
        scatter(ones(length(vertcat(CCK_BL_largeEvents(idot).timeFreq)'),1), vertcat(CCK_BL_largeEvents(idot).timeFreq)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCK_CNO_largeEvents.timeFreq)')
        scatter(2*ones(length(vertcat(CCK_CNO_largeEvents(idot).timeFreq)'),1), vertcat(CCK_CNO_largeEvents(idot).timeFreq)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCKAD_BL_largeEvents.timeFreq)')
        scatter(3*ones(length(vertcat(CCKAD_BL_largeEvents(idot).timeFreq)'),1), vertcat(CCKAD_BL_largeEvents(idot).timeFreq)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCKAD_CNO_largeEvents.timeFreq)')
        scatter(4*ones(length(vertcat(CCKAD_CNO_largeEvents(idot).timeFreq)'),1), vertcat(CCKAD_CNO_largeEvents(idot).timeFreq)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
                 'MarkerFaceAlpha',0.2);
        end
        for i = 1:size(CCK_BL_largeEvents,2)
            plot([1 2], [CCK_BL_largeEvents(i).timeFreq CCK_CNO_largeEvents(i).timeFreq],'Color',[0 0 0]+.8);
        end
        for i = 1:size(CCKAD_BL_largeEvents,2)
            plot([3 4], [CCKAD_BL_largeEvents(i).timeFreq CCKAD_CNO_largeEvents(i).timeFreq],'Color',[0 0 0]+.8);
        end
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
        for idot = 1:length(vertcat(CCK_BL_largeEvents.auc)')
        scatter(ones(length(vertcat(CCK_BL_largeEvents(idot).auc)'),1), vertcat(CCK_BL_largeEvents(idot).auc)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCK_CNO_largeEvents.auc)')
        scatter(2*ones(length(vertcat(CCK_CNO_largeEvents(idot).auc)'),1), vertcat(CCK_CNO_largeEvents(idot).auc)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCKAD_BL_largeEvents.auc)')
        scatter(3*ones(length(vertcat(CCKAD_BL_largeEvents(idot).auc)'),1), vertcat(CCKAD_BL_largeEvents(idot).auc)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCKAD_CNO_largeEvents.auc)')
        scatter(4*ones(length(vertcat(CCKAD_CNO_largeEvents(idot).auc)'),1), vertcat(CCKAD_CNO_largeEvents(idot).auc)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for i = 1:size(CCK_BL_largeEvents,2)
            plot([1 2], [CCK_BL_largeEvents(i).auc CCK_CNO_largeEvents(i).auc],'Color',[0 0 0]+.8);
        end
        for i = 1:size(CCKAD_BL_largeEvents,2)
            plot([3 4], [CCKAD_BL_largeEvents(i).auc CCKAD_CNO_largeEvents(i).auc],'Color',[0 0 0]+.8);
        end
        
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
        for idot = 1:length(vertcat(CCK_BL_smallEvents.timeFreq)')
        scatter(ones(length(vertcat(CCK_BL_smallEvents(idot).timeFreq)'),1), vertcat(CCK_BL_smallEvents(idot).timeFreq)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCK_CNO_smallEvents.timeFreq)')
        scatter(2*ones(length(vertcat(CCK_CNO_smallEvents(idot).timeFreq)'),1), vertcat(CCK_CNO_smallEvents(idot).timeFreq)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCKAD_BL_smallEvents.timeFreq)')
        scatter(3*ones(length(vertcat(CCKAD_BL_smallEvents(idot).timeFreq)'),1), vertcat(CCKAD_BL_smallEvents(idot).timeFreq)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCKAD_CNO_smallEvents.timeFreq)')
        scatter(4*ones(length(vertcat(CCKAD_CNO_smallEvents(idot).timeFreq)'),1), vertcat(CCKAD_CNO_smallEvents(idot).timeFreq)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for i = 1:size(CCK_BL_smallEvents,2)
            plot([1 2], [CCK_BL_smallEvents(i).timeFreq CCK_CNO_smallEvents(i).timeFreq],'Color',[0 0 0]+.8);
        end
        for i = 1:size(CCKAD_BL_smallEvents,2)
            plot([3 4], [CCKAD_BL_smallEvents(i).timeFreq CCKAD_CNO_smallEvents(i).timeFreq],'Color',[0 0 0]+.8);
        end
        
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
        for idot = 1:length(vertcat(CCK_BL_smallEvents.auc)')
        scatter(ones(length(vertcat(CCK_BL_smallEvents(idot).auc)'),1), vertcat(CCK_BL_smallEvents(idot).auc)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCK_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCK_CNO_smallEvents.auc)')
        scatter(2*ones(length(vertcat(CCK_CNO_smallEvents(idot).auc)'),1), vertcat(CCK_CNO_smallEvents(idot).auc)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCK_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCKAD_BL_smallEvents.auc)')
        scatter(3*ones(length(vertcat(CCKAD_BL_smallEvents(idot).auc)'),1), vertcat(CCKAD_BL_smallEvents(idot).auc)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCKAD_BL(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for idot = 1:length(vertcat(CCKAD_CNO_smallEvents.auc)')
        scatter(4*ones(length(vertcat(CCKAD_CNO_smallEvents(idot).auc)'),1), vertcat(CCKAD_CNO_smallEvents(idot).auc)',[],...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerFaceColor',colorSex_CCKAD_CNO(idot,:),...
                'MarkerFaceAlpha',0.2);
        end
        for i = 1:size(CCK_BL_smallEvents,2)
            plot([1 2], [CCK_BL_smallEvents(i).auc CCK_CNO_smallEvents(i).auc],'Color',[0 0 0]+.8);
        end
        for i = 1:size(CCKAD_BL_smallEvents,2)
            plot([3 4], [CCKAD_BL_smallEvents(i).auc CCKAD_CNO_smallEvents(i).auc],'Color',[0 0 0]+.8);
        end
        
        legend([lg1,lg2]);
        clear timeFreq ptFreq ct amp auc;
    end %month
    
end
end