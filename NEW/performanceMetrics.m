 function classwiseStats = performanceMetrics(ACTUAL,PREDICTED)
    % Output: object with all the classifier performance measures
%     numClasses = max([ACTUAL,PREDICTED]);

    classvec = unique([ACTUAL,PREDICTED]);
    numClasses = size(classvec,1);
    globalErrors = 0;
    for i = 1:length(ACTUAL)
        if PREDICTED(i) ~= ACTUAL(i)
            globalErrors = globalErrors+1;
        end
    end    
    classwiseStats.globalAccuracy = 1 - globalErrors/length(ACTUAL);  
        
     %% classwise performance
    for j = 1:numClasses   
        i = classvec(j);
        predictions = double(PREDICTED() == i);
        truth = double(ACTUAL() == i);
        EVAL = Evaluate(truth,predictions);
         %% EVAL = [accuracy sensitivity specificity precision npv f_1 active_error];
        classwiseStats.accuracy(i) = EVAL(1);
        classwiseStats.sensitivity(i) = EVAL(2);
        classwiseStats.specificity(i) = EVAL(3);
        classwiseStats.precision(i) = EVAL(4);
        classwiseStats.npv(i) = EVAL(5);
        classwiseStats.f_1(i) = EVAL(6);
        classwiseStats.active_error(i) = EVAL(7);        
    end    
 end