function numofelec=generate_mask(tissuemask , coordspath, savepath, name)
tissue  = load_untouch_nii(tissuemask);


datas = load(coordspath);
%颅钉电极直径1.2 盘状电极直径5  针电极直径0.2
%放第一对电极的第一个电极
coords=datas(:,1:3);
directions=datas(:,4:6);
electypes=datas(:,7);


numofelec=size(datas,1);
depth=10;
allmask=tissue.img;
for i=1:numofelec
    [maskelec1, maskelec2] = elec_mask(tissuemask , coords(i,:), depth, directions(i,:), electypes(i));
    allmask(maskelec1~=0) = 5+2*i;
    allmask(maskelec2~=0) = 6+2*i;
end
  
allmask(tissue.img==0)=0;

temp=tissue;
temp.img=allmask;
save_untouch_nii(temp,[savepath name 'allmask.nii']);