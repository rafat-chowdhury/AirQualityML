%% AirQuality model analysis
    close all;clear;clc % Prepare workspace and console
    
%% Load data and export columns and headers as variables
    Tbl = readtable('AirQuality_Processed.csv'); % Read in csv output
    [Measurements NCol] = size(Tbl); % Define size of Tbl variable 

% Export columns and headers as variables
    for m = 1:NCol
        temp = Tbl.Properties.VariableNames{1,m};
        assignin('base',temp,Tbl{:,m});   
    end

% Remove null values from dataset
    % Prep null values
    T_prep = T;
    P_prep = Predicted;
    
    nullval = -200;
    for nv = 1:Measurements
        if T(nv) == -200
            T_prep(nv) = 0;
            P_prep(nv) = 0;
        end
    end
            
%% Visualise data
    % Define parameters for figure
    linwid = 5;
    ylim_range_plot = [-10 50];
    xlim_range_plot = ([1 length(T)]);
    
    ylim_range_hist = [-10 70];
    xlim_range_hist = [-10 45];
    
    % Combine datasets for boxplots
    tempvar2(:,1) = T_prep;
    tempvar2(:,2) = P_prep;
    
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

%% Calculate Normalised RMSE 
T_norm = T_prep./max(T_prep); % Normalise T_prep
Predicted_norm = P_prep./max(P_prep); % Normalise P_prep
e = (Predicted_norm - T_norm); % Define error
se = e.^2; % Define squared error
mse = (sum(se)./length(se)); % Define mean squared error
rmse = sqrt(mse) *100; % Calculate RMSE as a percentage

%% R-squared calculation
residue = (T - Predicted); % Calculate residue 
SSresidue = sum(residue.^2); % Calculae SoS of residue
SStotal = (length(T) - 1) * var(T); 
rsq = 1 - SSresidue/SStotal % Calculate R-squared value

%% t-test analysis
[h p] = ttest2(T,Predicted);