function lfm2tACS(savepath,name,i1,species,tissuemask,showbrain)
load([savepath  name '_mesh.mat'],'node');
A_all = readNPY([savepath  name '.npy']); 

tissuemask=load_untouch_nii(tissuemask);
pixdim=size(tissuemask.img);

disp('Computing the TI field (this may take a while) ...');

[xi,yi,zi] = ndgrid(1:pixdim(1),1:pixdim(2),1:pixdim(3));


ef_mag=vecnorm(A_all,2,2)*i1;
F2 = scatteredInterpolant(node(:,1),node(:,2),node(:,3), ef_mag,'linear','none');
   
ef_mag = F2(xi,yi,zi);

if showbrain==1
    switch species
        case 'mice'
            brain = (tissuemask.img==3 | tissuemask.img==4); 
        case 'rat'
            brain = (tissuemask.img==5 | tissuemask.img==6);
        case 'monkey'
            brain = (tissuemask.img==1 | tissuemask.img==2);
        otherwise 
            error('No match species')
    end
else
    brain=(tissuemask.img~=0);
end



nan_mask_brain = nan(size(brain));
nan_mask_brain(brain) = 1;
ef_mag = ef_mag.*nan_mask_brain; 

ef_mag_nii =tissuemask;
ef_mag_nii.hdr.dime.datatype = 64;
ef_mag_nii.img = ef_mag*100;
save_untouch_nii(ef_mag_nii,[savepath species '_' num2str(i1)   'mA_ef_tACS.nii']);
   





