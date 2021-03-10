function [Tbl,headers,Measurements,NCol] = ReadInCSVExtractColumns
path = uigetfile('*.csv');
Tbl = readtable(path);
[Measurements NCol] = size(Tbl); % Define size of Tbl variable 

% Export columns and headers as variables
    for m = 1:NCol
        headers{m} = Tbl.Properties.VariableNames{1,m};
        assignin('base',headers{m},[Tbl{:,m}]);
    end
% return
