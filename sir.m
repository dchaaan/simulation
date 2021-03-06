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
% 変数定義
length = str2double(get(handles.city_length,'String')); % 都市の長さ
width = str2double(get(handles.city_width,'String')); % 都市の広さ
police_man_max = str2double(get(handles.policemen,'String')); % 警察数
police_speed = str2double(get(handles.speed,'String')); % 警察スピード
base_congestion = str2double(get(handles.congestion,'String')); % 渋滞難易度
day = str2double(get(handles.day,'String')); % 日数


city = zeros(width, length); % 都市
time = 24 * day; % 時間数
total = width * length; % 総交差点数

FREE(1) = 0; % 通常交差点数
CONGESTION(1) = 0; % 渋滞交差点数
BUSY_POLICE_MAN(1) = 0; % 業務中の警察数
FREE_POLICE_MAN(1) = 0; % 待機中の警察数

% 警察位置をRandomで設定する
for police_index=1:police_man_max
    POLICE_POSITIONS(police_index,:,:,:) = [0, round(1 + (width-1).*rand(1,1)), round(1 + (length-1).*rand(1,1)), 0];
end


% ループ開始
for hour=1:time
    congestion = base_congestion;
    % 時間ごとに渋滞難易度が変わる
    if mod(hour, 24) >= 8 & mod(hour, 24) <= 9
        congestion = base_congestion - 0.005;
    end
    if mod(hour, 24) >= 18 & mod(hour, 24) <= 20
        congestion = base_congestion - 0.005;
    end
    
    
    % 渋滞になる且つ誰も向かっていないポイントを保存する配列
    temp_delayed_points_without_police = [];
    % 渋滞になるポイント数
    temp_delayed_point_cnt = 0;
    
    
    % 渋滞を発生する
    for length_index = 1:length
        for width_index = 1:width
            if city(width_index, length_index) == 0
                % 渋滞ではないポイントはランダムで渋滞を発生させる
                if rand(1,1) > congestion
                    % ランダムの結果は渋滞難易度より大きい場合、渋滞が発生する
                    city(width_index, length_index) = 1;
                end
            end
            
            % 渋滞である場合、保存する
            if city(width_index, length_index) > 0
                temp_delayed_point_cnt = temp_delayed_point_cnt + 1;
                
                if city(width_index, length_index) == 1
                    insert_index = numel(temp_delayed_points_without_police)/2 + 1;
                    temp_delayed_points_without_police(insert_index,:) = [width_index, length_index];
                end
            end
        end
    end
    
    % 警察を命令する
    for temp_delayed_point_index = 1: numel(temp_delayed_points_without_police)/2
        % 命令される警察のindex
        police_go = 0;
        % 命令される警察と目的先の距離
        min_distance = 9999;
        
        % 警察をループして、フリーの警察を計算する
        for police_index=1:police_man_max
            % 警察がフリーですか？
            if POLICE_POSITIONS(police_index,1,:,:) == 0
                % フリーの場合、この警察と目的先の距離を計算する
                temp_distance = abs(temp_delayed_points_without_police(temp_delayed_point_index, 1) - POLICE_POSITIONS(police_index,2,:,:)) + abs(temp_delayed_points_without_police(temp_delayed_point_index, 2) - POLICE_POSITIONS(police_index,3,:,:));
                
                % 最短距離より短い場合、命令される人になる
                if temp_distance < min_distance
                    police_go = police_index;
                    min_distance = temp_distance;
                end
            end
        end
        
        
        if police_go == 0
            % 0の場合という意味はフリー警察がいない。
            break;
        else
            % 命令される警察の状態を更新する
            POLICE_POSITIONS(police_go,1,:,:) = 1; % 状態
            POLICE_POSITIONS(police_go,2,:,:) = temp_delayed_points_without_police(temp_delayed_point_index, 1); % 目的先のwidth
            POLICE_POSITIONS(police_go,3,:,:) = temp_delayed_points_without_police(temp_delayed_point_index, 2); % 目的先のlength
            POLICE_POSITIONS(police_go,4,:,:) = min_distance; % 距離
            
            % 目的先の状態を更新する
            city(temp_delayed_points_without_police(temp_delayed_point_index, 1), temp_delayed_points_without_police(temp_delayed_point_index, 2)) = 2;
        end
    end
    
    % 警察を移動させて、到着したら、ポイントの状態を変える
    busy_police_man = 0;
    
    for police_index=1:police_man_max
        
        if POLICE_POSITIONS(police_index,1,:,:) == 1
            POLICE_POSITIONS(police_index,4,:,:) = POLICE_POSITIONS(police_index,4,:,:) - police_speed;
            if POLICE_POSITIONS(police_index,4,:,:) <= 0
                % 到着した場合
                
                % 警察の状態を更新する
                POLICE_POSITIONS(police_index,1,:,:) = 0; % 状態
                POLICE_POSITIONS(police_index,4,:,:) = 0; % 距離
                
                % 都市のポイントの状態を更新する
                city(POLICE_POSITIONS(police_index,2,:,:), POLICE_POSITIONS(police_index,3,:,:)) = 0;
                
                % 渋滞になるポイント数を更新する
                temp_delayed_point_cnt = temp_delayed_point_cnt - 1;
            end
        end
        
        if POLICE_POSITIONS(police_index,1,:,:) == 1
            busy_police_man = busy_police_man + 1;
        end
    end
    
    % グラフに出力する
    FREE(hour) = total - temp_delayed_point_cnt; % 通常交差点数
    CONGESTION(hour) =  temp_delayed_point_cnt; % 渋滞交差点数
    BUSY_POLICE_MAN(hour) = busy_police_man; % 業務中警察数
    FREE_POLICE_MAN(hour) = police_man_max - busy_police_man; % 待機警察数
end


grid on; % insert grid to graph
hour=1:time;
subplot(2,2,1);plot(hour, FREE(hour),'r*');title('通常交差点数');grid on;
subplot(2,2,2);plot(hour, CONGESTION(hour),'y*');title('渋滞交差点数');grid on;
subplot(2,2,3);plot(hour, FREE_POLICE_MAN(hour),'g*');title('待機警察数');grid on;
subplot(2,2,4);plot(hour, BUSY_POLICE_MAN(hour),'g*');title('業務中警察数');grid on;


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
