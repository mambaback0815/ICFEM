mice=load_untouch_nii('mice.nii')
elec1=load_untouch_nii('elec2.nii')
pad1=load_untouch_nii('pad2.nii')
round1=load_untouch_nii('round2.nii')
allmask=mice.img;
allmask(pad1.img~=0)=max(mice.img,[],"all")+1;
allmask(elec1.img~=0)=max(mice.img,[],"all")+2;
allmask(round1.img~=0)=max(mice.img,[],"all")+3;
all=mice;
all.img=allmask;
save_untouch_nii(all,'allmask2.nii');

opt.radbound=5;
opt.angbound=6;
opt.distbound=0.3;
opt.reratio=3;
opt.maxvol=3;
elem = [0 0 0 0 0];
allmask=cast(allmask,'uint8');
    while(max(elem(:,end)) < 9)
        [node,elem,face] = meshByIso2mesh_mice(allmask,opt,'D:\GC\animal\rat\','mice');
        if(max(elem(:,end)) < 9)
            meshOpt.radbound = meshOpt.radbound/1.5;
            meshOpt.maxvol = meshOpt.maxvol/1.5;
        end
    end

load('mice_mesh.mat','node','elem','face');
P='D:\GC\animal\rat\mice.nii';
save_path='D:\GC\animal\rat\'
uniTag='mice'
elecNeeded={'elec','round'};
prepareForGetDP_mice(P,node,elem,elecNeeded,save_path,uniTag)