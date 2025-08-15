function template2=elecmask(tissue,position,r,h,direction,number)
img=tissue.img;

d = position;  % 地面圆心坐标
normal = direction;  % 法向量
r = r;  % 半径
h = h; % 高度

% 计算法向量的单位向量
normal = normal / norm(normal);

% 生成网格
[xGrid, yGrid, zGrid] = ndgrid(1:size(img,1), 1:size(img,2), 1:size(img,3));

% 计算点到圆心的距离（在法向量平面上）
distToCenter = sqrt((xGrid - d(1)).^2 + (yGrid - d(2)).^2 + (zGrid - d(3)).^2 - ...
    ((xGrid - d(1)) * normal(1) + (yGrid - d(2)) * normal(2) + (zGrid - d(3)) * normal(3)).^2);

% 计算点到圆柱体的底面圆心的投影到法向量上的距离
distanceAlongNormal = (xGrid - d(1)) * normal(1) + ...
                      (yGrid - d(2)) * normal(2) + ...
                      (zGrid - d(3)) * normal(3);

% 创建圆柱体掩模
mask = (distToCenter <= r) & (abs(distanceAlongNormal) <= h / 2);

% 获取圆柱体内点的索引
template2=zeros(size(img),'int8');
template2(mask==1)=number;
% temp2=tissue;
% temp2.img=template2;
% save_untouch_nii(temp2,[savepath name 'round2.nii'])