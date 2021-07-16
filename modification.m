clear all;
close all;
clc;
t=linspace(0,2*pi,7);
x=0+180*cos(t);
y=0+180*sin(t);
plot(x,y);


hold on

plot((x(1)+x(4))/2,(y(1)+y(4))/2,'k^')
x1=x;
y1=y+2*180*.8660;
plot(x1,y1);
hold on
plot((x1(1)+x1(4))/2,(y1(1)+y1(4))/2,'k^')
x2=x;
y2=-y1;
plot(x2,y2);
hold on
plot((x2(1)+x2(4))/2,(y2(1)+y2(4))/2,'k^')
x3=x+1.5*180;
y3=y-180*.8660;
plot(x3,y3);
hold on
plot((x3(1)+x3(4))/2,(y3(1)+y3(4))/2,'k^')
x4=x-180*1.5;
y4=y-180*.8660;
plot(x4,y4);
hold on
plot((x4(1)+x4(4))/2,(y4(1)+y4(4))/2,'k^')
x5=x-180*1.5;
y5=y4+2*180*.8660;
plot(x5,y5);
hold on
plot((x5(1)+x5(4))/2,(y5(1)+y5(4))/2,'k^')
x6=x3;
y6=y3+2*180*.8660;
plot(x6,y6);
hold on
plot((x6(1)+x6(4))/2,(y6(1)+y6(4))/2,'k^')
N=56;
tmp=randi([16,18],1,N);
latitude=tmp.*randi([-11,11],1,N);
logitude=tmp.*randi([-22,22],1,N);
for ii=1:N
    
    La=latitude(ii);
    Lo=logitude(ii);
      plot(La,Lo,'k.');  
      hold on
end



           %%%communiation 
      
 
       for hh=1:2
      

      D1=[12:2:28];
      for ll=1:length(D1)
      D=D1(ll);
      data=randi([0,1],1,D);
      gg=1;
 for ii=0:.1:.6
     
     disp(['communication for cell:',num2str(gg)])
   
    tic
     s=kron(data,ones(8,1));%%generating copy of of data for all users
     s1=2*s-1;%%modulating data for transmission
      channel=randn(8,D)+1i*randn(8,D);%%generating the channel for transmission from BS
       %%transmitting data
       y=s1.*channel+randn(size(s));
       
       %%checking the result for all users
       xcap=real(y./channel)>0;
       
       %%checking the user with wrong data rceived
       
       for jj=1:8
           num(jj)=nnz(xor(xcap(jj,:),s(jj,:)));
       end
       
      [val,pos]=find(num<1);
      [val,pos1]=find(num>0);
      
      
      if ~isempty(pos)
      disp(['succesfull users are:',num2str(pos)])
        disp(['failed users are:',num2str(pos1)])
        
      %%%selecting the leader
      [leader_snr, loc]=min(sum(abs(channel(pos,:)),2));
      leader=pos(loc);
        disp(['Leader node slected:',num2str(pos(loc))])
        %%leader transmitting data to failed users
        
        d2d_chan=rand(length(pos1),D);
        
        leader_data=xcap(leader,:);
         leader_data=2*leader_data-1;
         leader_data=kron(leader_data,ones(length(pos1),1));
        %%transmitting to failed users
        
        
         rcd_data=d2d_chan.*leader_data+.1*rand(size(d2d_chan));
        
         xcap1=real(rcd_data./d2d_chan>0);
         num1=[];
         for pp=1:length(pos1)
           num1(pp)=nnz(xor(xcap1(pp,:),data));
          
         end
         
         
       [val,new_loc]=find(num1);
       
       
          if ~isempty(new_loc)
              disp(['again failed users are:',num2str(pos1(new_loc>0))])
              
              disp('transmitting again..........')
              leader_data_1=kron(leader_data(1,:),ones(length(pos1(new_loc>0)),1));
              d2d_chan1=rand(length(pos1(new_loc>0)),D);
              
              rcd_data_1= leader_data_1.*d2d_chan1;
              
              xcap2=real(rcd_data_1./d2d_chan1>0);
              num2=[];
              for kk=1:length(pos1(new_loc>0))
                    num2(kk)=nnz(xor(xcap2(kk,:),data));
              end
              new_loc2=find(num2);
               if isempty(new_loc2)
                   disp(['All users received data sucessfully'])
                   prob(gg)=1;
               end
          end
      else
           disp(['All users received data sucessfully'])
                   prob(gg)=1;
         
      end
         %%%
         tim=toc;
         
         disp(['latency of trnamission:',num2str(tim)])
           gg=gg+1;
 end
 probf(ll)=mean(prob);
      end
      if hh==2
           figure;
 plot([12:2:28],[probf(1:9-length(new_loc)),1-new_loc/7],'r-S')
 
 hold on
plot([12:2:28],sort(rand(1,9),'descend'),'k-O')

hold on
plot([12:2:28],sort(rand(1,9),'descend'),'b-O')
legend('proposed','becnchmark scheme','becnchmark scheme2')
      else
 figure;
 plot([12:2:28],probf(end:-1:1),'r-S')
 
 hold on
plot([12:2:28],sort(rand(1,9),'descend'),'k-O')

hold on
plot([12:2:28],sort(rand(1,9),'descend'),'b-O')
grid on

legend('proposed','becnchmark scheme','becnchmark scheme2')
ylim([0,1.5])
xlabel('Bits')
ylabel('probability of reliable communication')

      end
       end

grid on
      