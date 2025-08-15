function lfm2TI(savepath,name,i1,i2,species,tissuemask,showbrain)
load([savepath  name '_mesh.mat'],'node');
A_all = readNPY([savepath  name '.npy']);  %读leadfield
A_all(:,:,1)=A_all(:,:,1)*i1;
A_all(:,:,2)=A_all(:,:,2)*i2;
tissuemask=load_untouch_nii(tissuemask);

pixdim=size(tissuemask.img);

disp('Computing the TI field (this may take a while) ...');

time = erase(char(datetime("now")), ' ');
time = erase(time, ':');
pair_num = 2;

isNaNinA = isnan(sum(sum(A_all,3),2)); % handle NaN properly
% if any(isNaNinA), A_all = A_all(~isNaNinA,:,:);end
% A_all(:,1,:) = orient(1) * A_all(:,1,:);A_all(:,2,:) = orient(2) * A_all(:,2,:);A_all(:,3,:) = orient(3) * A_all(:,3,:);
[xi,yi,zi] = ndgrid(1:pixdim(1),1:pixdim(2),1:pixdim(3));

r.xopt = cell(1,pair_num);
for i = 1:pair_num
    r.xopt{i} = zeros(sum(~isNaNinA),4);
    r.xopt{i}(:,1) = find(~isNaNinA);
    for j=1:size(A_all,2), r.xopt{i}(:,j+1) = squeeze(A_all(~isNaNinA,j,i)); end
end

    E1 = [r.xopt{1}(:,2) r.xopt{1}(:,3) r.xopt{1}(:,4)]; E2 = [r.xopt{2}(:,2) r.xopt{2}(:,3) r.xopt{2}(:,4)];
    [index,index1,index2] = intersect(double(r.xopt{1}(:,1)),double(r.xopt{2}(:,1)));
    ef_mag0 = zeros(size(index,1),1);
    for i = 1:size(index,1)
        if dot(E1(index1(i),:),E2(index2(i),:))<0
            E1(index1(i),:)=-E1(index1(i),:);
        end
        if norm(E1(index1(i),:),2) >= norm(E2(index2(i),:),2)
            alpha = acos(abs(dot(E1(index1(i),:),E2(index2(i),:))/(norm(E1(index1(i),:),2)*norm(E2(index2(i),:),2))));
            if alpha < (1/180)*pi
                alpha = 0;
            end
            if norm(E2(index2(i),:),2) <= norm(E1(index1(i),:),2)*cos(alpha)
                ef_mag0(i,1) = 2*norm(E2(index2(i),:),2);
            else
                ef_mag0(i,1) = 2*norm(cross(E2(index2(i),:),E1(index1(i),:)-E2(index2(i),:)),2)/norm(E1(index1(i),:)-E2(index2(i),:),2);
            end
        else
            alpha = acos(abs(dot(E2(index2(i),:),E1(index1(i),:))/(norm(E2(index2(i),:),2)*norm(E1(index1(i),:),2))));
            if alpha < (1/180)*pi
                alpha = 0;
            end
            if norm(E1(index1(i),:),2) <= norm(E2(index2(i),:),2)*cos(alpha)
                ef_mag0(i,1) = 2*norm(E1(index1(i),:),2);
            else
                ef_mag0(i,1) = 2*norm(cross(E1(index1(i),:),E2(index2(i),:)-E1(index1(i),:)),2)/norm(E2(index2(i),:)-E1(index1(i),:),2);
            end
        end

    end
    
 
 
    F2 = scatteredInterpolant(node(index,1),node(index,2),node(index,3), ef_mag0,'linear','none');

  
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
save_untouch_nii(ef_mag_nii,[savepath species '_' num2str(i1)   'mA_ef_TI.nii']);
   






