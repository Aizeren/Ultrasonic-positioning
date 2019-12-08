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

xMin = 50;                     % set x-min
xMax = 100;                      % set x-max

yMin = 10;                     % set y-min
yMax = 60;                      % set y-max

delay = 0.001;                    % make sure sample faster than resolution
 
%Define Function Variables
xCoord = 0;
yCoord = 0;
count = 0;
 
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

while (count < 30)
    fscanf(s,'%f');
    count = count + 1;
end
count = 0;
 
while ishandle(plotGraph) %Loop when Plot is Active
    count = count + 1;
    
    xDat = fscanf(s,'%f'); %Read Data from Serial as Float
    yDat = fscanf(s,'%f'); %Read Data from Serial as Float
    
    %Make sure Data Type is Correct  
    if(~isempty(xDat) && isfloat(xDat) && ~isempty(yDat) && isfloat(yDat))       
        xCoord(count) = xDat(1);    %Extract Elapsed Time
        yCoord(count) = yDat(1);    %Extract 1st Data Element

        %Set Axis according to Scroll Width
        set(plotGraph,'XData',xCoord,'YData',yCoord);
    end
    
    pause(delay);
end
 
%Close Serial COM Port and Delete useless Variables
fclose(s);
%clear count dat delay max min plotGraph plotGrid plotTitle s ...
 %       scrollWidth serialPort xLabel yLabel;
 
 
disp('Session Terminated...');