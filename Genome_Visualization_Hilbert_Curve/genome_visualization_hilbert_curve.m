function varargout = biopro(varargin)
% BIOPRO M-file for biopro.fig
%      BIOPRO, by itself, creates a new BIOPRO or raises the existing
%      singleton*.
%
%      H = BIOPRO returns the handle to a new BIOPRO or the handle to
%      the existing singleton*.
%
%      BIOPRO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIOPRO.M with the given input arguments.
%
%      BIOPRO('Property','Value',...) creates a new BIOPRO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before biopro_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to biopro_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help biopro

% Last Modified by GUIDE v2.5 20-May-2012 11:51:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @biopro_OpeningFcn, ...
                   'gui_OutputFcn',  @biopro_OutputFcn, ...
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


% --- Executes just before biopro is made visible.
function biopro_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to biopro (see VARARGIN)

% Choose default command line output for biopro
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes biopro wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = biopro_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in abc.
function abc_Callback(hObject, eventdata, handles)
global abc N d colorenable
% hObject    handle to abc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%abc=importdata('abc.mat');
N=ceil(log(size(abc,2))/log(2)/2);
set(handles.rb0,'string',[num2str(2^(N-1)) '*' num2str(2^(N-1))])
set(handles.rb1,'string',[num2str(2^(N-2)) '*' num2str(2^(N-2))])
set(handles.rb2,'string',[num2str(2^(N-3)) '*' num2str(2^(N-3))])
%prepare the basic matrix for the program below
d=zeros(2^N);
[x y]=hilbertt(N);
x=x*2^N+(2^N+1)/2;
y=y*2^N+(2^N+1)/2;
if colorenable==0
for i=1:size(abc,2)
    if abc(i)=='A'||abc(i)=='T'
        d(x(i),y(i))=1;
    end
end
else
    for i=1:size(abc,2)
    if abc(i)=='A'
        d(x(i),y(i))=1;
    elseif abc(i)=='T'
         d(x(i),y(i))=2;
    elseif abc(i)=='C'
         d(x(i),y(i))=3;
    elseif abc(i)=='G'
        d(x(i),y(i))=4;
    end
    end
end
%show the process is over
set(handles.text3,'string','ok ¡Ì')
set(handles.orig,'enable','on')
set(handles.reduce4,'enable','on')



% --- Executes on button press in orig.
function orig_Callback(hObject, eventdata, handles)
% hObject    handle to orig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global d N colorenable choice_nf
if choice_nf
    figure
end
if colorenable==0 
[X,Y]=find(d==1);
X=X.';
Y=Y.';
X=[X-0.5;X+0.5;X+0.5;X-0.5];
Y=[Y-0.5;Y-0.5;Y+0.5;Y+0.5];
C=ones(size(X));
patch(X,Y,C,'edgecolor','none')
axis([0 2^N 0 2^N])
colormap gray
% enalbe section

else
[X,Y]=find(d==1);
X1=X.';
Y1=Y.';
[X,Y]=find(d==2);
X2=X.';
Y2=Y.';
[X,Y]=find(d==3);
X3=X.';
Y3=Y.';
[X,Y]=find(d==4);
X4=X.';
Y4=Y.';
X=[X1 X2 X3 X4];
Y=[Y1 Y2 Y3 Y4];
C=[ones(1,size(X1,2)),2*ones(1,size(X2,2)),3*ones(1,size(X3,2)),4*ones(1,size(X4,2))];
X=[X-0.5;X+0.5;X+0.5;X-0.5];
Y=[Y-0.5;Y-0.5;Y+0.5;Y+0.5];
C=repmat(C,4,1);
patch(X,Y,C,'edgecolor','none')
end
set(handles.plotgcf,'enable','on')
set(handles.plotnf,'enable','on')

%thanks to this piece of program from internet
function [x,y] = hilbertt(n)
%HILBERT Hilbert curve.
%source: http://www.mathworks.com/matlabcentral/fileexchange/4646,2010.11.20
% [x,y]=hilbert(n) gives the vector coordinates of points
%   in n-th order Hilbert curve of area 1.
% Example: plot of 5-th order curve
% [x,y]=hilbert(5);line(x,y)
%   Copyright (c) by Federico Forte
%   Date: 2000/10/06
if n<=0
  x=0;
  y=0;
else
  [xo,yo]=hilbertt(n-1);
  x=.5*[-.5+yo -.5+xo .5+xo  .5-yo];
  y=.5*[-.5+xo  .5+yo .5+yo -.5-xo];
end

% seperate the orig to 4 windows or less
% --- Executes on button press in rb0.
function rb0_Callback(hObject, eventdata, handles)
global N abc M
% hObject    handle to rb0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M=2^(N-1);
kmax=ceil(size(abc,2)/(M*M)-1);
set(handles.slider2,'Max',kmax)
set(handles.kmax,'string',kmax+1)
set(handles.slider2,'sliderstep',[1/kmax,0.1])
% when this button on, set others off
% then one can choose other rb after cancelling this button
temp=get(hObject,'Value') ;
if temp
   set(handles.rb1,'enable','off')
   set(handles.rb2,'enable','off')
else
   set(handles.rb1,'enable','on')
   set(handles.rb2,'enable','on')
   clear M
end
% Hint: get(hObject,'Value') returns toggle state of rb0

% --- Executes on button press in rb1.
function rb1_Callback(hObject, eventdata, handles)
global N abc M
% hObject    handle to rb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)M=2^(N-1);
M=2^(N-2);
kmax=ceil(size(abc,2)/(M*M)-1);
set(handles.slider2,'Max',kmax)
set(handles.kmax,'string',kmax+1)
set(handles.slider2,'sliderstep',[1/kmax,0.1])
temp=get(hObject,'Value') ;
if temp
   set(handles.rb0,'enable','off')
   set(handles.rb2,'enable','off')
else
   set(handles.rb0,'enable','on')
   set(handles.rb2,'enable','on')
   clear M
end

% Hint: get(hObject,'Value') returns toggle state of rb1


% --- Executes on button press in rb2.
function rb2_Callback(hObject, eventdata, handles)
global N abc M
% hObject    handle to rb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M=2^(N-3);
kmax=ceil(size(abc,2)/(M*M)-1);
set(handles.slider2,'Max',kmax)
set(handles.kmax,'string',kmax+1)
set(handles.slider2,'sliderstep',[1/kmax,0.1])
temp=get(hObject,'Value') ;
if temp
   set(handles.rb1,'enable','off')
   set(handles.rb0,'enable','off')
else
   set(handles.rb1,'enable','on')
   set(handles.rb0,'enable','on')
   clear M
end

% Hint: get(hObject,'Value') returns toggle state of rb2

% --- Executes on button press in delete.
function delete_Callback(hObject, eventdata, handles)
% hObject    handle to delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%try,delete(allchild(handles.axes1));end
cla
% the plotgcf which use axes[xmin xmax ymin ymax] to show the graph
% malfunction when their is nothing in the axes which is the result of cla
set(handles.plotgcf,'enable','off') 


% --- Executes on button press in reduce4.
function reduce4_Callback(hObject, eventdata, handles)
% hObject    handle to reduce4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global d e N choice_nf h0
%2012.5.5 matlab more knowledge about the usage of matrix instead of 
%single element when programming former 54s now 0.08s
% 1 1 1 white 0 0 0 black
temp=zeros(2^N,2^(N-1));
for i=1:2^(N-1)
    temp(:,i)=d(:,2*i-1)+d(:,2*i);
end
e=zeros(2^(N-1));
for i=1:2^(N-1)
    e(i,:)=temp(2*i-1,:)+temp(2*i,:);
end
[X,Y]=find(e>0);
X=X.';
Y=Y.';
C=e(e>0)/4;
X=2*[X-0.5;X+0.5;X+0.5;X-0.5];
Y=2*[Y-0.5;Y-0.5;Y+0.5;Y+0.5];
C=repmat(C.',4,1);
if choice_nf
    h0=figure;
end
patch(X,Y,C,'edgecolor','none')
colormap gray
colorbar
set(handles.reduce16,'enable','on')
clear temp
axis([0 2^N 0 2^N])
set(handles.plotgcf,'enable','on')
set(handles.plotnf,'enable','on')




% --- Executes on button press in reduce16.
function reduce16_Callback(hObject, eventdata, handles)
% hObject    handle to reduce16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get the 
global e N f h0 choice_nf
temp2=e/4;
temp=zeros(2^(N-1),2^(N-2));
for i=1:2^(N-2)
temp(:,i)=temp2(:,2*i-1)+temp2(:,2*i);
end
f=zeros(2^(N-2));
for i=1:2^(N-2)
    f(i,:)=temp(2*i-1,:)+temp(2*i,:);
end
[X,Y]=find(f>0);
X=X.';
Y=Y.';
C=f(f>0)/4;
% the 4* is used to show the graph with the same axis scope
% the patch *16
X=4*[X-0.5;X+0.5;X+0.5;X-0.5];
Y=4*[Y-0.5;Y-0.5;Y+0.5;Y+0.5];
C=repmat(C.',4,1);
if choice_nf
    h0=figure;
end
patch(X,Y,C,'edgecolor','none')
colormap gray
colorbar
% the overall scope of the graph is still 2^N*2^N
axis([0 2^N 0 2^N])
set(hObject,'enable','off')
set(handles.reduce64,'enable','on')
set(handles.plotgcf,'enable','on')

% --- Executes on button press in reduce64.
function reduce64_Callback(hObject, eventdata, handles)
% hObject    handle to reduce64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global f N h0 choice_nf
temp3=f/4;
temp=zeros(2^(N-2),2^(N-3));
for i=1:2^(N-3)
temp(:,i)=temp3(:,2*i-1)+temp3(:,2*i);
end
e=zeros(2^(N-3));
for i=1:2^(N-3)
    e(i,:)=temp(2*i-1,:)+temp(2*i,:);
end
[X,Y]=find(e>0);
X=X.';
Y=Y.';
C=e(e>0)/4;
%
X=8*[X-0.5;X+0.5;X+0.5;X-0.5];
Y=8*[Y-0.5;Y-0.5;Y+0.5;Y+0.5];
C=repmat(C.',4,1);
if choice_nf
    h0=figure;
end
patch(X,Y,C,'edgecolor','none')
colormap gray
colorbar
axis([0 2^N 0 2^N])
set(hObject,'enable','off')
set(handles.plotgcf,'enable','on')


% pinpoint the position of a certain base according to its order number
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)get(hObject,'String')
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global N
num=str2double(get(hObject,'String'));
[x y]=hilbertt(N);
x=x*2^N+(2^N+1)/2;
y=y*2^N+(2^N+1)/2;
text(x(num),y(num),['\leftarrow' num2str(num)] ,...
     'HorizontalAlignment','left','Color',[1 0 0],'Fontsize',12)



% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=get(hObject,'value')+1;
set(handles.screen,'string',['the order of the window: ' num2str(temp)])

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% plot in the axes provided in the fig
% --- Executes on button press in plotgcf.
function plotgcf_Callback(hObject, eventdata, handles)
global M abc N
% hObject    handle to plotgcf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% the different between figure and figure(gcf)
figure(gcf)
[x y]=hilbertt(N);
x=x*2^N+(2^N+1)/2;
y=y*2^N+(2^N+1)/2;
k=get(handles.slider2,'Value');
kmax=ceil(size(abc,2)/(M*M)-1);
if k<kmax
    xmin=min(x(1+M*M*k:M*M*(k+1)));
    xmax=max(x(1+M*M*k:M*M*(k+1)));
    ymin=min(y(1+M*M*k:M*M*(k+1)));
    ymax=max(y(1+M*M*k:M*M*(k+1)));
    axis([xmin-1,xmax+1,ymin-1,ymax+1])
elseif k==kmax
    xmin=min(x(1+M*M*k:size(abc,2)));
    xmax=max(x(1+M*M*k:size(abc,2)));
    ymin=min(y(1+M*M*k:size(abc,2)));
    ymax=max(y(1+M*M*k:size(abc,2)));
axis([xmin-1,xmax+1,ymin-1,ymax+1])    
end
% the difference move the window with a certain area around


% plot the original graph in another graph which can be amplified and saved
% with the default tools in matlab menu
function plotnf_Callback(hObject, eventdata, handles)
global M d abc N h0
% hObject    handle to plotnf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% produce the x,y matrix of hilbert element in integer form
[x y]=hilbertt(N);
x=x*2^N+(2^N+1)/2;
y=y*2^N+(2^N+1)/2;
% get the order of the window interested in
k=get(handles.slider2,'Value');
% the last window need some special method to cope with, thus get the kmax
kmax=ceil(size(abc,2)/(M*M)-1);
% preset the X,Y
X=zeros(1,nnz(d));
Y=zeros(1,nnz(d));
j=1;
if k<kmax
% pick up the 1s in the scope of a certain window to form another matrix
for i=1+M*M*k:M*M*(k+1)
    if d(x(i),y(i))==1
        X(j)=x(i);
        Y(j)=y(i);
        j=j+1;
    end
end
% the last window with imcomplete data
elseif k==kmax
    for i=1+M*M*k:size(abc,2)
    if d(x(i),y(i))==1
        X(j)=x(i);
        Y(j)=y(i);
        j=j+1;
    end
    end
end
% patch is needed plotting in another graph
X=[X-0.5;X+0.5;X+0.5;X-0.5];
Y=[Y-0.5;Y-0.5;Y+0.5;Y+0.5];
%patch(X,Y,'k','edgecolor','none')
% set the scope of the axes, >0 is needed to exclude 0s
axis(get(h0,'children'),[min(X(X>0.5))-1,max(X(X>0.5))+1,min(Y(Y>0.5))-1,max(Y(Y>0.5))+1])
colormap gray
figure(h0)



function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global temp_2 abc
[namearchivo,patharchivo]=uigetfile('*.mat');
if ~isequal(namearchivo,0)
    archivo=[patharchivo,namearchivo];
end
abc=importdata(archivo);
N=ceil(log(size(abc,2))/log(2)/2);
if N>12
    temp_1=2^(2*N)-size(abc,2);
    compensation=num2str(NaN*ones(1,temp_1));
    abc=horzcat(abc,compensation);
    temp_2=reshape(abc,2^24,2^(2*N-24)).';
    terminal=ceil(size(abc,2)/(2^24));
%set section
set(handles.surplus,'visible','on','string','the amount of the bases exceeds 2^24')
set(handles.mina,'visible','on')
set(handles.exceeds,'visible','on','visible','on', 'max',...
    terminal-1,'sliderstep',[1/(terminal-1) 0.1])
set(handles.maxa,'visible','on','string',terminal) 
set(handles.uipanel1,'visible','on')
end

function exceeds_Callback(hObject, eventdata, handles)
global temp_2 abc
% hObject    handle to exceeds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
kk=get(hObject,'Value')+1;
set(handles.xianshi,'string',num2str(kk))
abc=temp_2(kk,:);



% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
global d M k N
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
[x y]=hilbertt(N);
x=x*2^N+(2^N+1)/2;
y=y*2^N+(2^N+1)/2;
xmin=min(x(1+M*M*k:M*M*(k+1)));
ymin=min(y(1+M*M*k:M*M*(k+1)));
ymax=max(y(1+M*M*k:M*M*(k+1)));
temp=zeros(M,M/2);
for i=1:M/2
    temp(:,i)=d(ymin:ymax,2*i+xmin-2)+d(ymin:ymax,2*i+xmin-1);
end
e=zeros(M/2);
for i=1:M/2
    e(i,:)=temp(2*i-1,:)+temp(2*i,:);
end
[X,Y]=find(e>0);
X=X.';
Y=Y.';
C=e(e>0)/4;
X=2*[X-0.5;X+0.5;X+0.5;X-0.5];
Y=2*[Y-0.5;Y-0.5;Y+0.5;Y+0.5];
C=repmat(C.',4,1);
patch(X,Y,C,'edgecolor','none')
colormap gray
colorbar


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in choicenf.
function choicenf_Callback(hObject, eventdata, handles)
% hObject    handle to choicenf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of choicenf
global choice_nf
choice_nf=get(hObject,'Value');
set(handles.plotnf,'enable','on')


% --- Executes during object creation, after setting all properties.
function choicenf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choicenf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',0)


% --- Executes on button press in color.
function color_Callback(hObject, eventdata, handles)
% hObject    handle to color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of color
global colorenable
colorenable=get(hObject,'Value') ;
set(handles.abc,'enable','on')

% --- Executes during object creation, after setting all properties.
function color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'value',0)


% --- Executes during object creation, after setting all properties.
function exceeds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exceeds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% used to pinpoint the point interested in
% can be used after the original, the reduce, the windows
% --- Executes on button press in pp1.
function pp1_Callback(hObject, eventdata, handles)
% hObject    handle to pp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global N abc
p=ginput(1);
p=round(p);
[x y]=hilbertt(N);
x=x*2^N+(2^N+1)/2;
y=y*2^N+(2^N+1)/2;
for i=1:size(abc,2)
    if (p(1)==x(i)&&p(2)==y(i))
        % show the order number on this button
       set(hObject,'String',num2str(i));
    else continue
    end
    break
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
