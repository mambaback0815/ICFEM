img=load_untouch_nii('D:\article-2\ICEFEM-matlab\reverse\rat.nii');
img=img.img;
brain= (img==5 | img==6);
skeleton = (img==3);


% 假设 brain 和 skeleton 是 380×372×208 的逻辑矩阵

% 1. 获取 skeleton 中所有 1 的坐标 [x, y, z]
[x, y, z] = ind2sub(size(skeleton), find(skeleton == 1));
coordinates = [x, y, z];

% 2. 找出所有唯一的 (x, y) 组合
[xy_unique, ~, ic] = unique(coordinates(:, 1:2), 'rows');

% 3. 对每个 (x, y) 组合：
%    - 找到 z 最大的点
%    - 检查该 (x, y) 的 z 轴上是否有 brain==1 的点
valid_mask = false(size(xy_unique, 1), 1); % 记录哪些 (x,y) 满足条件
%%%%%均匀采样%%%%%%均匀采样%%%%%%均匀采样%%%%%%均匀采样
% 按照间距 d=2 采样

filtered_coordinates = [];
for i = 1:size(xy_unique, 1)
    % 当前 (x, y) 的所有 z 值
    current_xy = xy_unique(i, :);
    z_values = z(ic == i);
    
    % 找到 z 最大的点
    [max_z, max_idx] = max(z_values);
    candidate_point = [current_xy, max_z];
    
    % 检查该 (x, y) 的 z 轴上是否有 brain==1 的点
    z_axis = squeeze(brain(current_xy(1), current_xy(2), :));
    if any(z_axis)
        valid_mask(i) = true;
        filtered_coordinates = [filtered_coordinates; candidate_point];
    end
end

% 4. 输出结果
disp("最终筛选后的坐标 (x, y, z)：");
disp(filtered_coordinates);




d = 14;
sampled_points = uniform_sample_points(filtered_coordinates, d);

x_min = 169;
x_max = 249;
valid_x_mask = (sampled_points(:, 1) >= x_min) & (sampled_points(:, 1) <= x_max);
filtered_coordinates_x_range = sampled_points(valid_x_mask, :);

y_min = 116;
y_max = 350;
valid_y_mask = (filtered_coordinates_x_range(:, 2) >= y_min) & (filtered_coordinates_x_range(:, 2) <= y_max);
filtered_coordinates_y_range = filtered_coordinates_x_range(valid_y_mask, :);

% 绘制原始点和采样点
figure;
scatter(xy_unique(:,1), xy_unique(:,2), 'b', 'filled'); hold on;
scatter(filtered_coordinates_y_range(:,1), filtered_coordinates_y_range(:,2), 'r', 'filled', 'MarkerEdgeColor', 'k');
legend('原始点', '采样点');
title(sprintf('均匀采样 (d=%.1f)', d));
grid on;
disp('1');




%%%%%%最远点采样 %%%%%%最远点采样%%%%%%最远点采样%%%%%%最远点采样

% 

% 





% % 使用逻辑索引
% valid_x_mask = (filtered_coordinates(:, 1) >= x_min) & (filtered_coordinates(:, 1) <= x_max);
% filtered_coordinates_x_range = filtered_coordinates(valid_x_mask, :);
% 
% % 显示结果
% disp("筛选后的坐标 (x, y, z)：");
% disp(filtered_coordinates_x_range);
% 
% % 统计数量
% num_points = size(filtered_coordinates_x_range, 1);
% fprintf('符合条件的点数量：%d\n', num_points);
% 
% valid_x_mask = (filtered_coordinates_x_range(:, 2) >= 75) & (filtered_coordinates_x_range(:, 2) <= 210);
% filtered_coordinates_y_range = filtered_coordinates_x_range(valid_x_mask, :);
% 
% % 输入数据
% data = filtered_coordinates_y_range;  % n×3 矩阵 [x, y, z]
% min_distance = 10;  % 使用平均距离作为阈值
% 
% % --- 步骤1：优先从稀疏区域开始采样 ---
% % 计算所有点到数据集中心的距离，选择最远的点作为初始点
% center = mean(data(:, 1:2));  % 数据集的 (x,y) 中心
% dist_to_center = sqrt(sum((data(:, 1:2) - center).^2, 2));
% [~, idx] = max(dist_to_center);  % 找到距离中心最远的点
% 
% sampled_points = data(idx, :);      % 初始化采样点集
% remaining_points = data([1:idx-1, idx+1:end], :);  % 剩余点
% 
% % --- 步骤2：迭代筛选满足距离条件的点 ---
% while ~isempty(remaining_points)
%     % 计算剩余点与已选点集的 (x,y) 距离
%     distances = pdist2(remaining_points(:, 1:2), sampled_points(:, 1:2), 'euclidean');
%     
%     % 找出与所有已选点距离 > min_distance 的点
%     valid_mask = all(distances > min_distance, 2);
%     
%     % 如果没有满足条件的点，终止循环
%     if ~any(valid_mask)
%         break;
%     end
%     
%     % 从满足条件的点中，选择距离已选点集最远的点（加速稀疏化）
%     valid_points = remaining_points(valid_mask, :);
%     [~, farthest_idx] = max(min(pdist2(valid_points(:, 1:2), sampled_points(:, 1:2)), [], 2));
%     sampled_points = [sampled_points; valid_points(farthest_idx, :)];
%     
%     % 更新剩余点集
%     remaining_points = remaining_points(valid_mask, :);
% end
% 
% % --- 结果显示 ---
% fprintf('总点数：%d → 采样后点数：%d\n', size(data, 1), size(sampled_points, 1));
% disp('采样点示例：');
% disp(sampled_points(1:min(5, end), :));  % 显示前5个点
% 

