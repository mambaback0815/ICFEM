function x=optimization_tACS(savepath, name, tissuemask, species, showbrain,targetcoord, method)

tissue=load_untouch_nii(tissuemask);

img= tissue.img;
load([savepath name '_mesh.mat'],'node');
node(:,4)=node(:,4)-0.5; 
int_node = round(node);  % 将坐标四舍五入为整数

switch species
    case 'mice'
        inbrain= (img==3 |img==4);
        matched_node_idx = (node(:,4)==3|node(:,4)==4);
    case 'rat'
        inbrain= (img==5 |img==6);
        matched_node_idx = (node(:,4)==5|node(:,4)==6);
    case 'monkey'
        inbrain= (img==3 |img==4);
        matched_node_idx = (node(:,4)==5|node(:,4)==6);
    case 'human'
        inbrain= (img==1 |img==2);
        matched_node_idx = (node(:,4)==1|node(:,4)==2);
    otherwise 
        error('No match species')
end





x=targetcoord(1);y=targetcoord(2);z=targetcoord(3);
is_out_of_range = x < 1 || x > size(inbrain,1) || ...
                  y < 1 || y > size(inbrain,2) || ...
                  z < 1 || z > size(inbrain,3);
if is_out_of_range
    disp('坐标不在大脑内');
elseif ~inbrain(x, y, z)
    disp('坐标不在大脑内');
else
    disp('正在逆向仿真');
end




lfm=readNPY([savepath name '.npy']);

r=5;
distances = sqrt(sum((node(:,1:3) - targetcoord).^2, 2));

% 找出距离 ≤ r 的索引
targetNodes = distances <= r;

lfm_target = lfm(targetNodes,:, :);

lfm_brain = lfm(matched_node_idx,:,:);

if strcmp(method, 'intensity')
    [x, ~]=intensity_tacs(lfm_brain, lfm_target);
end
if strcmp(method, 'focus')
    x=focus_tacs(lfm_brain, lfm_target);
end
if strcmp(method, 'balance')
    x=balance_tacs(lfm_brain, lfm_target);
end



end