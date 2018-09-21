
##########KNN����
set.seed(12345)
x1<-runif(60,-1,1)  
x2<-runif(60,-1,1)  
y<-sample(c(0,1),size=60,replace=TRUE,prob=c(0.3,0.7))   
Data<-data.frame(Fx1=x1,Fx2=x2,Fy=y)  
SampleId<-sample(x=1:60,size=18)  
DataTest<-Data[SampleId,]   
DataTrain<-Data[-SampleId,]  

par(mfrow=c(2,2),mar=c(4,6,4,4))
plot(Data[,1:2],pch=Data[,3]+1,cex=0.8,xlab="x1",ylab="x2",main="ȫ������")
plot(DataTrain[,1:2],pch=DataTrain[,3]+1,cex=0.8,xlab="x1",ylab="x2",main="ѵ�������Ͳ�������")
points(DataTest[,1:2],pch=DataTest[,3]+16,col=2,cex=0.8)

library("class")
errRatio<-vector()   
for(i in 1:30){    
 KnnFit<-knn(train=Data[,1:2],test=Data[,1:2],cl=Data[,3],k=i)
 CT<-table(Data[,3],KnnFit)  
 errRatio<-c(errRatio,(1-sum(diag(CT))/sum(CT))*100)     
}
plot(errRatio,type="l",xlab="���ڸ���K",ylab="������(%)",main="������K�������",ylim=c(0,80))

errRatio1<-vector()   
for(i in 1:30){
 KnnFit<-knn(train=DataTrain[,1:2],test=DataTest[,1:2],cl=DataTrain[,3],k=i) 
 CT<-table(DataTest[,3],KnnFit) 
 errRatio1<-c(errRatio1,(1-sum(diag(CT))/sum(CT))*100)    
}
lines(1:30,errRatio1,lty=2,col=2)

set.seed(12345)
errRatio2<-vector()   
for(i in 1:30){   
 KnnFit<-knn.cv(train=Data[,1:2],cl=Data[,3],k=i) 
 CT<-table(Data[,3],KnnFit)  
 errRatio2<-c(errRatio2,(1-sum(diag(CT))/sum(CT))*100)     
}
lines(1:30,errRatio2,col=2)

##############KNN�ع�
set.seed(12345)
x1<-runif(60,-1,1)  
x2<-runif(60,-1,1)  
y<-runif(60,10,20)   
Data<-data.frame(Fx1=x1,Fx2=x2,Fy=y)
SampleId<-sample(x=1:60,size=18)  
DataTest<-Data[SampleId,]  
DataTrain<-Data[-SampleId,]  
mseVector<-vector()    
for(i in 1:30){
 KnnFit<-knn(train=DataTrain[,1:2],test=DataTest[,1:2],cl=DataTrain[,3],k=i,prob=FALSE) 
 KnnFit<-as.double(as.vector(KnnFit))   
 mse<-sum((DataTest[,3]-KnnFit)^2)/length(DataTest[,3])   
 mseVector<-c(mseVector,mse)
}
plot(mseVector,type="l",xlab="���ڸ���K",ylab="�������",main="������K��������",ylim=c(0,80))

##############��è�ɽ��˿͵ķ���Ԥ��
library("class") 
Tmall_train<-read.table(file="��è_Train_1.txt",header=TRUE,sep=",")
head(Tmall_train)
Tmall_train$BuyOrNot<-as.factor(Tmall_train$BuyOrNot)
Tmall_test<-read.table(file="��è_Test_1.txt",header=TRUE,sep=",")
Tmall_test$BuyOrNot<-as.factor(Tmall_test$BuyOrNot)
set.seed(123456)
errRatio<-vector()   
for(i in 1:30){
 KnnFit<-knn(train=Tmall_train[,-1],test=Tmall_test[,-1],cl=Tmall_train[,1],k=i,prob=FALSE) 
 CT<-table(Tmall_test[,1],KnnFit) 
 errRatio<-c(errRatio,(1-sum(diag(CT))/sum(CT))*100)    
}
plot(errRatio,type="b",xlab="���ڸ���K",ylab="������(%)",main="��è�ɽ��˿ͷ���Ԥ���еĽ�����K�������")

####��è����KNN�������۱�����Ҫ��
library("class")  
par(mfrow=c(2,2))
set.seed(123456)
errRatio<-vector()   
for(i in 1:30){
 KnnFit<-knn(train=Tmall_train[,-1],test=Tmall_test[,-1],cl=Tmall_train[,1],k=i,prob=FALSE) 
 CT<-table(Tmall_test[,1],KnnFit) 
 errRatio<-c(errRatio,(1-sum(diag(CT))/sum(CT))*100)    
}
plot(errRatio,type="l",xlab="���ڸ���K",ylab="������(%)",main="������K�������")
errDelteX<-errRatio[7]
for(i in -2:-5){
 fit<-knn(train=Tmall_train[,c(-1,i)],test=Tmall_test[,c(-1,i)],cl=Tmall_train[,1],k=7)
 CT<-table(Tmall_test[,1],fit)
 errDelteX<-c(errDelteX,(1-sum(diag(CT))/sum(CT))*100)
}
plot(errDelteX,type="l",xlab="�޳�����",ylab="�޳�������(%)",main="�޳������������(K=7)",cex.main=0.8)
xTitle=c("1:ȫ�����","2:���ѻ�Ծ��","3:��Ծ��","4:�ɽ���Ч��","5:���Ч��")
legend("topright",legend=xTitle,title="����˵��",lty=1,cex=0.6)   
FI<-errDelteX[-1]+1/4   
wi<-FI/sum(FI)       
GLabs<-paste(c("���ѻ�Ծ��","��Ծ��","�ɽ���Ч��","���Ч��"),round(wi,2),sep=":")
pie(wi,labels=GLabs,clockwise=TRUE,main="�������Ȩ��",cex.main=0.8)
ColPch=as.integer(as.vector(Tmall_test[,1]))+1
plot(Tmall_test[,c(2,4)],pch=ColPch,cex=0.7,xlim=c(0,50),ylim=c(0,50),col=ColPch,
     xlab="���ѻ�Ծ��",ylab="�ɽ���Ч��",main="��ά�����ռ��еĹ۲�",cex.main=0.8)

############��è���ݼ�ȨKNN����
install.packages("kknn")
library("kknn")
par(mfrow=c(2,1))
Tmall_train<-read.table(file="��è_Train_1.txt",header=TRUE,sep=",")
Tmall_train$BuyOrNot<-as.factor(Tmall_train$BuyOrNot)
fit<-train.kknn(formula=BuyOrNot~.,data=Tmall_train,kmax=11,distance=2,kernel=c("rectangular","triangular","gaussian"),na.action=na.omit())
plot(fit$MISCLASS[,1]*100,type="l",main="��ͬ�˺����ͽ��ڸ���K�µĴ���������ͼ",cex.main=0.8,xlab="���ڸ���K",ylab="������(%)")
lines(fit$MISCLASS[,2]*100,lty=2,col=1)
lines(fit$MISCLASS[,3]*100,lty=3,col=2)
legend("topleft",legend=c("rectangular","triangular","gaussian"),lty=c(1,2,3),col=c(1,1,2),cex=0.7)   #����ͼ��

Tmall_test<-read.table(file="��è_Test_1.txt",header=TRUE,sep=",")
Tmall_test$BuyOrNot<-as.factor(Tmall_test$BuyOrNot)
fit<-kknn(formula=BuyOrNot~.,train=Tmall_train,test=Tmall_test,k=7,distance=2,kernel="gaussian",na.action=na.omit())
CT<-table(Tmall_test[,1],fit$fitted.values)
errRatio<-(1-sum(diag(CT))/sum(CT))*100

library("class")
fit<-knn(train=Tmall_train,test=Tmall_test,cl=Tmall_train$BuyOrNot,k=7)
CT<-table(Tmall_test[,1],fit)
errRatio<-c(errRatio,(1-sum(diag(CT))/sum(CT))*100)
errGraph<-barplot(errRatio,main="��ȨK���ڷ���K���ڷ��Ĵ����ʶԱ�ͼ(K=7)",cex.main=0.8,xlab="���෽��",ylab="������(%)",axes=FALSE)
axis(side=1,at=c(0,errGraph,3),labels=c("","��ȨK-���ڷ�","K-���ڷ�",""),tcl=0.25)
axis(side=2,tcl=0.25)

