 
% INPUTS: Atrain - training data (numF x N)
%         trainlabels - training data labels (1 x N)  
%         Atest - testing data (numF x P)
%         testlabels - testing data labels (1 x P)           
%         
% OUTPUT: [predict] - LDA predictions
function [predict1] = classify_LDA(Atrain, trainlabels, Atest) 
    LDAobj = fitcdiscr(Atrain,trainlabels,'DiscrimType','pseudolinear'); % good
    [predict1,~,~] = predict(LDAobj,Atest);
    predict1 = predict1'; 
    
%     f = figure;
%     for r=1:size(Atrain,2)
%         hold on
%         gscatter(Atrain(:,r),num2str(trainlabels),'rgb','osd');        
%     end
%     %     xlabel('Sepal length');
% %     ylabel('Sepal width');
%    
% N = size(Atrain,1);
% %     lda = fitcdiscr(Atrain,trainlabels);
%     ldaClass = resubPredict(LDAobj);
% %     ldaResubErr = resubLoss(lda)
%     figure
%     ldaResubCM = confusionchart(trainlabels,ldaClass);
%     figure(f)
%     bad = ~strcmp(ldaClass,trainlabels);
%     hold on;
%     plot(Atrain(bad,1), Atrain(bad,2), 'kx');
%     hold off;
%     [x,y] = meshgrid(4:.1:8,2:.1:4.5);
%     x = x(:);
%     y = y(:);
%     j = classify([x y],Atrain(:,1:2),trainlabels);
%     gscatter(x,y,j,'grb','sod')
end