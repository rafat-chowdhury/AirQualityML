function [rmse, rsq, ttest] = LinRegStats(var1,var2)

    %% Calculate Normalised RMSE 
    var1_norm = var1./max(var1); % Normalise T_prep
    var2_norm = var2./max(var2); % Normalise P_prep
    e = (var2_norm - var1_norm); % Define error
    se = e.^2; % Define squared error
    mse = (sum(se)./length(se)); % Define mean squared error
    rmse = sqrt(mse) *100; % Calculate RMSE as a percentage

    %% R-squared calculation
    residue = (var1 - var2); % Calculate residue 
    SSresidue = sum(residue.^2); % Calculae SoS of residue
    SStotal = (length(var1) - 1) * var(var1); 
    rsq = 1 - SSresidue/SStotal % Calculate R-squared value

    %% t-test analysis
    [h p] = ttest2(var1,var2);
    ttest.h = h;
    ttest.p = p;
return