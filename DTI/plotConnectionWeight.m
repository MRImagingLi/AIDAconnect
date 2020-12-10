function plotConnectionWeight(inputDTI, graphCell, startP, endP)

%% plotConnectionWeight
% Compares the edge weight (number of fibers) of two regions for two groups

% Input Arguments
% inputDTI and graphCell from mergeDTIdata_input.m
% startP = First Region (as String)
% endP = Second Region (as String)

%% Example
% plotConnectionWeight(inputDTI, graphCell, 'L DORpm', 'L MOp')

%% Do not modify the following lines

days = inputDTI.days;
groups = inputDTI.groups;
numOfDays = size(inputDTI.days,2);
numOfGroups = size(inputDTI.groups,2);
tempFile = load('../Tools/infoData/acronyms_splitted.mat');
acronyms = tempFile.acronyms;
addpath('./GraphEval/');

valuesGroup1 = nan(size(graphCell{1,1}.Nodes.allMatrix,3),numOfDays);
for day=1:numOfDays
    curGraph=graphCell{1,day};
    numOfAnimals=size(graphCell{1,day}.Nodes.allMatrix,3);
    for animal = 1:numOfAnimals
        c = graph(curGraph.Nodes.allMatrix(:,:,animal) , cellstr(acronyms),'lower');
        edge = findedge(c,{startP},{endP});
        % rows = days, columns = animals
        if edge>0
            valuesGroup1(animal,day)=c.Edges.Weight(edge);
        else
            valuesGroup1(animal,day)=-1;
        end
    end
end
valuesGroup1(valuesGroup1==0)=nan;
valuesGroup1(valuesGroup1==-1)=0;
tableGroup1 = array2table(valuesGroup1);
for day = 1:numOfDays
    tableGroup1.Properties.VariableNames(day) = inputDTI.days(day);
end
disp(strcat("Edge Weight from ",startP," to ",endP," in group ",inputDTI.groups(1),':'));
disp(tableGroup1);

valuesGroup2 = nan(size(graphCell{2,1}.Nodes.allMatrix,3),numOfDays);
for day=1:numOfDays
    curGraph=graphCell{2,day};
    numOfAnimals=size(graphCell{2,day}.Nodes.allMatrix,3);
    for animal = 1:numOfAnimals
        c = graph(curGraph.Nodes.allMatrix(:,:,animal) , cellstr(acronyms),'lower');
        edge = findedge(c,{startP},{endP});
        % rows = days, columns = animals
        if edge>0
            valuesGroup2(animal,day)=c.Edges.Weight(edge);
        else
            valuesGroup2(animal,day)=-1;
        end
    end
end
valuesGroup2(valuesGroup2==0)=nan;
valuesGroup2(valuesGroup2==-1)=0;
tableGroup2 = array2table(valuesGroup2);
for day = 1:numOfDays
    tableGroup2.Properties.VariableNames(day) = inputDTI.days(day);
end
disp(strcat("Edge Weight from ",startP," to ",endP," in group ",inputDTI.groups(2),':'));
disp(tableGroup2);

valuesGroup = {valuesGroup1, valuesGroup2};
plotFigure(days, groups, valuesGroup);
title([startP '  <->  ' endP]);
ylabel('Number of Fibers');
