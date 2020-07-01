close all;
clear all;
clc;
%%
datQ = importdata('D:\WindowsFormsApp2\WindowsFormsApp2\WindowsFormsApp2\bin\x64\Debug\datTemp.txt');
datq = datQ.data;
x = datq(74:end,1);
xs = datq(74:end,2);
ys = datq(74:end,3);
y = datq(74:end,4);

%%
fps = length(xs)/(xs(end)-xs(1));
h = hamming(length(xs));

yh = h.*ys;

yft = fft(yh);
phase = angle(yft);
ft = abs(yft);
ft = ft-mean(ft);

freq = 60*fps/length(xs)*linspace(0,length(xs)/2+1,length(xs)/2+1);

prun = ft(freq > 50 & freq < 180);
[~,id] = max(prun);

pfreq = freq(freq > 50 & freq < 180);
phas = phase(freq > 50 & freq < 180);

disp(pfreq(id));

%%

ymod = modwt(ys,'sym4');

figure;
for i=1:8
    subplot(8,1,i); plot(xs,ymod(i,:));
end

ymk = ymod;
ymk(1:2,:) = 0*ymod(1:2,:);
ymk(3:4,:) = 1*ymod(3:4,:);
ymk(5:end,:) = 0*ymod(5:end,:);

yk = imodwt(ymk,'sym4');

[wt,f] = cwt(ys,fps);
ywt = icwt(wt,f, [1 4]);

engA = sum((wt).^2,2);

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


[~,idx] = max(engB);
HR = fprun(idx)*60*fps/length(f);
disp(HR);

ywt1 = icwt(wt,f, [0.5 1]);

engC = sum((wt).^2,2);
engD = engC(f >= 0.5 & f < 1);
fprun1 = f(f>=0.5 & f< 1);

[~,idx1] = max(engD);
RR = fprun1(idx1)*60*fps/length(f);
disp(RR);

figure;
subplot(4,1,1);plot(xs,ys);title('Raw Signal');
subplot(4,1,2);plot(xs,ywt);title('Extracted Heart Rate Signal');str = strcat("HeartRate (bpm) = " , string(HR)); ylim = get(gca,'ylim');xlim=get(gca,'xlim');text(xlim(1)+1,ylim(2)-1,str);
subplot(4,1,3);plot(xs,ywt1);title('Extraced Respiration Rate Signal');str = strcat("RespirationRate (per minute)= " , string(RR)); ylim = get(gca,'ylim');xlim=get(gca,'xlim');text(xlim(1)+1,ylim(2)-1,str);
subplot(4,1,4);plot(xs,yrc);title('Reconstructed HR Rate Signal using algo');

yftk = fft(yrc);
phasek = angle(yftk);
ftk = abs(yftk);
ftk = ftk-mean(ftk);

prunk = ftk(freq > 50 & freq < 180);
[~,idk] = max(prunk);

%pfreq = freq(freq > 50 & freq < 180);
%phas = phase(freq > 50 & freq < 180);
disp(idk);
disp(pfreq(idk));
str = strcat("HeartRate (bpm) = " , string(pfreq(idk))); ylim = get(gca,'ylim');xlim=get(gca,'xlim');text(xlim(1)+1,ylim(2)-1,str);