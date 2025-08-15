
tissuemaskpath=pwd;


savepath='F:\article-2\result\rat_reverse_tACS\';
tag='rat';


checkmodel=0;
species='rat';    %'mice'  'rat'  'monkey'
showbrain=1;  

coordspath=strcat(pwd, '\coords_rat.txt');
% postag='D:\article-2\result\mice_reverse_tACS\r_f_A_e2.pos';
% writenii(postag, species, tissuemaskpath, savepath, tag)
targetcoord = [229,218,290];
% method = 'intensity'; % 'focus'
method = 'intensity';

reverse_tACS( tissuemaskpath , savepath, tag,  species, showbrain, coordspath,targetcoord, method)



