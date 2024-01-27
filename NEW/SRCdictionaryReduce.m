% INPUTS: Atrain - training data (numF x N)
%         trainlabels - training data labels (1 x N)  
%         percent - final percentage size (input 30 for 30% of original data size)
%         
% OUTPUT: [AtrainReduced, trainlabelsReduced] - reduced dictionary and labels
function [AtrainReduced, trainlabelsReduced] = SRCdictionaryReduce(Atrain, trainlabels, percent) 
    percentTrain = percent * 0.01;
    sizeTrain = size(Atrain,2); 
    
     %% Remove random elements based on train percentages desired
    reducedTrainSize = floor(percentTrain*sizeTrain);
	trainSelect = randperm(sizeTrain);
	trainSelect = trainSelect(1:floor(sizeTrain - reducedTrainSize));	
    Atrain(:,trainSelect) = [];   trainlabels(trainSelect) = [];     
    [trainlabelsReduced, trainIndex] = sort(trainlabels);
    AtrainReduced = Atrain(:,trainIndex); 
end