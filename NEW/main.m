function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 14-May-2021 01:42:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;
warning off;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Data Available to be Trained ')
file_name = dir('DATA');

for w=1:size(file_name,1)
    tempname_f = file_name(w,1).name;
    if((tempname_f(1)=='s')&(tempname_f(end-3:end)=='.mat') & (tempname_f(end-7:end-4)=='data'))
       data_available = tempname_f;
       disp(tempname_f)
    end
end
fprintf('\n');
[file,path] = uigetfile('*.mat');
index_file = strcat(file(1:4),'index.mat');
data_file = strcat(file(1:4),'data.mat');
load(fullfile(path,index_file));
load(fullfile(path,data_file));
% 1 Hand Open
% 2 Hand Close
% 3 Wrist Flexion
% 4 Wrist Extension
% 5 Supination
% 6 Pronation
% 7 Rest
window=200;
step=50;
j = 0;   
sz_indx=size(start_index,1);
trainData= zeros(sz_indx,sz_indx);
load_label= zeros(sz_indx,sz_indx);
for i=1:sz_indx
    trainData(i,1:sz_indx)= data(start_index(i,1):start_index(i,1)+sz_indx-1,1);
    trainLabels(i,1)= motion(i);
end
filteredData = filterEMG(trainData, 1000, 25, 450);
median_freq = medfreq(trainData);
for t=1:sz_indx
    snr_int(t) = snr(trainData(:,t));
end
mean_freq = meanfreq(trainData);

figure(10)
plot(mean_freq,'-r')
grid on;
xlabel('Number of Frequency');
ylabel('MEAN');
title('MEAN FREQUENCY');
figure(11)
plot(median_freq,'-r')
grid on;
xlabel('Number of Frequency');
ylabel('MEDIAN');
title('MEDIAN FREQUENCY');
figure(12)
plot(snr_int,'-r')
grid on;
xlabel('Number of Frequency');
ylabel('Signal To Noise Ratio');
title('SNR');

cp = cvpartition(trainLabels,'KFold',5);
temp_rand = randi([1,sz_indx],[1,max(cp.TestSize)]);
testData = trainData(temp_rand,:);
testLabels = trainLabels(temp_rand,:);
dataLength = size(filteredData,1);
vec = window:step:dataLength;
for i = vec
    j = j+1;
    sampleEMG = filteredData(i-window+1:i,:);
    EMGtemp = getEMGfeaturesTD(sampleEMG);
    EMGobj.MAV(:,j) = EMGtemp.MAV;
    EMGobj.TD(:,j) = [EMGtemp.MAV; EMGtemp.WL; EMGtemp.VAR; EMGtemp.SSC; EMGtemp.ZC]; 
    EMGobj.FFT = getEMGfeaturesFFT(sampleEMG, fftLength);
end
for g=1:sz_indx
    f1(:,g) = jfemg('rms', trainData(g,:)); 
    f2(:,g) = jfemg('mav', trainData(g,:)); 
    f3(:,g) = jfemg('zc', trainData(g,:)); 
    f4(:,g) = jfemg('wl', trainData(g,:)); 
 end
feat = [f1; f2; f3; f4]';

figure(1)
plot(f1,'or')
grid on;
xlabel('Number of Samples');
ylabel('Root Mean Square');
title('RMS Feature Extracted');
figure(2)
plot(f2,'or')
grid on;
xlabel('Number of Samples');
ylabel('Mean Absolute Value');
title('MAV Feature Extracted');
figure(3)
plot(f3,'or')
grid on;
xlabel('Number of Samples');
ylabel('Zero Crossing');
title('ZC Feature Extracted');
figure(4)
plot(f4,'or')
grid on;
xlabel('Number of Samples');
ylabel('WavForm Length');
title('WL Feature Extracted');
disp('TEST DATA');
for u=1:size(testLabels,1)     
    if (testLabels(u,1)==1)
        disp('Hand Open');
    elseif (testLabels(u,1)==2)
        disp('Hand Close');
    elseif (testLabels(u,1)==3)
        disp('Wrist Flexion');
    elseif (testLabels(u,1)==4)
        disp('Wrist Extension');
    elseif (testLabels(u,1)==5)
        disp('Supination');
    elseif (testLabels(u,1)==6)
        disp('Pronation');
    elseif (testLabels(u,1)==7)
        disp('Rest');        
    end
end
ELM_predictions(:,1) = classify_ELM(trainData, trainLabels, testData);
fprintf('\n');
disp('ELM PREDICTED TEST DATA');
for u=1:size(ELM_predictions,1)     
    if (ELM_predictions(u,1)==1)
        disp('Hand Open');
    elseif (ELM_predictions(u,1)==2)
        disp('Hand Close');
    elseif (ELM_predictions(u,1)==3)
        disp('Wrist Flexion');
    elseif (ELM_predictions(u,1)==4)
        disp('Wrist Extension');
    elseif (ELM_predictions(u,1)==5)
        disp('Supination');
    elseif (ELM_predictions(u,1)==6)
        disp('Pronation');
    elseif (ELM_predictions(u,1)==7)
        disp('Rest');        
    end
end

LDA_predictions(:,1) = classify_LDA(trainData, trainLabels, testData);
fprintf('\n');
disp('LDA PREDICTED TEST DATA');
for u=1:size(LDA_predictions,1)     
    if (LDA_predictions(u,1)==1)
        disp('Hand Open');
    elseif (LDA_predictions(u,1)==2)
        disp('Hand Close');
    elseif (LDA_predictions(u,1)==3)
        disp('Wrist Flexion');
    elseif (LDA_predictions(u,1)==4)
        disp('Wrist Extension');
    elseif (LDA_predictions(u,1)==5)
        disp('Supination');
    elseif (LDA_predictions(u,1)==6)
        disp('Pronation');
    elseif (LDA_predictions(u,1)==7)
        disp('Rest');        
    end
end

for u=1:size(trainLabels,1)     
    if (trainLabels(u,1)==1)
       train_label{u,1} = ('Hand Open');
    elseif (trainLabels(u,1)==2)
        train_label{u,1} =('Hand Close');
    elseif (trainLabels(u,1)==3)
        train_label{u,1} =('Wrist Flexion');
    elseif (trainLabels(u,1)==4)
        train_label{u,1} =('Wrist Extension');
    elseif (trainLabels(u,1)==5)
        train_label{u,1} =('Supination');
    elseif (trainLabels(u,1)==6)
        train_label{u,1} =('Pronation');
    elseif (trainLabels(u,1)==7)
        train_label{u,1} =('Rest');        
    end
end
% train_label
f = figure(6);
    for r=1:size(trainData,2)-1
        hold on
        gscatter(trainData(:,r),trainData(:,r+1),train_label,'rgb','osd');        
    end
    N = size(trainData,1);
    lda = fitcdiscr(trainData,trainLabels);
    ldaClass = resubPredict(lda);

    figure(7)
    ldaResubCM = confusionchart(trainLabels,ldaClass);
    title('Confusion Matrix')
    figure(f)
    bad = ~strcmp(ldaClass,trainLabels);               
    hold on;
    plot(trainData(bad,1), trainData(bad,2), 'kx');
    hold off;
    [x,y] = meshgrid(4:.1:8,2:.1:4.5);
    x = x(:);
    y = y(:);
    for e=1:2:size(trainData,2)
    if e <=size(trainData,2)-1
          samp_t(:,e) = x;
          samp_t(:,e+1) = y;
    else
        
    end
    end
    j = classify(samp_t(:,1:5),trainData(:,1:5),trainLabels);
    figure(8)
    gscatter(x,y,j,'grb','sod')
    
fprintf('\n');

[ trainData , trainLabels ] = SRCdictionaryReduce(trainData, trainLabels, 100);

Error_ELM = size(find(abs(testLabels - ELM_predictions)~=0),1)/size(testLabels,1)
Error_LDA = size(find(abs(testLabels - LDA_predictions)~=0),1)/size(testLabels,1)

ELM_Accuracy =(1-Error_ELM)*100
LDA_Accuracy =(1-Error_LDA)*100

figure(14)
X = categorical({'ELM','LDA'});
X = reordercats(X,{'ELM','LDA'});
Y = [ELM_Accuracy LDA_Accuracy];
bar(X,Y)
title('Accuracy')
ylim([0,120]);
