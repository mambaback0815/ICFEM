function sampled_points = uniform_sample_points(xy_unique, d, tol)
    % xy_unique: n×2 的矩阵，每一行是 [x, y] 坐标
    % d: 采样间距
    % tol: 匹配容差（可选，默认 d/2）
    
    if nargin < 3
        tol = d / 2; % 默认容差为间距的一半
    end

    % 1. 获取 x 和 y 的范围
    x_min = min(xy_unique(:, 1));
    x_max = max(xy_unique(:, 1));
    y_min = min(xy_unique(:, 2));
    y_max = max(xy_unique(:, 2));

    % 2. 生成采样网格点
    x_samples = x_min:d:x_max;
    y_samples = y_min:d:y_max;
    [X_grid, Y_grid] = meshgrid(x_samples, y_samples);
    grid_points = [X_grid(:), Y_grid(:)]; % 所有网格点

    % 3. 找到 xy_unique 中离网格点足够近的点
    sampled_points = [];
    for i = 1:size(grid_points, 1)
        % 计算当前网格点与所有点的距离
        distances = sqrt( (xy_unique(:,1) - grid_points(i,1)).^2 + ...
                     (xy_unique(:,2) - grid_points(i,2)).^2 );
        
        % 找到距离 < tol 的点
        close_points = xy_unique(distances < tol, :);
        
        % 如果存在，取最近的一个点（或平均点）
        if ~isempty(close_points)
            % 方式1：取最近的一个点
            [~, idx] = min(distances);
            sampled_points = [sampled_points; xy_unique(idx, :)];
            
            % 方式2：取所有邻近点的均值（可选）
            % mean_point = mean(close_points, 1);
            % sampled_points = [sampled_points; mean_point];
        end
    end

    % 去重（避免重复采样）
    sampled_points = unique(sampled_points, 'rows');
end