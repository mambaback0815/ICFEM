function mask_all(name, savepath, meshoptions,elecnum)


if(~exist([savepath name '_mesh.mat']))
opt=meshoptions;
elem = [0 0 0 0 0];
allmask=load_untouch_nii([savepath name 'allmask.nii']);
allmask=allmask.img;
allmask=cast(allmask,'uint8');
    while(max(elem(:,end)) < 6+2*elecnum)
        [~,elem,~] = meshByIso2mesh_all(allmask,opt,savepath,name,elecnum);
        if(max(elem(:,end)) < 6+2*elecnum)
            meshoptions.radbound = meshoptions.radbound/1.5;
            meshoptions.maxvol = meshoptions.maxvol/1.5;
        end
    end
end
