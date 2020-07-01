close all;
clear all;
clc;
%%
datQ = importdata('C:\Users\svrkr\Downloads\CSV FIles-20200623T113015Z-001\CSV FIles\Capture_Meta_Wrist_Compute_Heart_rate.csv');
datq = datQ.data;
%x = datq(:,1);
xs = datq(:,3);
ys = datq(:,4);
%y = datq(:,2);

%%
fps = length(xs)/(xs(end)-xs(1));
h = hamming(length(ys));

yh = h.*ys;
yh = yh- mean(yh);
yft = fft(yh);
phase = angle(yft);
ft = abs(yft);
%ft = ft-mean(ft);

freq = 60*fps/length(ys)*linspace(0,length(ys)/2+1,length(ys)/2+1);

prun = ft(freq > 50 & freq < 180);
[m,id] = max(prun)

pfreq = freq(freq > 50 & freq < 180);
phas = phase(freq > 50 & freq < 180);

disp(pfreq(id));

%%

ymod = modwt(ys,'sym4');

figure;
for i=1:8
    subplot(8,1,i); plot(ymod(i,:));
end
%%
ymk = ymod;
ymk(1:2,:) = 0*ymod(1:2,:);
ymk(3:4,:) = 1*ymod(3:4,:);
ymk(5:end,:) = 0*ymod(5:end,:);

yk = imodwt(ymk,'sym4');

[wt,f] = cwt(ys,fps,'amor'); % MORLET
%%
%ywt = icwt(wt,f, [1 4]);
%%
engA = sum(abs(wt).^2,2);

engB = engA(f >= 1 & f <= 4);
fprun = f(f>=1 & f<=4);
wtx = zeros(size(wt));
il = find(f>=1 & f<=4);
%wtx(il,:) = wt(il,:);

for i=1:length(f)
   if(f(i) > 1 && f(i) < 4)
       wtx(i,:)=wt(i,:);
   end
end
yrc = icwt(wtx);


[mh,idx] = max(engB);
disp(fprun(idx))
HR = fprun(idx)*60*fps/length(f);
disp(HR);
%%
%ywt1 = icwt(wt,f, [0.5 1]);
%%
engC = sum(abs(wt).^2,2);
engD = engC(f >= 0.5 & f < 1);
fprun1 = f(f>=0.5 & f< 1);

wtx1 = zeros(size(wt));
%il = find(f>=1 & f<=4);
%wtx(il,:) = wt(il,:);

for i=1:length(f)
   if(f(i) > 0.5 && f(i) < 1)
       wtx1(i,:)=wt(i,:);
   end
end
yrc1 = icwt(wtx1);

[mr,idx1] = max(engD);
disp(fprun1(idx1))
RR = fprun1(idx1)*60*fps/length(f);
disp(RR);

figure;
subplot(3,1,1);plot(xs,ys);title('Raw Signal');
subplot(3,1,2);plot(xs,yrc);title('Reconstructed HR Rate Signal using algo');%str = strcat("HeartRate (bpm) = " , string(HR)); ylim = get(gca,'ylim');xlim=get(gca,'xlim');text(xlim(1)+1,ylim(2)-1,str);
%subplot(4,1,3);plot(xs,ywt1);title('Extraced Respiration Rate Signal');str = strcat("RespirationRate (per minute)= " , string(RR)); ylim = get(gca,'ylim');xlim=get(gca,'xlim');text(xlim(1)+1,ylim(2)-1,str);
%subplot(3,1,3);plot(xs,yrc1);title('Reconstructed RR Rate Signal using algo');

yftk = fft(yrc);
phasek = angle(yftk);
ftk = abs(yftk);
ftk = ftk-mean(ftk);

prunk = ftk(freq > 50 & freq < 180);
[~,idk] = max(prunk);

pfreq = freq(freq > 50 & freq < 180);
phas = phase(freq > 50 & freq < 180);
disp(idk);
disp(pfreq(idk));

yftk1 = fft(yrc1);
phasek1 = angle(yftk1);
ftk1 = abs(yftk1);
ftk1 = ftk1-mean(ftk1);

prunk1 = ftk1(freq > 24 & freq <= 50);
[~,idk1] = max(prunk1);

pfreq1 = freq(freq > 24 & freq <= 50);
phas1 = phase(freq > 24 & freq <= 50);
disp(idk1);
disp(pfreq1(idk1));

str = strcat("HeartRate (bpm) = " , string(pfreq(idk))); ylim = get(gca,'ylim');xlim=get(gca,'xlim');text(xlim(1)+1,ylim(2)-0.5,str);
subplot(3,1,3);plot(xs,yrc1);title('Reconstructed RR Rate Signal using algo');
str = strcat("RespirationRate (per minute) = " , string(pfreq1(idk1))); ylim = get(gca,'ylim');xlim=get(gca,'xlim');text(xlim(1)+1,ylim(2)-0.5,str);
