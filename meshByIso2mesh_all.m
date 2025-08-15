function [node,elem,face] = meshByIso2mesh_all(data,opt,savepath,name,elecnum)


allMask=data;
[node,elem,face] = cgalv2m(allMask,opt,opt.maxvol);
node(:,1:3) = node(:,1:3) + 0.5; % then voxel space

%for i=1:3, node(:,i) = node(:,i)*pixdim(i); end


disp('saving mesh...')
% maskName = {'WHITE','GRAY','CSF','BONE','SKIN','AIR','GEL','ELEC'};
maskName = cell(1,6+2*elecnum);
% maskName(1:numOfTissue) =
% {'SKIN','MUSCLE','SKELETON','CSF','GRAY','WHITE'};  %rat
maskName(1:6) ={'SKIN','SKELETON','GRAY','WHITE','CSF','MUSCLE'};
for n=1:elecnum, maskName{6+(n*2-1)} = ['ELEC' num2str(n)]; end
for n=1:elecnum, maskName{6+(n*2)} = ['PAD' num2str(n)]; end
savemsh(node(:,1:3),elem,[savepath  name '.msh'],maskName);
save([savepath  name '_mesh.mat'],'node','elem','face');