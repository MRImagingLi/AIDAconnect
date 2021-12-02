function plotDistribution(inputFMRI, graphCell, strParameter, day)

%% plotDistribution
% Displays the distribution either of the node degree or of the 
% node strength (mean over all subjects) 
% for all groups at a given time point. 
% You can specify a value range in lines 16 and 17 to additionally output 
% the region's names whose degree/strength values are within that range.

% Input Arguments
% inputFMRI and graphCell from mergeFMRIdata_input.m
% strParameter = 'Degree', 'Strength'
% day = Name of the day to examine as in inputFMRI.days (as String)

%% Specifications
lowerBound = 50;
upperBound = 60;

%% Example
% plotDistribution(inputFMRI, graphCell, 'Degree', 'Baseline') 

%% Do not modify the following lines

days = inputFMRI.days;
dayIdx = (days == day);
groups = inputFMRI.groups;
numOfGroups = size(groups,2);

figure('Name', 'plotDistribution');
for i = 1:numOfGroups
    subplot(numOfGroups,1,i);
    if lower(strParameter) == "degree"
        groupMeanValues{i} = round(mean(graphCell{i,dayIdx}.Nodes.allDegree,2));
        plotxLabel = ' Degree';
    else
        if lower(strParameter) == "strength"
            groupMeanValues{i} = round(mean(graphCell{i,dayIdx}.Nodes.allStrength,2)); 
            plotxLabel = ' Strength';
        end
    end    
    % Plot the distribution
    hist = histogram(groupMeanValues{i});
    title(strrep(groups(i),'_',' ')+" at "+day);
    xlabel(strcat("Mean",plotxLabel));
    ylabel('Frequency of occurrence');
    set(gca,'FontSize',12)
    % Prevent scientific notation
    axes = ancestor(hist, 'axes');
    axes.XAxis.Exponent = 0;
    xtickformat('%.0f')
    % Display all regions that have a degree/strength within a specified range
    valueIdxFiltered = groupMeanValues{i} >= lowerBound & groupMeanValues{i} <= upperBound;
    regionsNames = string(graphCell{i,dayIdx}.Nodes.Name(valueIdxFiltered));
    regionsValues = groupMeanValues{i}(valueIdxFiltered);
    groupTable = table(regionsNames, regionsValues);
    groupTable.Properties.VariableNames = {'Region', strcat('Mean',plotxLabel)};
    disp(strcat("Regions with a mean",lower(plotxLabel)," between ",string(lowerBound)," and ",string(upperBound)," of ",strrep(groups(i),'_',' ')," at ",day,":"));
    if size(groupTable) ~= 0
        disp(groupTable);
    else
        disp('None')
    end
end