
tissuemaskpath=pwd;


savepath='F:\article-2\result\mice_reverse_tACS\';
tag='mice';


checkmodel=0;
species='mice';    %'mice'  'rat'  'monkey'
showbrain=1;  

coordspath=strcat(pwd, '\coords_mice.txt');
% postag='D:\article-2\result\mice_reverse_tACS\r_f_A_e2.pos';
% writenii(postag, species, tissuemaskpath, savepath, tag)
targetcoord = [203, 139, 130];
% method = 'intensity'; % 'focus'
method = 'intensity';

reverse_tACS( tissuemaskpath , savepath, tag,  species, showbrain, coordspath,targetcoord, method)



