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
set(0,'DefaultLineLineWidth',2);

numOfCoordsToFilter = 7; 
 
%Define Function Variables
load('./resources/xCoordUnfiltered_2_config', 'xCoordUnfiltered');
load('./resources/yCoordUnfiltered_2_config', 'yCoordUnfiltered');

maxCount = size(xCoordUnfiltered, 2);

load('./resources/xCoordExpected_2_config', 'xCoordExpected');
load('./resources/yCoordExpected_2_config', 'yCoordExpected');

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

xMin = min(xCoordExpected) - 5;                     % set x-min
xMax = max(xCoordExpected) + 15;                      % set x-max

yMin = min(yCoordExpected) - 5;                     % set y-min
yMax = max(yCoordExpected) + 15;                      % set y-max


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
            
        else
           xCoordMean(count) = mean(xCoordUnfiltered(1:count));
           yCoordMean(count) = mean(yCoordUnfiltered(1:count));
           
           xCoordMed(count) = median(xCoordUnfiltered(1:count)); 
           yCoordMed(count) = median(yCoordUnfiltered(1:count)); 
        end
end

xCoordSav = sgolayfilt(xCoordUnfiltered, 3, 11);
yCoordSav = sgolayfilt(yCoordUnfiltered, 3, 11);

%calculate norm
xExpectedMin = mean([xCoordExpected(1) xCoordExpected(4)]);
yExpectedMin = mean([yCoordExpected(1) yCoordExpected(2)]);

xExpectedMax = mean([xCoordExpected(2) xCoordExpected(3)]);
yExpectedMax = mean([yCoordExpected(3) yCoordExpected(4)]);

filterError = zeros(1, count);
%norms for mean filter
for i=1:count
   filterError(i) = min([abs(xCoordMean(i) - xExpectedMin), abs(xCoordMean(i) - xExpectedMax), abs(yCoordMean(i) - yExpectedMin), abs(yCoordMean(i) - yExpectedMax)]);
end
fprintf('L2 norm for mean filter = %f\n', norm(filterError, 2));
fprintf('L-inf norm for mean filter = %f\n\n', max(filterError));

%norms for median filter
for i=1:medCount
   filterError(i) = min([abs(xCoordMed(i) - xExpectedMin), abs(xCoordMed(i) - xExpectedMax), abs(yCoordMed(i) - yExpectedMin), abs(yCoordMed(i) - yExpectedMax)]);
end
fprintf('L2 norm for median filter = %f\n', norm(filterError, 2));
fprintf('L-inf norm for median filter = %f\n\n', max(filterError));

%norms for Savitzky-Golay filter
for i=1:count
   filterError(i) = min([abs(xCoordSav(i) - xExpectedMin), abs(xCoordSav(i) - xExpectedMax), abs(yCoordSav(i) - yExpectedMin), abs(yCoordSav(i) - yExpectedMax)]);
end
fprintf('L2 norm for Sav-Golay filter = %f\n', norm(filterError, 2));
fprintf('L-inf norm for Sav-Golay filter = %f\n', max(filterError));


%mean filter plot
plot(xCoordMean,yCoordMean, '-','Color', [0, 0.4470, 0.7410]);

hold on

%median filter plot
plot(xCoordMed, yCoordMed, '-','Color', [0.9290, 0.6940, 0.1250]);

hold on

%savitsky-golay filter plot
plot(xCoordSav,yCoordSav, '-','Color', [0.4660, 0.6740, 0.1880]);

hold on

%Unfiltered data
plotUnfiltered = plot(xCoordUnfiltered, yCoordUnfiltered, '--k');

hold on

%Expected traectory
plot(xCoordExpected, yCoordExpected,'o:k');

legend('Mean filter', 'Median filter', 'Savitzky-Golay filter', 'Unfiltered data', 'Expected traectory');
title(plotTitle,'FontSize',25);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
axis([xMin xMax yMin yMax]);
grid(plotGrid);