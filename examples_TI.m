tissuemaskpath='D:\article-2\ICEFEM-matlab\';

position1_1=[215,168,135];
depth1_1= 2;  %mm
direction1_1 = [0,0,-1];  
electype1_1='nail';  %  'needle'  'disc'  'nail'

position1_2=[215,122,135];
depth1_2= 2; %mm
direction1_2 = [0,0,-1];
electype1_2='nail'; %

position2_1=[162,163,135];
depth2_1= 2;  %mm
direction2_1 = [0,0,-1];  
electype2_1='nail';  %  'needle'  'disc'  'nail'

position2_2=[165,111,135];
depth2_2= 2; %mm
direction2_2 = [0,0,-1];
electype2_2='nail'; %



savepath='D:\article-2\result\mice_forward_TI\';
tag='r_f_A';
i1=2;
i2=2;

checkmodel=0;
species='mice';    %'mice'  'rat'  'monkey'
showbrain=1;  

forward_TI(tissuemaskpath , savepath, tag, checkmodel, species, showbrain, position1_1, depth1_1 , direction1_1 , electype1_1, position1_2 , depth1_2 , direction1_2 , electype1_2, position2_1, depth2_1 , direction2_1 , electype2_1, position2_2 , depth2_2 , direction2_2 , electype2_2,i1,i2)