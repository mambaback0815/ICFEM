function reverse_tACS(tissuemaskpath , savepath, name, species, showbrain, coordspath,targetcoord, method)
%首先放电极，目前限制为颅钉电极加底座；以及圆盘电极

switch species
    case 'mice'
        tissuemask=strcat(tissuemaskpath,'\mice.nii');
    case 'rat'
        tissuemask=strcat(tissuemaskpath,'\rat.nii');
    case 'monkey'
        tissuemask=strcat(tissuemaskpath,'\monkey.nii');
    case 'human'
        tissuemask=strcat(tissuemaskpath,'\human.nii');
    otherwise 
        error('No match species')
end

if ~exist(savepath, 'dir')
    % 创建文件夹（包括所有父级目录）
    mkdir(savepath);
end
sourcePath = tissuemask;  %原来路径
targetPath = savepath;  %目标路径
copyfile(sourcePath, targetPath)%复制文件，原来路径还有文件



if(~exist([savepath name 'allmask.nii']))

numofelec=generate_mask(tissuemask , coordspath, savepath, name);% 7,8,9,10 7 9为电极  10 11为垫子
disp(['共有' num2str(numofelec) '个电极'] )

end
% meshoptions.radbound=10;
% meshoptions.angbound=20;
% meshoptions.distbound=0.5;
% meshoptions.reratio=2;
% meshoptions.maxvol=15;

meshoptions.radbound=8;
meshoptions.angbound=8;
meshoptions.distbound=0.3;
meshoptions.reratio=1.5;
meshoptions.maxvol=8;

datas=load(coordspath);
numofelec=size(datas,1);

if(~exist([savepath name '.msh']))
mask_all(name, savepath, meshoptions,numofelec);
end



sigma.white = 0.347954 ;
% sigma.white = 0.419055 ;
sigma.gray = 0.419055 ;
sigma.csf = 1.879 ;
sigma.skeleton = 0.017856 ;
sigma.skin = 0.148297 ;
sigma.muscle = 0.461003 ;
sigma.air=2.5e-14 ;
sigma.pad = 1e-10 ;
sigma.electrode = 5.9e7 ;







if(~exist([savepath name '.npy']))
    for i=1 : numofelec-1
     pos_tag=[savepath name '_e' num2str(i) '.pos'];
     if ~exist(pos_tag)
        [meshtag,readytag]=prepareForGetDP_all(savepath,name,i,tissuemask, species);
        solveByGetDP_leadfield_all(sigma,savepath,name,species,i);
        delete(meshtag);
        delete(readytag);
     end
     end

    generate_lfm(savepath,name,numofelec-1)
end


datas = load(coordspath);
%颅钉电极直径1.2 盘状电极直径5  针电极直径0.2
%放第一对电极的第一个电极
coords=datas(2:end,1:3);
x=optimization_tACS(savepath, name, tissuemask, species, showbrain,targetcoord, method);
x1= find(x~=0);
x(x1)
coords_final = coords(x1,:)

writenii(x, species, tissuemask, savepath, name,method,targetcoord,x1)
% evaluation(tissuemask,savepath,name,method,targetcoord)

end




