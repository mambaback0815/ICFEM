
function forward_TI(tissuemaskpath , savepath, name, doall, species, showbrain, position1_1, depth1_1 , direction1_1 , electype1_1, position1_2 , depth1_2 , direction1_2 , electype1_2, position2_1, depth2_1 , direction2_1 , electype2_1, position2_2 , depth2_2 , direction2_2 , electype2_2,i1,i2)
%首先放电极，目前限制为颅钉电极加底座；以及圆盘电极
doall = ~doall;  %checkmodel 
switch species
    case 'mice'
        tissuemask=strcat(tissuemaskpath,'mice.nii');
    case 'rat'
        tissuemask=strcat(tissuemaskpath,'rat.nii');
    case 'monkey'
        tissuemask=strcat(tissuemaskpath,'monkey.nii');
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
elec_mask1(tissuemask , position1_1, depth1_1 , direction1_1 , electype1_1, position1_2 , depth1_2 , direction1_2, electype1_2, savepath, name)% 7,8,9,10 7 9为电极  10 11为垫子
elec_mask2(tissuemask , position2_1, depth2_1 , direction2_1 , electype2_1, position2_2 , depth2_2 , direction2_2, electype2_2, savepath, name)%1为第一个颅钉 2为第一个圆盘 3为第三个颅钉 4为第四个圆盘
%生成了四个电极，两个垫片的nii文件，读取并合并为一个nii
end
meshoptions.radbound=10;
meshoptions.angbound=3;
meshoptions.distbound=0.4;
meshoptions.reratio=1.5;
meshoptions.maxvol=3;

% meshoptions.radbound=10;
% meshoptions.angbound=20;
% meshoptions.distbound=0.5;
% meshoptions.reratio=2;
% meshoptions.maxvol=15;
elecnum=4;
mask_all(tissuemask, name, savepath, meshoptions,doall,elecnum)



if(doall~=1)
    return 
end

if(~exist([savepath name '_ready.msh']))
prepareForGetDP_all(savepath,name,elecnum);
end



sigma.white = 0.347954 ;
% sigma.white = 0.419055 ;
sigma.gray = 0.419055 ;
sigma.csf = 1.879 ;
sigma.skeleton = 0.017856 ;
sigma.skin = 0.148297 ;
sigma.muscle = 0.461003 ;
sigma.pad = 1e-10 ;
sigma.electrode = 5.9e7 ;


% sigma.white = 0.064 ;
% sigma.gray = 0.103 ;
% sigma.csf = 2 ;
% sigma.skeleton = 0.0202 ;
% sigma.skin = 2e-4 ;
% sigma.muscle = 1 ;
% sigma.pad = 1e-10 ;
% sigma.electrode = 5.9e7 ;
%进行计算
if(~exist([savepath name '.npy']))
solveByGetDP_leadfield_all1([1;-1],sigma,savepath,name,name,elecnum,species);
solveByGetDP_leadfield_all2([1;-1],sigma,savepath,name,name,elecnum,species);

postGetDP_leadField_all(savepath,name,elecnum)
end


lfm2TI(savepath,name,i1,i2,species,tissuemask,showbrain)
% TI_mice1(savepath,name)
% TI_mice2(savepath,name)
end




