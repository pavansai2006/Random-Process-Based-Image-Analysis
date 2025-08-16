function varargout = Imageanalysisgui(varargin)
% IMAGEANALYSISGUI MATLAB code for Imageanalysisgui.fig
%      IMAGEANALYSISGUI, by itself, creates a new IMAGEANALYSISGUI or raises the existing
%      singleton*.
%
%      H = IMAGEANALYSISGUI returns the handle to a new IMAGEANALYSISGUI or the handle to
%      the existing singleton*.
%
%      IMAGEANALYSISGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEANALYSISGUI.M with the given input arguments.
%
%      IMAGEANALYSISGUI('Property','Value',...) creates a new IMAGEANALYSISGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Imageanalysisgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Imageanalysisgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Imageanalysisgui

% Last Modified by GUIDE v2.5 14-Jun-2025 09:18:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Imageanalysisgui_OpeningFcn, ...
                   'gui_OutputFcn',  @Imageanalysisgui_OutputFcn, ...
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


% --- Executes just before Imageanalysisgui is made visible.
function Imageanalysisgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Imageanalysisgui (see VARARGIN)

% Choose default command line output for Imageanalysisgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Imageanalysisgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Imageanalysisgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% Upload Image
function pushbutton1_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.*'}, 'Select an image');
if isequal(filename, 0)
    return;
end
img = imread(fullfile(pathname, filename));
handles.OriginalImage = img;
handles.CurrentImage = img;
axes(handles.axes1);
imshow(img);
guidata(hObject, handles);


% Reset Image
function pushbutton2_Callback(hObject, eventdata, handles)
handles.CurrentImage = handles.OriginalImage;
axes(handles.axes1);
imshow(handles.CurrentImage);
guidata(hObject, handles);

% Gaussian Noise
function pushbutton3_Callback(hObject, eventdata, handles)
img = handles.CurrentImage;
noisy = imnoise(img, 'gaussian', 0, 0.1);
handles.CurrentImage = noisy;
axes(handles.axes1);
imshow(noisy);
guidata(hObject, handles);


% Poisson Noise
function pushbutton4_Callback(hObject, eventdata, handles)
img = handles.CurrentImage;
noisy = imnoise(img, 'poisson');
handles.CurrentImage = noisy;
axes(handles.axes1);
imshow(noisy);
guidata(hObject, handles);


% Histogram
function pushbutton5_Callback(hObject, eventdata, handles)
img = handles.CurrentImage;
if size(img, 3) == 3
    img = rgb2gray(img);
end
[counts, grayLevels] = imhist(img);
pdf = counts / numel(img);
figure;
plot(grayLevels, pdf);
title('Histogram-based PDF');
xlabel('Gray Level'); ylabel('Probability');


% Autocorrelation
function pushbutton6_Callback(hObject, eventdata, handles)
img = handles.CurrentImage;
if size(img, 3) == 3
    img = rgb2gray(img);
end
autoCorr = xcorr2(double(img));
figure;
imagesc(autoCorr); colormap('jet'); colorbar;
title('Autocorrelation of Image');

% PSD
function pushbutton7_Callback(hObject, eventdata, handles)
img = handles.CurrentImage;
if size(img, 3) == 3
    img = rgb2gray(img);
end
F = fftshift(fft2(double(img)));
PSD = abs(F).^2;
figure;
imagesc(log(1 + PSD)); colormap('jet'); colorbar;
title('Power Spectral Density');


% Noise averaging
function pushbutton8_Callback(hObject, eventdata, handles)
img = handles.OriginalImage;
if size(img, 3) == 3
    img = rgb2gray(img);
end
img = im2double(img);
num_images = 10;
noisy_sum = zeros(size(img));
for i = 1:num_images
    noisy_img = imnoise(img, 'gaussian', 0, 0.01);
    noisy_sum = noisy_sum + noisy_img;
end
avg_img = noisy_sum / num_images; 
axes(handles.axes1);
imshow(avg_img, []);
title(['Noise Averaging with ', num2str(num_images), ' Images']);
handles.CurrentImage = avg_img;
guidata(hObject, handles);


% Function g(x)
function pushbutton9_Callback(hObject, eventdata, handles)
img = handles.CurrentImage;
if size(img,3) == 3
    img = rgb2gray(img);
end
img = im2double(img);
gx = log(1 + img);
axes(handles.axes1);
imshow(gx, []);
title('g(x) = log(1 + x)');
handles.CurrentImage = gx;
guidata(hObject, handles);

% Central Moments
function pushbutton10_Callback(hObject, eventdata, handles)
img = handles.CurrentImage;
if size(img, 3) == 3
    img = rgb2gray(img);
end
img = double(img(:));
mu = mean(img);
M2 = mean((img - mu).^2);
M3 = mean((img - mu).^3);
msgbox(sprintf('2nd Moment (Variance): %.2f\n3rd Moment (Skewness): %.2f', M2, M3), 'Central Moments');


% RGB Covariance
function pushbutton11_Callback(hObject, eventdata, handles)
img = handles.CurrentImage;
if size(img, 3) ~= 3
    errordlg('Image is not RGB.');
    return;
end
R = double(img(:,:,1));
G = double(img(:,:,2));
B = double(img(:,:,3));
vec = [R(:), G(:), B(:)];
covRGB = cov(vec);
msgbox(sprintf('Covariance Matrix:\nR-G: %.2f\nR-B: %.2f\nG-B: %.2f', ...
    covRGB(1,2), covRGB(1,3), covRGB(2,3)), 'RGB Covariance');
