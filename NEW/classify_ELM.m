% INPUTS: Atrain - training data (numF x N)
%         trainlabels - training data labels (1 x N)  
%         Atest - testing data (numF x P)
%         testlabels - testing data labels (1 x P)           
%         
% OUTPUT: [predict1] -  predictions
function [predict1] = classify_ELM(Atrain, trainlabels, Atest) 
    numClasses = length(unique(trainlabels));
    sizeTrain = size(Atrain,2); 
    targets = eye(numClasses);
    hiddenLayerSize = 15;

    trainTargets = zeros(numClasses,sizeTrain);
    for i = 1:sizeTrain     
        trainTargets(:,i) = targets(trainlabels(i),:)';
    end

     %% choose type of neural net
    % net = feedforwardnet([5 4]);    
    net = patternnet(hiddenLayerSize);
    
     %% set net parameters
    net.divideParam.trainRatio = .70; % training set [%]
    net.divideParam.valRatio = .15; % validation set [%]
    net.divideParam.testRatio = .15; % test set [%]
    net.trainParam.showWindow = 0;
    [net,~,~,~] = train(net,Atrain,trainTargets);    
     %% get predictions on test data

     ELMobj = fitcdiscr(Atrain,trainlabels);
     [predict1,~,~] = predict(ELMobj,Atest);
%      predict1 = predict1;      
     
end