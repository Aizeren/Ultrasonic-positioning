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

xMin = 70;                     % set x-min
xMax = 95;                      % set x-max

yMin = 25;                     % set y-min
yMax = 45;                      % set y-max

delay = 0.05;                    % update coordinates every n seconds

numOfCoordsToFilter = 7; 
 
%Define Function Variables
count = 0;
medCount = 0;
maxCount = 70;

xCoordUnfiltered = zeros(1, maxCount);
yCoordUnfiltered = zeros(1, maxCount);

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
 
%Open Serial COM Port
s = serial(serialPort);
disp('Close Plot to End Session');
fopen(s);

%while ishandle(plotGraph)
while(count < maxCount)  
    xCoordCur = fscanf(s,'%f'); %Read Data from Serial as Float
    yCoordCur = fscanf(s,'%f'); %Read Data from Serial as Float

    if(~isempty(xCoordCur) && isfloat(xCoordCur) && ~isempty(yCoordCur) && isfloat(yCoordCur))
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
plot(xCoordMean,yCoordMean,'-r');

hold on

%median filter plot
plot(xCoordMed, yCoordMed, '-k');

hold on

%savitsky-golay filter plot
plot(sgolayfilt(xCoordUnfiltered, 3, 11), sgolayfilt(yCoordUnfiltered, 3, 11),'-b');
% plot(xCoordSav,yCoordSav,'-b');

hold on

%Unfiltered data
plot(xCoordUnfiltered, yCoordUnfiltered, '--k');

hold on

%Expected traectory
plot(xCoordExpected, yCoordExpected, 'o:k');

legend('Mean filter','Median filter','Savitzky-Golay filter','Unfiltered data', 'Expected traectory');
title(plotTitle,'FontSize',25);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
axis([xMin xMax yMin yMax]);
grid(plotGrid);

disp('Session Terminated...');