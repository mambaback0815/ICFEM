function indices = cylinder_indices(img_size, p, r, h, d)
    % img_size: 三维矩阵的尺寸，如 [nx, ny, nz]
    % p: 圆柱底面圆心坐标 [px, py, pz]
    % r: 圆柱半径
    % h: 圆柱高度
    % d: 圆柱方向向量 (1x3)，要归一化
    
    % 将方向向量 d 归一化
    d = -d / norm(d);
    
    % 预分配用于存储圆柱体内体素的索引
    indices = [];
    
    % 遍历整个三维矩阵的每个体素
    for x = 1:img_size(1)
        for y = 1:img_size(2)
            for z = 1:img_size(3)
                q = [x, y, z];  % 当前体素坐标
                
                % 计算 q 点到圆柱轴线的投影距离 t
                t = dot(q - p, d);
                
                % 如果 t 不在 [0, h] 范围内，则跳过该体素
                if t < 0 || t > h
                    continue;
                end
                
                % 计算 q 点到轴线的投影点 q_proj
                q_proj = p + t * d;
                
                % 计算 q 到轴线的垂直距离
                dist_to_axis = norm(q - q_proj);
                
                % 如果距离小于等于圆柱半径 r，则该体素在圆柱体内
                if dist_to_axis <= r
                    indices = [indices; x, y, z];  % 将符合条件的体素索引加入
                end
            end
        end
    end
end
