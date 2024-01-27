%% Betthauser - 2017 --  Plot of the confusion matrices in a nice form
% INPUTS: actual - testing labels ( 1xN vector of integer class labels )
%         predicted - predicted labels ( 1xN vector of integer class labels )
%         classes - list object of class names (e.g. {'Rest','Open','Close',...} )
%         figTitle - string of figure title
% 
% OUTPUT: a plot of the confusion matrices in a nice form
%
% TYPICAL USE EXAMPLE: plotConfuse(testLabels,predictedLabels,classes,'LDA');
function plotConfuse(actual,predicted,classes,figTitle)
    numClasses = length(classes);
    sizeTest = length(actual);
    confusion = zeros(numClasses,numClasses);
    
     %% counter
    for i = 1:sizeTest 
        confusion(actual(i),predicted(i)) = confusion(actual(i),predicted(i)) + 1; 
    end
    
     %% normalizer to accuracy
    rowSum = zeros(1,numClasses);
    for i = 1:numClasses
       rowSum(i) = sum(confusion(i,:));
       for j = 1:numClasses
           confusion(i,j) = confusion(i,j)/rowSum(i);
       end
    end
    
     %% Plot confusion
    figure; set(gca,'LooseInset', get(gca,'TightInset'));       
%     colormap(bone); % DEFAULT: colormap(parula);
    image(confusion,'CDataMapping','scaled');     
    xlabel('Predicted'); ylabel('Actual'); title(figTitle);
    xticks( 1:numClasses ); yticks( 1:numClasses );
    xticklabels(classes); yticklabels(classes);
    axis square; 
    
    textStrings = num2str(100*confusion(:),'%0.0f');  %# Create strings from the matrix values
    textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
    [x,y] = meshgrid(1:numClasses);   %# Create x and y coordinates for the strings
    hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                    'HorizontalAlignment','center');
    midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
    textColors = repmat(confusion(:) < midValue,1,3);  %# Choose white or black for the
                                                 %#   text color of the strings so
                                                 %#   they can be easily seen over
                                                 %#   the background color
    set(hStrings,{'Color'},num2cell(textColors,2), 'fontsize',10);  %# Change the text colors 
    

set(gca,'fontsize',8,'fontweight','bold');  %# Change the text colors 
end