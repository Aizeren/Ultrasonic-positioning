clear
clc
 
%User Defined Properties 
serialPort = 'COM3';            % define COM port #
plotTitle = 'Receiver position';  % plot title
xLabel = 'Coordinate X';    % x-axis label
yLabel = 'Coordinate Y';    % y-axis label
plotGrid = 'on';                % 'off' to turn off grid

xMin = 60;                     % set x-min
xMax = 110;                      % set x-max

yMin = -10;                     % set y-min
yMax = 40;                      % set y-max

delay = .01;                    % make sure sample faster than resolution
 
%Define Function Variables
xCoord = 0;
yCoord = 0;
count = 0;
 
%Set up Plot
plotGraph = plot(xCoord,yCoord,'-mo',...
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

tic
 
while ishandle(plotGraph) %Loop when Plot is Active
     
    xDat = fscanf(s,'%f'); %Read Data from Serial as Float
    yDat = fscanf(s,'%f'); %Read Data from Serial as Float
  
    if(~isempty(xDat) && isfloat(xDat) && ~isempty(yDat) && isfloat(yDat)) %Make sure Data Type is Correct        
        count = count + 1;   
        if (count > 6)
            xCoord(count) = xDat(1);    %Extract Elapsed Time
            yCoord(count) = yDat(1); %Extract 1st Data Element
            %Set Axis according to Scroll Width
    %         if(scrollWidth > 0)
    %             set(plotGraph,'XData',xCoord(xCoord > xCoord(count)-scrollWidth),'YData',yCoord(xCoord > xCoord(count)-scrollWidth));
    %             axis([xCoord(count)-scrollWidth xCoord(count) yMin yMax]);
    %         else
                set(plotGraph,'XData',xCoord,'YData',yCoord);
    %             axis([0 xCoord(count) yMin yMax]);
    %         end
        end
        %Allow MATLAB to Update Plot
        pause(delay);
    end
end
 
%Close Serial COM Port and Delete useless Variables
fclose(s);
clear count dat delay max min plotGraph plotGrid plotTitle s ...
        scrollWidth serialPort xLabel yLabel;
 
 
disp('Session Terminated...');