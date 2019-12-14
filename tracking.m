if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
clear
clc
 
%User Defined Properties 
serialPort = 'COM3';            % define COM port #
plotTitle = 'Receiver position';  % plot title
xLabel = 'Coordinate X';    % x-axis label
yLabel = 'Coordinate Y';    % y-axis label
plotGrid = 'minor';                % 'off' to turn off grid

xMin = 69;                     % set x-min
xMax = 95;                      % set x-max

yMin = 25;                     % set y-min
yMax = 45;                      % set y-max

delay = 0.1;                    % update coordinates every n seconds

numOfCoordsToFilter = 7;
 
%Define Function Variables
xCoord = zeros(1, numOfCoordsToFilter);
yCoord = zeros(1, numOfCoordsToFilter);
count = 0;

xCoordsToFilter = zeros(1, numOfCoordsToFilter);
yCoordsToFilter = zeros(1, numOfCoordsToFilter);
%Set up Plot
plotGraph = plot(xCoord,yCoord,'-r',...
                'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[.49 1 .63],...
                'MarkerSize',2);
             
title(plotTitle,'FontSize',25);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
axis([xMin xMax yMin yMax]);
grid(plotGrid);
 
%Open Serial COM Port
s = serial(serialPort);
disp('Close Plot to End Session');
fopen(s);

while ishandle(plotGraph) %Loop when Plot is Active
    count = count + 1;
    
    xCoordsToFilter = circshift(xCoordsToFilter, -1);
    yCoordsToFilter = circshift(yCoordsToFilter, -1);
    
    xCoordsToFilter(numOfCoordsToFilter) = fscanf(s,'%f'); %Read Data from Serial as Float
    yCoordsToFilter(numOfCoordsToFilter) = fscanf(s,'%f'); %Read Data from Serial as Float
    
    %mean filter
    if (count > numOfCoordsToFilter+2)
        curCoord = count-numOfCoordsToFilter;
        xCoord(curCoord) = mean(xCoordsToFilter);
        yCoord(curCoord) = mean(yCoordsToFilter);
        
        %one more filter
        xCoord(curCoord) = (xCoord(curCoord-1) + 2*xCoord(curCoord-2) + xCoordsToFilter(numOfCoordsToFilter))/4;
        yCoord(curCoord) = (yCoord(curCoord-1) + 2*yCoord(curCoord-2) + yCoordsToFilter(numOfCoordsToFilter))/4;
        set(plotGraph,'XData',xCoord,'YData',yCoord);
    end
    
    %sav-golay filter
%     if (count > numOfCoordsToFilter)
% %         xCoord(count) = xCoordsToFilter(numOfCoordsToFilter);
% %          yCoord(count) = yCoordsToFilter(numOfCoordsToFilter);
% %         xCoord = sgolayfilt(xCoord, 7, 9);
% %         yCoord = sgolayfilt(yCoord, 7, 9);
%        xCoord(count-numOfCoordsToFilter:count-1) = sgolayfilt(xCoordsToFilter, 3, numOfCoordsToFilter-2);
%        yCoord(count-numOfCoordsToFilter:count-1) = sgolayfilt(yCoordsToFilter, 3, numOfCoordsToFilter-2);
%        set(plotGraph,'XData',xCoord,'YData',yCoord);
%     end

    
    pause(delay);
end
 
%Close Serial COM Port
fclose(s);
 
disp('Session Terminated...');