%% AirQuality model analysis
    close all;clear;clc % Prepare workspace and console
    
%% Load data and export columns and headers as variables
    [Tbl, headers, Measurements, NCol] = ReadInCSVExtractColumns;

 %% Identify modeled parameter and predicted counterpart
    P = Predicted;
    Orig = T;
    
%% Remove null values from dataset
    nullval = -200;
    for nv = 1:Measurements
        if T(nv) == -200
            Orig(nv) = 0;
            P(nv) = 0;
        end
    end

 %% Perform stats
[rmse, rsq, ttest] = LinRegStats(Orig,P)

%% Visualise data
    % Define parameters for figure
    linwid = 5;
    ylim_range_plot = [-10 50];
    xlim_range_plot = ([1 length(T)]);
    
    ylim_range_hist = [-10 70];
    xlim_range_hist = [-10 45];
    
    % Combine datasets for boxplots
    tempvar2(:,1) = Orig;
    tempvar2(:,2) = P;
    
    % Produce graphs
    figure(101)
    subplot(1,4,1) % Plot raw data
        plot(T_prep,'ro')
        hold on
        plot(P_prep,'bo')
            xlabel('Samples');ylabel('Temperature ({\circ}C)')
            set(gca,'XTick',[],'Fontsize',14,'linewidth',3)
            xlim(xlim_range_plot);ylim(ylim_range_plot)
            title('Raw data')
            legend('Temperature','Predicted')
    subplot(1,4,2) % Plot histogram showing distributions for T
        histfit(T_prep)
            xlim(xlim_range_hist);ylim(ylim_range_hist)
            xlabel('Temperature ({\circ}C)');ylabel('Samples')
            set(gca,'Fontsize',14,'linewidth',3)
            title('Actual Temperature ({\circ}C)')
    subplot(1,4,3) % Plot histogram showing distributions for P
        histfit(P_prep)
            xlim(xlim_range_hist);ylim(ylim_range_hist)
            xlabel('Temperature ({\circ}C)');ylabel('Samples')
            set(gca,'Fontsize',14,'linewidth',3)
            title('Predicted Temperature ({\circ}C)')
    subplot(1,4,4) % Show sample distributions via boxplots
        boxplot(rmoutliers(tempvar2))
            xticklabels({'Actual Temp.','Predicted Temp.'})
            xlabel('Parameters');ylabel('Temperature ({\circ}C)')
            set(gca,'Fontsize',14,'linewidth',3)
            title('Sample distributions')
            set(gcf,'color','w')     