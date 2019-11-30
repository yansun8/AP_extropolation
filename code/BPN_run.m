

for bp=1:numn
allx=randperm(nsites);
ksites=floor(0.85*nsites);
tsites=nsites-ksites;
testind=nan(tsites,1);

for mm=1:tsites
    testind(mm)=allx(mm);
end
trainind=setdiff(site_ind,testind);
P_tr=nan(vv,length(trainind));
T_tr=nan(length(trainind),1);
for mm=1:length(trainind)
P_tr(:,mm)=P(:,trainind(mm));
T_tr(mm)=T(trainind(mm));
end
T_tr=T_tr';
 P_te=nan(vv,length(testind));
 T_te=nan(length(testind),1);
 for mm=1:length(testind)
 P_te(:,mm)=P(:,testind(mm));
 T_te(mm)=T(testind(mm));
 end
 T_te=T_te';

%% BP

net=newff(P_tr,T_tr,[10 5],{'tansig'},'trainrp','learngdm');
net=init(net);
 net.divideParam.trainRatio = 70/100;
 net.divideParam.valRatio = 15/100;
 net.divideParam.testRatio = 15/100;
 net.trainParam.max_fail=100;
net.trainParam.goal=0.2;
net.trainParam.lr=0.001;
net.trainParam.epochs=500;
net.inputs{1}.processFcns ={'removeconstantrows','mapminmax'};
net.trainParam.showWindow = false; 

[net,tr]=train(net,P_tr,T_tr);
Y_tr=sim(net,P_tr);
r=corrcoef(exp(Y_tr'),exp(T_tr'));
R1_train(bp)=r(1,2)^2;
retr(bp)=rmse(exp(Y_tr'),exp(T_tr'));

Y_te=sim(net,P_te);
r=corrcoef(exp(Y_te'),exp(T_te'));
R1_test(bp)=r(1,2)^2;
remm(bp)=rmse(exp(Y_te'),exp(T_te'));
BP_RESM(bp).tree=net;

value=sim(net,XXtt);
Ytt(bp)=value;
diff(bp)=abs(exp(value)-exp(Ttt));
end

 RXX=[R1_train,R1_test,remm,retr];
 [dd,ddd]=find(RXX(:,1)<0.6|RXX(:,2)<0.5|RXX(:,3)>10|RXX(:,4)>15);
 RXX(dd,:)=[];BP_RESM(dd)=[];
 Ytt(dd)=[];




