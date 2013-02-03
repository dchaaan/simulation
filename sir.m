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
% �ϐ���`
length = str2double(get(handles.city_length,'String')); % �s�s�̒���
width = str2double(get(handles.city_width,'String')); % �s�s�̍L��
police_man_max = str2double(get(handles.policemen,'String')); % �x�@��
police_speed = str2double(get(handles.speed,'String')); % �x�@�X�s�[�h
base_congestion = str2double(get(handles.congestion,'String')); % �a�ؓ�Փx
day = str2double(get(handles.day,'String')); % ����


city = zeros(width, length); % �s�s
time = 24 * day; % ���Ԑ�
total = width * length; % �������_��

FREE(1) = 0; % �ʏ�����_��
CONGESTION(1) = 0; % �a�،����_��
BUSY_POLICE_MAN(1) = 0; % �Ɩ����̌x�@��
FREE_POLICE_MAN(1) = 0; % �ҋ@���̌x�@��

% �x�@�ʒu��Random�Őݒ肷��
for police_index=1:police_man_max
    POLICE_POSITIONS(police_index,:,:,:) = [0, round(1 + (width-1).*rand(1,1)), round(1 + (length-1).*rand(1,1)), 0];
end


% ���[�v�J�n
for hour=1:time
    congestion = base_congestion;
    % ���Ԃ��Ƃɏa�ؓ�Փx���ς��
    if mod(hour, 24) >= 8 & mod(hour, 24) <= 9
        congestion = base_congestion - 0.005;
    end
    if mod(hour, 24) >= 18 & mod(hour, 24) <= 20
        congestion = base_congestion - 0.005;
    end
    
    
    % �a�؂ɂȂ銎�N���������Ă��Ȃ��|�C���g��ۑ�����z��
    temp_delayed_points_without_police = [];
    % �a�؂ɂȂ�|�C���g��
    temp_delayed_point_cnt = 0;
    
    
    % �a�؂𔭐�����
    for length_index = 1:length
        for width_index = 1:width
            if city(width_index, length_index) == 0
                % �a�؂ł͂Ȃ��|�C���g�̓����_���ŏa�؂𔭐�������
                if rand(1,1) > congestion
                    % �����_���̌��ʂ͏a�ؓ�Փx���傫���ꍇ�A�a�؂���������
                    city(width_index, length_index) = 1;
                end
            end
            
            % �a�؂ł���ꍇ�A�ۑ�����
            if city(width_index, length_index) > 0
                temp_delayed_point_cnt = temp_delayed_point_cnt + 1;
                
                if city(width_index, length_index) == 1
                    insert_index = numel(temp_delayed_points_without_police)/2 + 1;
                    temp_delayed_points_without_police(insert_index,:) = [width_index, length_index];
                end
            end
        end
    end
    
    % �x�@�𖽗߂���
    for temp_delayed_point_index = 1: numel(temp_delayed_points_without_police)/2
        % ���߂����x�@��index
        police_go = 0;
        % ���߂����x�@�ƖړI��̋���
        min_distance = 9999;
        
        % �x�@�����[�v���āA�t���[�̌x�@���v�Z����
        for police_index=1:police_man_max
            % �x�@���t���[�ł����H
            if POLICE_POSITIONS(police_index,1,:,:) == 0
                % �t���[�̏ꍇ�A���̌x�@�ƖړI��̋������v�Z����
                temp_distance = abs(temp_delayed_points_without_police(temp_delayed_point_index, 1) - POLICE_POSITIONS(police_index,2,:,:)) + abs(temp_delayed_points_without_police(temp_delayed_point_index, 2) - POLICE_POSITIONS(police_index,3,:,:));
                
                % �ŒZ�������Z���ꍇ�A���߂����l�ɂȂ�
                if temp_distance < min_distance
                    police_go = police_index;
                    min_distance = temp_distance;
                end
            end
        end
        
        
        if police_go == 0
            % 0�̏ꍇ�Ƃ����Ӗ��̓t���[�x�@�����Ȃ��B
            break;
        else
            % ���߂����x�@�̏�Ԃ��X�V����
            POLICE_POSITIONS(police_go,1,:,:) = 1; % ���
            POLICE_POSITIONS(police_go,2,:,:) = temp_delayed_points_without_police(temp_delayed_point_index, 1); % �ړI���width
            POLICE_POSITIONS(police_go,3,:,:) = temp_delayed_points_without_police(temp_delayed_point_index, 2); % �ړI���length
            POLICE_POSITIONS(police_go,4,:,:) = min_distance; % ����
            
            % �ړI��̏�Ԃ��X�V����
            city(temp_delayed_points_without_police(temp_delayed_point_index, 1), temp_delayed_points_without_police(temp_delayed_point_index, 2)) = 2;
        end
    end
    
    % �x�@���ړ������āA����������A�|�C���g�̏�Ԃ�ς���
    busy_police_man = 0;
    
    for police_index=1:police_man_max
        
        if POLICE_POSITIONS(police_index,1,:,:) == 1
            POLICE_POSITIONS(police_index,4,:,:) = POLICE_POSITIONS(police_index,4,:,:) - police_speed;
            if POLICE_POSITIONS(police_index,4,:,:) <= 0
                % ���������ꍇ
                
                % �x�@�̏�Ԃ��X�V����
                POLICE_POSITIONS(police_index,1,:,:) = 0; % ���
                POLICE_POSITIONS(police_index,4,:,:) = 0; % ����
                
                % �s�s�̃|�C���g�̏�Ԃ��X�V����
                city(POLICE_POSITIONS(police_index,2,:,:), POLICE_POSITIONS(police_index,3,:,:)) = 0;
                
                % �a�؂ɂȂ�|�C���g�����X�V����
                temp_delayed_point_cnt = temp_delayed_point_cnt - 1;
            end
        end
        
        if POLICE_POSITIONS(police_index,1,:,:) == 1
            busy_police_man = busy_police_man + 1;
        end
    end
    
    % �O���t�ɏo�͂���
    FREE(hour) = total - temp_delayed_point_cnt; % �ʏ�����_��
    CONGESTION(hour) =  temp_delayed_point_cnt; % �a�،����_��
    BUSY_POLICE_MAN(hour) = busy_police_man; % �Ɩ����x�@��
    FREE_POLICE_MAN(hour) = police_man_max - busy_police_man; % �ҋ@�x�@��
end


grid on; % insert grid to graph
hour=1:time;
subplot(2,2,1);plot(hour, FREE(hour),'r*');title('�ʏ�����_��');grid on;
subplot(2,2,2);plot(hour, CONGESTION(hour),'y*');title('�a�،����_��');grid on;
subplot(2,2,3);plot(hour, FREE_POLICE_MAN(hour),'g*');title('�ҋ@�x�@��');grid on;
subplot(2,2,4);plot(hour, BUSY_POLICE_MAN(hour),'g*');title('�Ɩ����x�@��');grid on;


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
