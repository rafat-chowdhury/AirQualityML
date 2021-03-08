function [Tbl] = ReadInCSVExtractColumns
path = uigetfile('*.csv');
Tbl = readtable(path);
[Measurements NCol] = size(Tbl); % Define size of Tbl variable 

% Export columns and headers as variables
    for m = 1:NCol
        temp = Tbl.Properties.VariableNames{1,m};
        assignin('base',temp,[Tbl{:,m}]);
    end
% return
