if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
clear
clc
 
%User Defined Properties 
plotTitle = 'Receiver position';
xLabel = 'Coordinate X';
yLabel = 'Coordinate Y';
plotGrid = 'minor';

xMin = 60;                     % set x-min
xMax = 100;                      % set x-max

yMin = 15;                     % set y-min
yMax = 55;                      % set y-max

numOfCoordsToFilter = 7; 
 
%Define Function Variables
load('./resources/xCoordUnfiltered_1_config', 'xCoordUnfiltered');
load('./resources/yCoordUnfiltered_1_config', 'yCoordUnfiltered');

maxCount = size(xCoordUnfiltered, 2);

xCoordExpected = [71.26 91.7 91.08 71 71.26];
yCoordExpected = [29.78 29.68 45.18 45.2 29.78];

xCoordMean = zeros(1, maxCount);
yCoordMean = zeros(1, maxCount);

xCoordMed = zeros(1, maxCount-floor(numOfCoordsToFilter/2));
yCoordMed = zeros(1, maxCount-floor(numOfCoordsToFilter/2));

xCoordSav = zeros(1, maxCount);
yCoordSav = zeros(1, maxCount);

xCoordCur = 0;
yCoordCur = 0;
count = 0;
medCount = 0;


while(count < maxCount)  
        count = count + 1;
        
        if (count > numOfCoordsToFilter)
            %mean filter
            xCoordMean(count) = mean(xCoordUnfiltered(count-numOfCoordsToFilter:count));
            yCoordMean(count) = mean(yCoordUnfiltered(count-numOfCoordsToFilter:count));
            
            %median filter
            medCount = count-floor(numOfCoordsToFilter/2);

            xCoordMed(medCount) = median(xCoordUnfiltered(count-numOfCoordsToFilter:count));
            yCoordMed(medCount) = median(yCoordUnfiltered(count-numOfCoordsToFilter:count)); 
            
            %sav-golay filter
        else
           xCoordMean(count) = mean(xCoordUnfiltered(1:count));
           yCoordMean(count) = mean(yCoordUnfiltered(1:count));
           
           xCoordMed(count) = median(xCoordUnfiltered(1:count)); 
           yCoordMed(count) = median(yCoordUnfiltered(1:count)); 
        end
end

%mean filter plot
plot(xCoordMean,yCoordMean, '-','Color', [0, 0.4470, 0.7410]);

hold on

%median filter plot
plot(xCoordMed, yCoordMed, '-','Color', [0.9290, 0.6940, 0.1250]);

hold on

%savitsky-golay filter plot
plot(sgolayfilt(xCoordUnfiltered, 3, 11), sgolayfilt(yCoordUnfiltered, 3, 11), '-','Color', [0.4660, 0.6740, 0.1880]);
% plot(xCoordSav,yCoordSav '-','Color', [0.4660, 0.6740, 0.1880]);

hold on

%Unfiltered data
plot(xCoordUnfiltered, yCoordUnfiltered, '--k');

hold on

%Expected traectory
plot(xCoordExpected, yCoordExpected, 'o:k');

legend('Mean filter', 'Median filter', 'Savitzky-Golay filter', 'Unfiltered data', 'Expected traectory');
title(plotTitle,'FontSize',25);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
axis([xMin xMax yMin yMax]);
grid(plotGrid);

disp('Session Terminated...');