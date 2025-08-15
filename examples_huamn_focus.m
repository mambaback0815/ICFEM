
tissuemaskpath=pwd;


savepath='D:\article-2\result\human_reverse_tACS\';
tag='human';


checkmodel=0;
species='human';    %'mice'  'rat'  'monkey'
showbrain=1;  

coordspath=strcat(pwd, '\coords_human.txt');
% postag='D:\article-2\result\mice_reverse_tACS\r_f_A_e2.pos';
% writenii(postag, species, tissuemaskpath, savepath, tag)
targetcoord = [77,160,121];
% method = 'intensity'; % 'focus'
method = 'focus';

reverse_tACS( tissuemaskpath , savepath, tag,  species, showbrain, coordspath,targetcoord, method)



