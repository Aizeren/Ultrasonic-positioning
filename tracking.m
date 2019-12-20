if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
clear
clc
 
%User Defined Properties 
serialPort = 'COM3';
plotTitle = 'Receiver position';
xLabel = 'Coordinate X';
yLabel = 'Coordinate Y';
plotGrid = 'minor';

delay = 0.05;                    % update coordinates every n seconds

numOfCoordsToFilter = 7; 
 
%Define Function Variables
count = 0;
medCount = 0;
maxCount = 100;

xCoordUnfiltered = zeros(1, maxCount);
yCoordUnfiltered = zeros(1, maxCount);

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
 
%Open Serial COM Port
s = serial(serialPort);
disp('Close Plot to End Session');
fopen(s);

%while ishandle(plotGraph)
while(count < maxCount)  
    xCoordCur = fscanf(s,'%f'); %Read Data from Serial as Float
    yCoordCur = fscanf(s,'%f'); %Read Data from Serial as Float

    if(~isempty(xCoordCur) && ~isnan(xCoordCur) && isfloat(xCoordCur) && ~isempty(yCoordCur) && ~isnan(yCoordCur) && isfloat(yCoordCur))
        count = count + 1;

        xCoordUnfiltered(count) = xCoordCur;
        yCoordUnfiltered(count) = yCoordCur;
        
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
    
    pause(delay);
end
 
%Close Serial COM Port
fclose(s);

%mean filter plot
% plot(xCoordMean,yCoordMean, '-','Color', [0, 0.4470, 0.7410]);

hold on

%median filter plot
% plot(xCoordMed, yCoordMed, '-','Color', [0.9290, 0.6940, 0.1250]);

hold on

%savitsky-golay filter plot
% plot(sgolayfilt(xCoordUnfiltered, 3, 11), sgolayfilt(yCoordUnfiltered, 3, 11), '-','Color', [0.4660, 0.6740, 0.1880]);
% plot(xCoordSav,yCoordSav '-','Color', [0.4660, 0.6740, 0.1880]);

hold on

%Unfiltered data
plot(xCoordUnfiltered, yCoordUnfiltered, '--k');

hold on

%Expected traectory
% plot(xCoordExpected, yCoordExpected, 'o:k');

xMin = min(xCoordUnfiltered) - 5;                     % set x-min
xMax = max(xCoordUnfiltered) + 15;                      % set x-max

yMin = min(yCoordUnfiltered) - 5;                     % set y-min
yMax = max(yCoordUnfiltered) + 15;                      % set y-max

legend('Unfiltered data');
title(plotTitle,'FontSize',25);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
axis([xMin xMax yMin yMax]);
grid(plotGrid);

disp('Session Terminated...');