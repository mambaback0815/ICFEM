% meshoptions.radbound=10;
% meshoptions.angbound=20;
% meshoptions.distbound=0.5;
% meshoptions.reratio=2;
% meshoptions.maxvol=15;
% 
meshoptions.radbound=8;
meshoptions.angbound=10;
meshoptions.distbound=0.3;
meshoptions.reratio=1.5;
meshoptions.maxvol=8;
opt=meshoptions;
img=load_untouch_nii('D:\article-2\result\human_reverse_tACS\humanallmask.nii');
allmask=img.img;
allMask=cast(allmask,'uint8');
[node,elem,face] = cgalv2m(allMask,opt,opt.maxvol);
disp('1');