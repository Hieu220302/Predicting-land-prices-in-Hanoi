function  VoiceAndUnvoice( file_wav,file_lab, file_tilte) 

%input
   figure('Name',file_tilte);
   [data, fs] = wavread(file_wav);
    file = fopen(file_lab,'r');% doc file du lieu cua thay
    dataread = textscan(file,'%s'); %doc dl file lab
    dataread = dataread{1:end};
    dataread = dataread(1:end-4);
    dataread = reshape(dataread,3,length(dataread)/3);
    fclose(file);
    %gan du lieu vao
    sil = [];v = [];uv = []; %tao mang voice unvoice
    sizedata = size(dataread);
        for i = 1:sizedata(2)
            if (strcmp(dataread(3,i),'sil'))
                sil = [sil ; [dataread(1,i), dataread(2,i)]];
            end
            if (strcmp(dataread(3,i),'uv'))
                uv = [uv ; [dataread(1,i), dataread(2,i)]];
            end
            if (strcmp(dataread(3,i),'v'))
                v = [v ; [dataread(1,i), dataread(2,i)]];
            end
        end
    uv = str2double(uv);
    v = str2double(v);
    sil = str2double(sil);

% chuan hoa data 
data = normalise(data);

%cho moi frame dai 0.02s
f_d= 0.02;
% chia framing
frames = Framing(data,f_d,fs);

zcr = ZCR(frames); % Tinh ZRC
ste = STE(frames); %Tinh STE

[r,c] = size(frames); % c= frame_size , r = n_f


%tim nguong STE
f_ste = [];
g_ste = [];

for i = 1:length(uv)
    f_ste = [f_ste; ste(uv(i,1)/0.02:uv(i,2)/0.02)];
end
for i = 1:length(v)
    g_ste = [g_ste; ste(v(i,1)/0.02:v(i,2)/0.02)];
end
% nguong STE
T_ste = FindThreshold(f_ste,g_ste);


ste_nor = norSTEvsZCR(ste,T_ste); %chuan hoa ste

f_size = round(f_d * fs);
ste_wave = 0;
for j = 1 : length(ste_nor)
    l = length(ste_wave);
    ste_wave(l : l + f_size) = ste_nor(j);
end
%tinh thoi gian ve do thi ste
t = [0 : 1/fs : length(data)/fs]; 
t = t(1:end - 1);
t1 = [0 : 1/fs : length(ste_wave)/fs];
t1 = t1(1:end - 1);


%tim nguong ZCR
f_zcr = [];
g_zcr = [];

for i = 1:length(uv)
    f_zcr = [f_zcr; zcr(uv(i,1)/0.02:uv(i,2)/0.02)]; % luu gia tri nang luong vo thanh 
end
for i = 1:length(v)
    g_zcr = [g_zcr; zcr(v(i,1)/0.02:v(i,2)/0.02)]; % luu gia tri huu thanh
end
T_zcr = FindThreshold(f_zcr,g_zcr);
% chuan hoa zcr
zcr_nor = norSTEvsZCR(zcr,T_zcr);

f_size = round(f_d * fs);
zcr_wave = 0;
for j = 1 : length(zcr_nor)
    l = length(zcr_wave);
    zcr_wave(l : l + f_size) = zcr_nor(j);
end
% tinh thoi gian 
t2 = [0 : 1/fs : length(zcr_wave)/fs];
t2 = t2(1:end - 1);

% P =ste- zcr 
P = ste_wave - zcr_wave;

% phan loai voice and unvoice 
vauv = []; 
for i = 1 : length(P)
    if( ste_wave(i) < -0.95) 
        vauv(i) = -1;
    elseif(P(i) >= 0)
        vauv(i) = i/fs; %tinh ra thoi gian 0.5
   
    elseif(P(i) < 0)
        vauv(i) = -1; %unvoice gan = -1
    end
end

%Ve do thi
subplot(3,1,1)

t_data = linspace(0, length(data)/fs, length(data));

plot(t_data,data,'blue'); xlabel ('time(s)') ,ylabel ('Amplitude');
title('STE And ZCR');hold on;

plot(t1,ste_wave,'red','LineWidth',2);
plot(t2,zcr_wave,'black','LineWidth',2);
legend('Speech Signal','STE','ZCR');

subplot(3,1,2)
plot(t_data,data);xlabel ('time(s)') ,ylabel ('Amplitude');
title('Voice And Unvoice'); hold on; 

for i = 2: length(vauv)
    y = [-1 1];
    if(vauv(i) ~= -1) && (vauv(i-1) == -1)
         line([vauv(i), vauv(i)], y, 'color', 'green', 'linestyle', '-', 'linewidth', 1); %red = voice
         text(vauv(i),-0.75,'V');
    elseif (vauv(i-1) ~= -1) && (vauv(i) == -1)
        line([vauv(i-1), vauv(i-1)], y, 'color', 'green', 'linestyle', '-', 'linewidth', 1); %blue = unvoice
        text(vauv(i-1),-0.75,'U');
    end
    
end


%ve thu cong dua tren du lieu thay cho 
subplot(3,1,3);
plot(t,data);xlabel ('time(s)') ,ylabel ('Amplitude');
title('Input');
for i = 1:length(v)
        line([v(i,1),v(i,1)],[-1,1],'Color','red','LineStyle','-','LineWidth',1);
       line([v(i,2),v(i,2)],[-1,1],'Color','red','LineStyle','-','LineWidth',1); 
        text(v(i,1),-0.75,'V');
end
for i = 1:length(uv)
        line([uv(i,1),uv(i,1)],[-1,1],'Color','red','LineStyle','-','LineWidth',1);
       line([uv(i,2),uv(i,2)],[-1,1],'Color','red','LineStyle','-','LineWidth',1); 
        text(uv(i,1),-0.75,'U');
end




