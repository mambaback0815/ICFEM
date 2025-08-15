function writenii(x, species, tissuemask, savepath, name, method, targetcoord,coords_final)
i1=1;

niiname = [savepath species '_' name '_' method '_' num2str(targetcoord(1)) '_' num2str(targetcoord(2)) '_' num2str(targetcoord(3))  '.nii'];

if ~exist(niiname)
    

    tissuemask=load_untouch_nii(tissuemask);


    % fid = fopen(postag);
    % fgetl(fid);
    % C = textscan(fid,'%d %f %f %f');
    % fclose(fid);


    % A_all= cell2mat(C(2:4));


    load([savepath  name '_mesh.mat'],'node');


    pixdim=size(tissuemask.img);



    [xi,yi,zi] = ndgrid(1:pixdim(1),1:pixdim(2),1:pixdim(3));

    used=find(x~=0);

    lfm = readNPY([savepath  name '.npy']);
    A_all = lfm(:,:,used(1))-lfm(:,:,used(2));
    ef_mag=vecnorm(A_all,2,2)*i1;
    F2 = scatteredInterpolant(node(:,1),node(:,2),node(:,3), ef_mag,'linear','none');

    ef_mag = F2(xi,yi,zi);
    showbrain=1;
    if showbrain==1
        switch species
            case 'mice'
                brain = (tissuemask.img==3 | tissuemask.img==4); 
            case 'rat'
                brain = (tissuemask.img==5 | tissuemask.img==6);
            case 'monkey'
                brain = (tissuemask.img==1 | tissuemask.img==2);
            case 'human'
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
    if strcmp(species,'human')
        ef_mag_nii.img = ef_mag;
    else
        ef_mag_nii.img = ef_mag*100;
    end
    save_untouch_nii(ef_mag_nii,niiname);

    allmaskpath=[savepath name 'allmask.nii'];
    allmask=load_untouch_nii(allmaskpath);
    tissuemask.img(allmask.img==2*coords_final(1)+7 | allmask.img==2*coords_final(1)+8) = 7;
    tissuemask.img(allmask.img==2*coords_final(2)+7 | allmask.img==2*coords_final(2)+8) = 8;
    save_untouch_nii(tissuemask,[savepath 'elec_' species '_' name '_' method '_' num2str(targetcoord(1)) '_' num2str(targetcoord(2)) '_' num2str(targetcoord(3))  '.nii'])


    
end