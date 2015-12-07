function varargout = Arthur_Visualizer(varargin)
% ARTHUR_VISUALIZER MATLAB code for Arthur_Visualizer.fig
%      ARTHUR_VISUALIZER, by itself, creates a new ARTHUR_VISUALIZER or raises the existing
%      singleton*.
%
%      H = ARTHUR_VISUALIZER returns the handle to a new ARTHUR_VISUALIZER or the handle to
%      the existing singleton*.
%
%      ARTHUR_VISUALIZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARTHUR_VISUALIZER.M with the given input arguments.
%
%      ARTHUR_VISUALIZER('Property','Value',...) creates a new ARTHUR_VISUALIZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Arthur_Visualizer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Arthur_Visualizer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Arthur_Visualizer

% Last Modified by GUIDE v2.5 07-Dec-2015 16:07:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Arthur_Visualizer_OpeningFcn, ...
                   'gui_OutputFcn',  @Arthur_Visualizer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Arthur_Visualizer is made visible.
function Arthur_Visualizer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Arthur_Visualizer (see VARARGIN)

% Choose default command line output for Arthur_Visualizer
handles.output = hObject;
addpath('/Volumes/Data/arthur/Utils/peakdet');
handles.Grey = [0.8 0.8 0.8];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Arthur_Visualizer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Arthur_Visualizer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
handles.BigNumber = 50000000;
axes(handles.axes1)
cla

[FileName,PathName,~] = uigetfile('*.csv|*.dat|*.mat','Find the data file.','H:\Etudes\Inria\Lariboisiere');
set(gcf,'Pointer','watch');
set(handles.infoCentertext,'String','Loading...');
drawnow
if regexp(FileName,'.dat')
    WholeData = LoadPatient([PathName, FileName],0);
    %FileName = OldFileName;
elseif regexp(FileName,'.mat')
    WholeData = load([PathName, FileName]);
    
elseif regexp(FileName,'.csv')
    %FileName = ['Alex_',OldFileName];
    %system(['cp -i ',[PathName,OldFileName],' ',[PathName,FileName]]);
    %system(['perl -pi -w -e ''s/,/./g;'' ',[PathName,FileName]]);
    %system(['perl -pi -w -e ''s/;/,/g;'' ',[PathName,FileName]]);
    %system(['perl -pi -w -e ''s/://g;'' ',[PathName,FileName]]);
    WholeData = LoadPatient([PathName, FileName],1);
else
    println('FAIL :( Format not known.\n')
end

set(gcf,'Pointer','arrow');
set(handles.infoCentertext,'String','Loading...Done');

handles.FileName = FileName;
handles.PathName = PathName;

VariableNames = {};
Fields = fields(WholeData);
for i = 1: length(Fields)
    Field = Fields{i};
    if regexp(Field,'DateTime')
        Time = WholeData.(Field);
    end
end

for i = 1:10
    set(handles.(['radiobutton',num2str(i)]),'String','')
    set(handles.(['radiobutton',num2str(i)]),'Visible','off')
    set(handles.(['radiobutton',num2str(i)]),'Value',0)
    set(handles.(['radiobutton',num2str(i),'2']),'Visible','off')
    set(handles.(['radiobutton',num2str(i),'2']),'Value',0)
end

axes(handles.axes1)
maxTime = 0;
for i = 1: length(Fields)
    Field = Fields{i};
    if ~(isempty(WholeData.(Field))) && ~(strcmp(Field,'DateTime'))
        VariableNames{length(VariableNames)+1} = Field;
        ThisData = WholeData.(Field);
        if regexp(FileName,'.dat|.csv')
            ThisTime = Time(~(ThisData==handles.BigNumber));
            ThisData = ThisData(~(ThisData==handles.BigNumber));
            Factor = max(abs(ThisData));
            Factors.(Field) = Factor;
            ThisDataNorm = ThisData./Factor;
            Translation = min(ThisDataNorm);
            Translations.(Field) = Translation;
            ThisDataNorm = ThisDataNorm-min(ThisDataNorm);
        else
            ThisTime = ThisData(:,1);
            ThisData = ThisData(:,2);
            Factor = max(abs(ThisData));
            Factors.(Field) = Factor;
            ThisDataNorm = ThisData./Factor;
            Translation = min(ThisDataNorm);
            Translations.(Field) = Translation;
            ThisDataNorm = ThisDataNorm-min(ThisDataNorm);
        end
        
        hold on;
        Plots.(Field) = plot(ThisTime,ThisDataNorm);
        Data.(Field) = [ThisTime,ThisDataNorm];
        if ThisTime(1) > maxTime
            maxTime = ThisTime(1);
        end
        
        set(handles.(['radiobutton',num2str(length(VariableNames))]),'String',Field)
        set(handles.(['radiobutton',num2str(length(VariableNames))]),'Visible','on')
        set(handles.(['radiobutton',num2str(length(VariableNames))]),'Value',1)
        set(handles.(['radiobutton',num2str(length(VariableNames)),'2']),'Visible','off')
    end
end
xlim auto
ylim auto

Lengths = zeros(length(VariableNames),1);
for N = 1:length(VariableNames)
    VariableName = VariableNames{N};
    ThisData = Data.(VariableName);
    Lengths(N) = ThisData(end,1)-ThisData(1,1);
end
if max(Lengths(2:end)-Lengths(1:end-1))==0
    fprintf('Detected a shifted signal.\n')
    handles.ShiftAmount = 0;
    SmallestTime = 9e9;
    LargestTime = 0;
    for N = 1:length(VariableNames)
        VariableName = VariableNames{N};
        InitTime = Data.(VariableName)(1,1);
        if InitTime < SmallestTime
            SmallestTime = InitTime;
        end
        if InitTime > LargestTime
            LargestTime = InitTime;
        end
    end
    
    set(handles.Shiftbutton,'Enable','on');
    set(handles.Shifttext,'String',['Initial shift amount: ',num2str(LargestTime-SmallestTime)]);
end

handles.legend = legend(VariableNames);
set(handles.Adjustpopup,'Value',1);
set(handles.Adjustpopup,'String',VariableNames);
set(handles.legend,'Visible','On');
set(handles.findpeaksbutton,'Enable','on');
set(handles.Exportbutton,'Enable','on');

handles.InitialData = Data;
handles.Data = Data;
handles.VariableNames = VariableNames;
handles.Plots = Plots;
handles.Factors = Factors;
handles.Translations = Translations;
guidata(hObject,handles);


% --- Executes on button press in clearaxesbutton4.
function clearaxesbutton4_Callback(hObject, eventdata, handles)

axes(handles.axes1)
cla
VariableNames = handles.VariableNames;
for i = 1 : length(VariableNames)
    set(handles.(['radiobutton',num2str(i)]),'Visible','off')
end
set(handles.legend,'visible','off')

set(handles.findpeaksbutton,'Enable','off');
guidata(hObject,handles);

function findpeaksbutton_Callback(hObject, eventdata, handles)

VariableNames = handles.VariableNames;
set(handles.axes2,'Visible','on');
axes(handles.axes1);
hold on;
XLim = xlim;

for i = 1 : length(VariableNames)
    VariableName = VariableNames{i};
    if regexp(VariableName,'Pleth|PA')
        if get(handles.(['radiobutton',num2str(i)]),'Value')
            ThisData = handles.Data.(VariableNames{i});
            ThisTime = ThisData(:,1);
            ThisData = ThisData(:,2);
            ThisData = ThisData(ThisTime>=XLim(1));
            ThisTime = ThisTime(ThisTime>=XLim(1));
            ThisData = ThisData(ThisTime<=XLim(2));
            ThisTime = ThisTime(ThisTime<=XLim(2));
            
            [Heights, ~, Maxs, ~] = peakdet(ThisData,median(ThisData));
             Maxs(Heights>2*median(Heights))=[];
             Heights(Heights>2*median(Heights))=[];
             Maxs(Heights<0.7*median(Heights))=[];
             Heights(Heights<0.7*median(Heights))=[];

            [Lows, ~, Mins, ~] = peakdet(-ThisData+max(ThisData),median(-ThisData+max(ThisData)));
            %Get rid of maxes that are too high or too low
            Mins(Lows>2*median(Lows))=[];
            Lows(Lows>2*median(Lows))=[];
            Mins(Lows<0.7*median(Lows))=[];
            Lows(Lows<0.7*median(Lows))=[];

            %Get rid of Mins and Maxes that are too close to each other
            TimeThreshold = median(Maxs(2:end)-Maxs(1:end-1))-10*iqr(Maxs(2:end)-Maxs(1:end-1));
            TooCloseMax = find(Maxs(2:end)-Maxs(1:end-1) < TimeThreshold);
            while ~isempty(TooCloseMax)
                if Heights(TooCloseMax(1)) > Heights(TooCloseMax(1)+1)
                    Maxs(TooCloseMax(1)+1) = [];
                    Heights(TooCloseMax(1)+1) = [];
                else
                    Maxs(TooCloseMax(1)) = [];
                    Heights(TooCloseMax(1)) = [];
                end
                TooCloseMax = find(Maxs(2:end)-Maxs(1:end-1) < TimeThreshold);
            end
            TooCloseMin = find(Mins(2:end)-Mins(1:end-1) < TimeThreshold);
            while ~isempty(TooCloseMin)
                if Lows(TooCloseMin(1)) > Lows(TooCloseMin(1)+1)
                    Mins(TooCloseMin(1)+1) = [];
                    Lows(TooCloseMin(1)+1) = [];
                else
                    Mins(TooCloseMin(1)) = [];
                    Lows(TooCloseMin(1)) = [];
                end
                TooCloseMin = find(Mins(2:end)-Mins(1:end-1) < TimeThreshold);
            end

            Maxs = Maxs(2:end-1);
            Mins = Mins(2:end-1);

            handles.Maxs.(VariableName) = Maxs;
            handles.Mins.(VariableName) = Mins;
            
            handles.MaxPlots.(VariableName) = plot(ThisTime(Maxs),ThisData(Maxs),'*');
            handles.MinPlots.(VariableName) = plot(ThisTime(Mins),ThisData(Mins),'*');
            for ii = 1 : length(Mins)
                handles.MinLines.(VariableName).(['L',num2str(ii)]) = plot([ThisTime(Mins(ii)) ThisTime(Mins(ii))],[0 1],'color',handles.Grey);
                uistack(handles.MinLines.(VariableName).(['L',num2str(ii)]),'bottom');
            end
            set(handles.(['radiobutton',num2str(i),'2']),'Visible','on')
            set(handles.(['radiobutton',num2str(i),'2']),'Value',1)
        end
    end
end

%Find peaks on ECG
for i = 1 : length(VariableNames)
    VariableName = VariableNames{i};
    if regexp(VariableName,'ECG')
        if get(handles.(['radiobutton',num2str(i)]),'Value')
            ThisData = handles.Data.(VariableNames{i});
            ThisTime = ThisData(:,1);
            ThisData = ThisData(:,2);
            ThisData = ThisData(ThisTime>=XLim(1));
            ThisTime = ThisTime(ThisTime>=XLim(1));
            ThisData = ThisData(ThisTime<=XLim(2));
            ThisTime = ThisTime(ThisTime<=XLim(2));
            
            [Heights, ~, Maxs, ~] = peakdet(ThisData,median(ThisData)+iqr(ThisData));
             Maxs(Heights<2*median(Heights))=[];
             Heights(Heights<2*median(Heights))=[];
             Maxs(Heights<0.7*median(Heights))=[];
             Heights(Heights<0.7*median(Heights))=[];

            [Lows, ~, Mins, ~] = peakdet(-ThisData+max(ThisData),median(-ThisData+max(ThisData)));
            %Get rid of maxes that are too high or too low
            Mins(Lows>2*median(Lows))=[];
            Lows(Lows>2*median(Lows))=[];
            Mins(Lows<0.7*median(Lows))=[];
            Lows(Lows<0.7*median(Lows))=[];

            %Get rid of Mins and Maxes that are too close to each other
            TimeThreshold = median(Maxs(2:end)-Maxs(1:end-1))-10*iqr(Maxs(2:end)-Maxs(1:end-1));
            TooCloseMax = find(Maxs(2:end)-Maxs(1:end-1) < TimeThreshold);
            while ~isempty(TooCloseMax)
                if Heights(TooCloseMax(1)) > Heights(TooCloseMax(1)+1)
                    Maxs(TooCloseMax(1)+1) = [];
                    Heights(TooCloseMax(1)+1) = [];
                else
                    Maxs(TooCloseMax(1)) = [];
                    Heights(TooCloseMax(1)) = [];
                end
                TooCloseMax = find(Maxs(2:end)-Maxs(1:end-1) < TimeThreshold);
            end
            TooCloseMin = find(Mins(2:end)-Mins(1:end-1) < TimeThreshold);
            while ~isempty(TooCloseMin)
                if Lows(TooCloseMin(1)) > Lows(TooCloseMin(1)+1)
                    Mins(TooCloseMin(1)+1) = [];
                    Lows(TooCloseMin(1)+1) = [];
                else
                    Mins(TooCloseMin(1)) = [];
                    Lows(TooCloseMin(1)) = [];
                end
                TooCloseMin = find(Mins(2:end)-Mins(1:end-1) < TimeThreshold);
            end

            Maxs = Maxs(2:end-1);
            Mins = Mins(2:end-1);

            handles.Maxs.(VariableName) = Maxs;
            handles.Mins.(VariableName) = Mins;

            handles.MaxPlots.(VariableName) = plot(ThisTime(Maxs),ThisData(Maxs),'*');
            handles.MinPlots.(VariableName) = plot(ThisTime(Mins),ThisData(Mins),'*');
            for ii = 1 : length(Maxs)
                handles.MinLines.(VariableName).(['L',num2str(ii)]) = plot([ThisTime(Maxs(ii)) ThisTime(Maxs(ii))],[0 1],'color',handles.Grey);
                uistack(handles.MinLines.(VariableName).(['L',num2str(ii)]),'bottom');
            end
            set(handles.(['radiobutton',num2str(i),'2']),'Visible','on')
            set(handles.(['radiobutton',num2str(i),'2']),'Value',1)
        end
    end
end

%Plot VP loop inset
v = 0;
for i = 1 : length(VariableNames)
    VariableName = VariableNames{i};
    if regexp(VariableName,'Vel')
        Velocity = VariableName;
        handles.Velocity = Velocity;
        str ={};
        for ii = 1 : length(VariableNames)
            IsPAP = VariableNames{ii};
            if regexp(IsPAP,'PA|PLE')
                str{length(str)+1} = IsPAP;
            end
        end
        
        qstring = 'Which pressure to plot?';
        [s,v] = listdlg('PromptString',qstring,...
                'SelectionMode','single',...
                'ListString',str);
        Pressure = str{s};
        handles.Pressure = Pressure;
    end
end
if v
    axes(handles.axes2);
    uistack(gca,'top');
    set(gca,'Visible','on');
    ThisData = handles.Data.(Velocity);
    ThisTime = ThisData(:,1);
    ThisVel = ThisData(:,2);
    ThisVel = ThisVel(ThisTime>=XLim(1));
    ThisTime = ThisTime(ThisTime>=XLim(1));
    ThisVel = ThisVel(ThisTime<=XLim(2));
    
    
    ThisData = handles.Data.(Pressure);
    ThisTime = ThisData(:,1);
    ThisPres = ThisData(:,2);
    ThisPres = ThisPres(ThisTime>=XLim(1));
    ThisTime = ThisTime(ThisTime>=XLim(1));
    ThisPres = ThisPres(ThisTime<=XLim(2));
    
    plot(ThisVel,ThisPres);
    box on; set(gca,'xtick',[],'ytick',[]);
    axes(handles.axes1);
    uistack(gca,'bottom');
    %set(gca,'Visible','off');
end
set(handles.Exportbutton,'Enable','on');
guidata(hObject,handles);

% function adjustbutton_Callback(hObject, eventdata, handles)
% OldFluxMins = handles.Mins.Flux;
% OldFluxMaxs = handles.Maxs.Flux;
% CentralMins = handles.Mins.CentralPressure;
% Start = handles.Window.Min;
% Stop = handles.Window.Max;
% FluxMins = OldFluxMins(OldFluxMins>Start);
% FluxMins = FluxMins(FluxMins<Stop);
% CentralMins = CentralMins(CentralMins>Start);
% CentralMins = CentralMins(CentralMins<Stop);
% Diffs = FluxMins-CentralMins;
% Diffs(Diffs<=0) = [];
% OldFlux = handles.Data.Flux;
% NewFlux = [OldFlux(mode(Diffs)+1:end);zeros(mode(Diffs),1)];
% NewFluxMins = OldFluxMins-mode(Diffs);
% NewFluxMaxs = OldFluxMaxs-mode(Diffs);
% set(handles.Plots.Flux,'YData',NewFlux);
% set(handles.MinPlots.Flux,'XData',NewFluxMins);
% set(handles.MaxPlots.Flux,'XData',NewFluxMaxs);
% 
% set(handles.adjustbutton,'Enable','off');
% guidata(hObject,handles);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
handles = RadioButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);
    

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
handles = RadioButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
handles = RadioButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
handles = RadioButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);


  % --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
handles = RadioButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);
  
  % --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
handles = RadioButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);
  
  % --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
handles = RadioButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);
  
  % --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
handles = RadioButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);
  
  % --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
handles = RadioButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);
  
  % --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
handles = RadioButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);
  
  
  

% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
handles = MaxButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);

% --- Executes on button press in radiobutton22.
function radiobutton22_Callback(hObject, eventdata, handles)
handles = MaxButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);



% --- Executes on button press in radiobutton32.
function radiobutton32_Callback(hObject, eventdata, handles)
handles = MaxButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);


% --- Executes on button press in radiobutton42.
function radiobutton42_Callback(hObject, eventdata, handles)
handles = MaxButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);





% --- Executes on button press in radiobutton52.
function radiobutton52_Callback(hObject, eventdata, handles)
handles = MaxButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);


% --- Executes on button press in radiobutton62.
function radiobutton62_Callback(hObject, eventdata, handles)
handles = MaxButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);


% --- Executes on button press in radiobutton72.
function radiobutton72_Callback(hObject, eventdata, handles)
handles = MaxButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);


% --- Executes on button press in radiobutton82.
function radiobutton82_Callback(hObject, eventdata, handles)
handles = MaxButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);


% --- Executes on button press in radiobutton92.
function radiobutton92_Callback(hObject, eventdata, handles)
handles = MaxButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);


% --- Executes on button press in radiobutton102.
function radiobutton102_Callback(hObject, eventdata, handles)
handles = MaxButtons(hObject, eventdata, handles);
  % Store the value
  guidata(hObject,handles);

function handles = RadioButtons(hObject, eventdata, handles)
On = hObject.Value;

Variable = get(hObject,'String');
Plot = handles.Plots.(Variable);
ButtonTag = hObject.Tag;

if isfield(handles,'MaxPlots')
    if isfield(handles.MaxPlots,Variable);
            MaxPlot = handles.MaxPlots.(Variable);
            MinPlot = handles.MinPlots.(Variable);
    end
end
if On == 0
    set(Plot,'LineStyle','none');
    set(hObject,'Value',0)
    set(handles.([ButtonTag,'2']),'Visible','Off');
    if isfield(handles,'MaxPlots')
        if isfield(handles.MaxPlots,Variable);
                Mins = get(MinPlot,'XData');
                set(MaxPlot,'Marker','none');
                set(MinPlot,'Marker','none');
                for ii = 1 : length(Mins)
                    set(handles.MinLines.(Variable).(['L',num2str(ii)]),'linestyle','none');
                end
        end
    end
else
    set(Plot,'LineStyle','-');
    set(hObject,'Value',1)
    set(handles.([ButtonTag,'2']),'Visible','On');
    if isfield(handles,'MaxPlots')
        if isfield(handles.MaxPlots,Variable);
                Mins = get(MinPlot,'XData');
                MaxsOn = get(handles.([ButtonTag,'2']),'Value');
                if MaxsOn
                    set(MaxPlot,'Marker','*');
                    set(MinPlot,'Marker','*');
                end
                for ii = 1 : length(Mins)
                    set(handles.MinLines.(Variable).(['L',num2str(ii)]),'linestyle','-');
                end
        end
    end
end
  % Store the value
  guidata(hObject,handles);
  
function handles = MaxButtons(hObject, eventdata, handles)     
On = hObject.Value;
ThisTag = get(hObject,'Tag');
SisterButton = ThisTag(1:end-1);
Variable = get(handles.(SisterButton),'String');
MaxPlot = handles.MaxPlots.(Variable);
MinPlot = handles.MinPlots.(Variable);
Mins = get(MinPlot,'XData');
    
if On == 0
    set(MaxPlot,'Marker','none');
    set(MinPlot,'Marker','none');
    set(hObject,'Value',0)
    
    for ii = 1 : length(Mins)
        Min = handles.MinLines.(Variable).(['L',num2str(ii)]);
        set(Min,'Color',[1 1 1])
    end
    
else
    set(MaxPlot,'Marker','*');
    set(MinPlot,'Marker','*');
    set(hObject,'Value',1)
    
    for ii = 1 : length(Mins)
        Min = handles.MinLines.(Variable).(['L',num2str(ii)]);
        set(Min,'Color',handles.Grey)
    end
end
  % Store the value
  guidata(hObject,handles);


% --- Executes on button press in Exportbutton.
function Exportbutton_Callback(hObject, eventdata, handles)
VariableNames = handles.VariableNames;
ExportData = struct;
axes(handles.axes1);
hold on;
XLim = xlim;
FoundECG = 0;
InitCyclePoints =[];
SaveData = [];
for i = 1 : length(VariableNames)
    
    VariableName = VariableNames{i};
    if get(handles.(['radiobutton',num2str(i)]),'Value')
        ThisData = handles.Data.(VariableNames{i});
        ThisTime = get(handles.Plots.(VariableName),'XData');
        ThisTime = ThisTime';
        ThisData = ThisData(:,2);
        
        ThisData = ThisData(ThisTime>=XLim(1));
        ThisTime = ThisTime(ThisTime>=XLim(1));
        ThisData = ThisData(ThisTime<=XLim(2));
        ThisTime = ThisTime(ThisTime<=XLim(2));
        
        DT = median(ThisTime(2:end)-ThisTime(1:end-1));
        ThisData = ThisData+handles.Translations.(VariableName);
        ThisData = ThisData.*handles.Factors.(VariableName);
        ExportData.(VariableName) = [ThisTime,ThisData];
        %SaveData = [SaveData ExportData.(VariableName)];
    end
end

if isfield(handles,'MinPlots')
    AdjustNum = handles.Adjustpopup.Value;
    Variable = VariableNames{AdjustNum};
    if isfield(handles.MinPlots,Variable)
        InitCyclePoints = get(handles.MinPlots.(Variable),'XData');
    end
end

PathName = handles.PathName;
FileName = handles.FileName;

prompt = {'Enter file name:'};
dlg_title = 'Save as';
num_lines = 1;
defaultans = {[FileName(1:end-4),'_SelectedCycles']};
NewFileName = inputdlg(prompt,dlg_title,num_lines,defaultans);
%writetable(ExportData,[defaultans,'.mat'],'Delimiter',';','FileType','.csv')

if ~length(NewFileName)==0
    NewName = [PathName NewFileName{1}];
    save([NewName,'.mat'],'-struct','ExportData');
    
    %csv stuff
    %We need to get to the original header to find the Date Time column
    %(The original Date Time data is lost in the Pyhton script, so we have to create it again)
    [PathName FileName];
    fid = fopen([PathName FileName]);
    Separator = ';';
    Header = fgetl(fid);
    Headers = textscan(Header,'%s','Delimiter',Separator);
    Headers = Headers{1};%The first item in Header is actually the list of variables

    format = [];
    for N= 1:length(Headers)
        if regexp (Headers{N},'date','ignorecase')
            format = [format,' %f-%f-%f %f:%f:%f',Separator];
            DateColumn = N;
        else
            format = [format,' %f',Separator];
        end
    end
    format = format(1:end-1);

    variable = fgetl(fid);
    variable2 = strrep(variable, ',', '.');
    variable2 = strrep(variable2, ';;', [';',num2str(handles.BigNumber),';']);
    variable2 = strrep(variable2, ';;', ';');
    Data = textscan(variable2, format);
    fclose(fid);
    
    %all initial time data
    Year = round(Data{DateColumn},0);
    Month = round(Data{DateColumn+1},0);
    Day = round(Data{DateColumn+2},0);
    Hour = round(Data{DateColumn+3},0);
    Minute = round(Data{DateColumn+4},0);
    Second = Data{DateColumn+5};
    Date = [num2str(Year),'-',num2str(Month),'-',num2str(Day),' ',num2str(Hour),':',num2str(Minute)];
    
    fid = fopen([NewName,'.csv'],'w');
    fprintf(fid,'Date Time');
    Fields = fields(ExportData);
    ShiftIndices = zeros(1,length(Fields));
    
    %Set the header, find the original time for the export, find the shift
    %factor
    for N = 1:length(Fields)
        VariableName = Fields{N};
        ThisTime = get(handles.Plots.(VariableName),'XData');
        [';',TranslateHeader(VariableName)]
        fprintf(fid,[';',TranslateHeader(VariableName)]);
        ThisIndex = find(abs(ThisTime)<0.0001);
        if ThisIndex
            ShiftIndices(N) = -(ThisIndex(N)-1);
        else
            ShiftIndices(N) = find(handles.InitialData.(VariableName)(:,1) == ThisTime(1));
        end
        
    end
    fprintf(fid,'\n');
    FirstTimeIndex = find(handles.InitialData.(VariableName)(:,1) == ExportData.(VariableName)(1,1))+min(ShiftIndices);
    
    %pad the data to account for the shifts
    for N = 1:length(Fields)
        VariableName = Fields{N};
        ThisData = ExportData.(VariableName)(:,2);
        BegPad = handles.BigNumber.*ones(ShiftIndices(N)-min(ShiftIndices),1);
        EndPad = handles.BigNumber.*ones(max(ShiftIndices)-ShiftIndices(N),1);
        ExportData.(VariableName) = [BegPad;ThisData;EndPad];
    end
    
    %Export
    for N = FirstTimeIndex: FirstTimeIndex+length([BegPad;ThisData;EndPad])-1
        fprintf(fid,[Date,':',num2str(Second+(N-FirstTimeIndex+1)*DT)]);
        for NN = 1:length(Fields)
            VariableName = Fields{NN};
            fprintf(fid,[';',num2str(ExportData.(VariableName)(N-FirstTimeIndex+1))]);
        end
        fprintf(fid,'\n');
    end
    
    fclose(fid);
    
end


  % Store the value
  guidata(hObject,handles);


% --- Executes on button press in Leftbutton.
function Leftbutton_Callback(hObject, eventdata, handles)
set(gcf,'Pointer','watch');
set(handles.infoCentertext,'String','Computing...');
drawnow
VariableNames = handles.VariableNames;
AdjustNum = handles.Adjustpopup.Value;
Variable = VariableNames{AdjustNum};
handles.AdjustVariable = Variable;

ThisData = handles.Data.(Variable);
ThisTime = ThisData(:,1);
ThisData = ThisData(:,2);

DeltaTime = (ThisTime(10)-ThisTime(9));
ThisNewTime = ThisTime - DeltaTime;
handles.Data.(Variable) = [ThisNewTime,ThisData];
set(handles.Plots.(Variable),'XData',ThisNewTime);
        
if isfield(handles,'Maxs')
    if isfield(handles.Maxs,Variable)
        Maxs = get(handles.MaxPlots.(Variable),'XData');
        Mins = get(handles.MinPlots.(Variable),'XData');
        Maxs = Maxs - DeltaTime;
        Mins = Mins - DeltaTime;

        set(handles.MaxPlots.(Variable),'XData',Maxs);
        set(handles.MinPlots.(Variable),'XData',Mins);

        for ii = 1 : length(Mins)
            set(handles.MinLines.(Variable).(['L',num2str(ii)]),'XData',[Mins(ii) Mins(ii)]);
        end
    end
    
    
    Mins = get(handles.MinPlots.(handles.Pressure),'XData');
    axes(handles.axes2);
    ThisData = handles.Data.(handles.Velocity);
    ThisTime = ThisData(:,1);
    ThisVel = ThisData(:,2);
    ThisVel = ThisVel(ThisTime>=Mins(1));
    ThisTime = ThisTime(ThisTime>=Mins(1));
    ThisVel = ThisVel(ThisTime<=Mins(end));

    ThisData = handles.Data.(handles.Pressure);
    ThisTime = ThisData(:,1);
    ThisPres = ThisData(:,2);
    ThisPres = ThisPres(ThisTime>=Mins(1));
    ThisTime = ThisTime(ThisTime>=Mins(1));
    ThisPres = ThisPres(ThisTime<=Mins(end));

    plot(ThisVel(1:min(length(ThisVel),length(ThisPres))),ThisPres(1:min(length(ThisVel),length(ThisPres))));
    axes(handles.axes1);
    uistack(gca,'bottom');
end
            
set(gcf,'Pointer','arrow');
set(handles.infoCentertext,'String','Computing...Done');
  % Store the value
  guidata(hObject,handles);


% --- Executes on button press in Rightbutton.
function Rightbutton_Callback(hObject, eventdata, handles)
set(gcf,'Pointer','watch');
set(handles.infoCentertext,'String','Computing...');
drawnow
VariableNames = handles.VariableNames;
AdjustNum = handles.Adjustpopup.Value;
Variable = VariableNames{AdjustNum};
handles.AdjustVariable = Variable;

ThisData = handles.Data.(Variable);
ThisTime = ThisData(:,1);
ThisData = ThisData(:,2);

DeltaTime = (ThisTime(10)-ThisTime(9));
ThisNewTime = ThisTime + DeltaTime;
handles.Data.(Variable) = [ThisNewTime,ThisData];
set(handles.Plots.(Variable),'XData',ThisNewTime);
      


if isfield(handles,'Maxs')
    if isfield(handles.Maxs,Variable)
        'Something gets called'
        Maxs = get(handles.MaxPlots.(Variable),'XData');
        Mins = get(handles.MinPlots.(Variable),'XData');
        Maxs = Maxs + DeltaTime;
        Mins = Mins + DeltaTime;

        set(handles.MaxPlots.(Variable),'XData',Maxs);
        set(handles.MinPlots.(Variable),'XData',Mins);

        for ii = 1 : length(Mins)
            set(handles.MinLines.(Variable).(['L',num2str(ii)]),'XData',[Mins(ii) Mins(ii)]);
        end
    end
        
    Mins = get(handles.MinPlots.(handles.Pressure),'XData');
    axes(handles.axes2);
    ThisData = handles.Data.(handles.Velocity);
    ThisTime = ThisData(:,1);
    ThisVel = ThisData(:,2);
    ThisVel = ThisVel(ThisTime>=Mins(1));
    ThisTime = ThisTime(ThisTime>=Mins(1));
    ThisVel = ThisVel(ThisTime<=Mins(end));

    ThisData = handles.Data.(handles.Pressure);
    ThisTime = ThisData(:,1);
    ThisPres = ThisData(:,2);
    ThisPres = ThisPres(ThisTime>=Mins(1));
    ThisTime = ThisTime(ThisTime>=Mins(1));
    ThisPres = ThisPres(ThisTime<=Mins(end));

    plot(ThisVel(1:min(length(ThisVel),length(ThisPres))),ThisPres(1:min(length(ThisVel),length(ThisPres))));
    axes(handles.axes1);
    uistack(gca,'bottom');
end
        
set(gcf,'Pointer','arrow');
set(handles.infoCentertext,'String','Computing...Done');    
  % Store the value
  guidata(hObject,handles);


% --- Executes on selection change in popup.
function Adjustpopup_Callback(hObject, eventdata, handles)
VariableNames = handles.VariableNames;
AdjustNum = handles.Adjustpopup.Value;
Variable = VariableNames{AdjustNum};
handles.AdjustVariable = Variable;
  % Store the value
  guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function Adjustpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Adjustpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function [ AwfulHeader ] = TranslateHeader( NiceHeader )

    NiceHeaders = {'Vel1','Vel2','PAP','PA1','PA2','PA3','CO2','Pleth',...
        'DateTime','EEG','AWP','ICP','CVP','FeO2','AWF','CrbVol','UAP',...
        'Elapsed','AWRes','ECG_V','MCL','ECGII','ECGaVR','ECGV','ECG_I',...
        'ECG_III','ECG_II'};
    AwfulHeaders = {'Wave 1-Vel(NOS)','Wave 2-Vel(NOS)','PAP-PULM(mmHg)',...
        'Ao-AORT(mmHg)','ART-ART(mmHg)','ABP-ABP(mmHg)','CO2-CO2(mmHg)',...
        'Pleth-PLETH(-)','Date Time','EEG-CRTX(?V)','AWP-AWAY(cmH2O)',...
        'ICP-CRAN(mmHg)','CVP-CENT(mmHg)','O2-O2(%)','AWF-AWAY(l/min)',...
        'CrbVol-CrbVol(ml)','UAP-UMB(mmHg)','Milliseconds since 01.01.1970',...
        'Resp-RESP(Ohm)','V-V(mV)','MCL-MCL(mV)','Compound ECG-II(mV)',...
        'Compound ECG-aVR(mV)','Compound ECG-V(mV)','I-I(mV)','III-III(mV)','II-II(mV)'};

    AwfulHeader = AwfulHeaders(strcmp(NiceHeaders,NiceHeader));
    AwfulHeader = AwfulHeader{1};


% --- Executes on button press in Shiftbutton.
function Shiftbutton_Callback(hObject, eventdata, handles)

VariableNames = handles.VariableNames;
for N = 1:length(VariableNames)
    VariableName = VariableNames{N}
    ThisData = handles.Data.(VariableName);
    ThisTime = ThisData(:,1);
    ThisData = ThisData(:,2);
    DeltaTime = -ThisTime(1);
    ThisNewTime = ThisTime + DeltaTime;
    handles.Data.(VariableName) = [ThisNewTime,ThisData];
    set(handles.Plots.(VariableName),'XData',ThisNewTime);
end
set(handles.Shiftbutton,'Enable','off');
guidata(hObject,handles);
