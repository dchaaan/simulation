function varargout = sir(varargin)
% SIR MATLAB code for sir.fig
%      SIR, by itself, creates a new SIR or raises the existing
%      singleton*
%
%      H = SIR returns the handle to a new SIR or the handle to
%      the existing singleton*.
%
%      SIR('CALLBACK',hObject,eventData,handles,..  .) calls the local
%      function named CALLBACK in SIR.M with the given input arguments.
%
%      SIR('Property','Value',...) creates a new SIR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sir_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sir_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sir

% Last Modified by GUIDE v2.5 02-Feb-2013 18:15:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sir_OpeningFcn, ...
                   'gui_OutputFcn',  @sir_OutputFcn, ...
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


% --- Executes just before sir is made visible.
function sir_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sir (see VARARGIN)

% Choose default command line output for sir
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sir wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sir_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in btn_start.
function btn_start_Callback(hObject, eventdata, handles)
% •Ï”’è‹`
length = str2double(get(handles.city_length,'String')); % “ss‚Ì’·‚³
width = str2double(get(handles.city_width,'String')); % “ss‚ÌL‚³
police_man_max = str2double(get(handles.policemen,'String')); % Œx@”
police_speed = str2double(get(handles.speed,'String')); % Œx@ƒXƒs[ƒh
base_congestion = str2double(get(handles.congestion,'String')); % a‘Ø“ïˆÕ“x
day = str2double(get(handles.day,'String')); % “ú”


city = zeros(width, length); % “ss
time = 24 * day; % ŠÔ”
total = width * length; % ‘Œğ·“_”

FREE(1) = 0; % ’ÊíŒğ·“_”
CONGESTION(1) = 0; % a‘ØŒğ·“_”
BUSY_POLICE_MAN(1) = 0; % ‹Æ–±’†‚ÌŒx@”
FREE_POLICE_MAN(1) = 0; % ‘Ò‹@’†‚ÌŒx@”

% Œx@ˆÊ’u‚ğRandom‚Åİ’è‚·‚é
for police_index=1:police_man_max
    POLICE_POSITIONS(police_index,:,:,:) = [0, round(1 + (width-1).*rand(1,1)), round(1 + (length-1).*rand(1,1)), 0];
end


% ƒ‹[ƒvŠJn
for hour=1:time
    congestion = base_congestion;
    % ŠÔ‚²‚Æ‚Éa‘Ø“ïˆÕ“x‚ª•Ï‚í‚é
    if mod(hour, 24) >= 8 & mod(hour, 24) <= 9
        congestion = base_congestion - 0.005;
    end
    if mod(hour, 24) >= 18 & mod(hour, 24) <= 20
        congestion = base_congestion - 0.005;
    end
    
    
    % a‘Ø‚É‚È‚éŠ‚Â’N‚àŒü‚©‚Á‚Ä‚¢‚È‚¢ƒ|ƒCƒ“ƒg‚ğ•Û‘¶‚·‚é”z—ñ
    temp_delayed_points_without_police = [];
    % a‘Ø‚É‚È‚éƒ|ƒCƒ“ƒg”
    temp_delayed_point_cnt = 0;
    
    
    % a‘Ø‚ğ”­¶‚·‚é
    for length_index = 1:length
        for width_index = 1:width
            if city(width_index, length_index) == 0
                % a‘Ø‚Å‚Í‚È‚¢ƒ|ƒCƒ“ƒg‚Íƒ‰ƒ“ƒ_ƒ€‚Åa‘Ø‚ğ”­¶‚³‚¹‚é
                if rand(1,1) > congestion
                    % ƒ‰ƒ“ƒ_ƒ€‚ÌŒ‹‰Ê‚Ía‘Ø“ïˆÕ“x‚æ‚è‘å‚«‚¢ê‡Aa‘Ø‚ª”­¶‚·‚é
                    city(width_index, length_index) = 1;
                end
            end
            
            % a‘Ø‚Å‚ ‚éê‡A•Û‘¶‚·‚é
            if city(width_index, length_index) > 0
                temp_delayed_point_cnt = temp_delayed_point_cnt + 1;
                
                if city(width_index, length_index) == 1
                    insert_index = numel(temp_delayed_points_without_police)/2 + 1;
                    temp_delayed_points_without_police(insert_index,:) = [width_index, length_index];
                end
            end
        end
    end
    
    % Œx@‚ğ–½—ß‚·‚é
    for temp_delayed_point_index = 1: numel(temp_delayed_points_without_police)/2
        % –½—ß‚³‚ê‚éŒx@‚Ìindex
        police_go = 0;
        % –½—ß‚³‚ê‚éŒx@‚Æ–Ú“Iæ‚Ì‹——£
        min_distance = 9999;
        
        % Œx@‚ğƒ‹[ƒv‚µ‚ÄAƒtƒŠ[‚ÌŒx@‚ğŒvZ‚·‚é
        for police_index=1:police_man_max
            % Œx@‚ªƒtƒŠ[‚Å‚·‚©H
            if POLICE_POSITIONS(police_index,1,:,:) == 0
                % ƒtƒŠ[‚Ìê‡A‚±‚ÌŒx@‚Æ–Ú“Iæ‚Ì‹——£‚ğŒvZ‚·‚é
                temp_distance = abs(temp_delayed_points_without_police(temp_delayed_point_index, 1) - POLICE_POSITIONS(police_index,2,:,:)) + abs(temp_delayed_points_without_police(temp_delayed_point_index, 2) - POLICE_POSITIONS(police_index,3,:,:));
                
                % Å’Z‹——£‚æ‚è’Z‚¢ê‡A–½—ß‚³‚ê‚él‚É‚È‚é
                if temp_distance < min_distance
                    police_go = police_index;
                    min_distance = temp_distance;
                end
            end
        end
        
        
        if police_go == 0
            % 0‚Ìê‡‚Æ‚¢‚¤ˆÓ–¡‚ÍƒtƒŠ[Œx@‚ª‚¢‚È‚¢B
            break;
        else
            % –½—ß‚³‚ê‚éŒx@‚Ìó‘Ô‚ğXV‚·‚é
            POLICE_POSITIONS(police_go,1,:,:) = 1; % ó‘Ô
            POLICE_POSITIONS(police_go,2,:,:) = temp_delayed_points_without_police(temp_delayed_point_index, 1); % –Ú“Iæ‚Ìwidth
            POLICE_POSITIONS(police_go,3,:,:) = temp_delayed_points_without_police(temp_delayed_point_index, 2); % –Ú“Iæ‚Ìlength
            POLICE_POSITIONS(police_go,4,:,:) = min_distance; % ‹——£
            
            % –Ú“Iæ‚Ìó‘Ô‚ğXV‚·‚é
            city(temp_delayed_points_without_police(temp_delayed_point_index, 1), temp_delayed_points_without_police(temp_delayed_point_index, 2)) = 2;
        end
    end
    
    % Œx@‚ğˆÚ“®‚³‚¹‚ÄA“’…‚µ‚½‚çAƒ|ƒCƒ“ƒg‚Ìó‘Ô‚ğ•Ï‚¦‚é
    busy_police_man = 0;
    
    for police_index=1:police_man_max
        
        if POLICE_POSITIONS(police_index,1,:,:) == 1
            POLICE_POSITIONS(police_index,4,:,:) = POLICE_POSITIONS(police_index,4,:,:) - police_speed;
            if POLICE_POSITIONS(police_index,4,:,:) <= 0
                % “’…‚µ‚½ê‡
                
                % Œx@‚Ìó‘Ô‚ğXV‚·‚é
                POLICE_POSITIONS(police_index,1,:,:) = 0; % ó‘Ô
                POLICE_POSITIONS(police_index,4,:,:) = 0; % ‹——£
                
                % “ss‚Ìƒ|ƒCƒ“ƒg‚Ìó‘Ô‚ğXV‚·‚é
                city(POLICE_POSITIONS(police_index,2,:,:), POLICE_POSITIONS(police_index,3,:,:)) = 0;
                
                % a‘Ø‚É‚È‚éƒ|ƒCƒ“ƒg”‚ğXV‚·‚é
                temp_delayed_point_cnt = temp_delayed_point_cnt - 1;
            end
        end
        
        if POLICE_POSITIONS(police_index,1,:,:) == 1
            busy_police_man = busy_police_man + 1;
        end
    end
    
    % ƒOƒ‰ƒt‚Éo—Í‚·‚é
    FREE(hour) = total - temp_delayed_point_cnt; % ’ÊíŒğ·“_”
    CONGESTION(hour) =  temp_delayed_point_cnt; % a‘ØŒğ·“_”
    BUSY_POLICE_MAN(hour) = busy_police_man; % ‹Æ–±’†Œx@”
    FREE_POLICE_MAN(hour) = police_man_max - busy_police_man; % ‘Ò‹@Œx@”
end


grid on; % insert grid to graph
hour=1:time;
subplot(2,2,1);plot(hour, FREE(hour),'r*');title('’ÊíŒğ·“_”');grid on;
subplot(2,2,2);plot(hour, CONGESTION(hour),'y*');title('a‘ØŒğ·“_”');grid on;
subplot(2,2,3);plot(hour, FREE_POLICE_MAN(hour),'g*');title('‘Ò‹@Œx@”');grid on;
subplot(2,2,4);plot(hour, BUSY_POLICE_MAN(hour),'g*');title('‹Æ–±’†Œx@”');grid on;


% --- Executes on button press in btn_clear.
function btn_clear_Callback(hObject, eventdata, handles)


% hObject    handle to btn_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function city_length_Callback(hObject, eventdata, handles)
% hObject    handle to city_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of city_length as text
%        str2double(get(hObject,'String')) returns contents of city_length as a double


% --- Executes during object creation, after setting all properties.
function city_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to city_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function city_width_Callback(hObject, eventdata, handles)
% hObject    handle to city_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of city_width as text
%        str2double(get(hObject,'String')) returns contents of city_width as a double


% --- Executes during object creation, after setting all properties.
function city_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to city_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function policemen_Callback(hObject, eventdata, handles)
% hObject    handle to policemen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of policemen as text
%        str2double(get(hObject,'String')) returns contents of policemen as a double


% --- Executes during object creation, after setting all properties.
function policemen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to policemen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function speed_Callback(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speed as text
%        str2double(get(hObject,'String')) returns contents of speed as a double


% --- Executes during object creation, after setting all properties.
function speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function congestion_Callback(hObject, eventdata, handles)
% hObject    handle to congestion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of congestion as text
%        str2double(get(hObject,'String')) returns contents of congestion as a double


% --- Executes during object creation, after setting all properties.
function congestion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to congestion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function day_Callback(hObject, eventdata, handles)
% hObject    handle to day (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of day as text
%        str2double(get(hObject,'String')) returns contents of day as a double


% --- Executes during object creation, after setting all properties.
function day_CreateFcn(hObject, eventdata, handles)
% hObject    handle to day (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
