function best_x=focus_tacs(lfm, lfm_target)

module_lfm= sqrt(sum(lfm.^2, 2));
module_lfm = squeeze(module_lfm); 

module_target= sqrt(sum(lfm_target.^2, 2));
module_target = squeeze(module_target); 
% module_target = mean(module_target,1);
n=size(lfm,3);

best_score = -inf;
best_val = inf;
best_x = [];

proj_threshold = 0.2;  % 设置靶点强度的最低值，可根据实际情况调整
lambda = 100;  % 惩罚系数（可调节）


for i = 1:n
    for j = 1:n
        if i == j
            continue;
        end

        x = zeros(n, 1);
        x(i) = 1;
        x(j) = -1;

        proj_val = abs(mean(module_target * x));         % 靶点投影值（强度）
        energy_val = abs(mean(module_lfm * x));      % 总体能量

        % 添加强度下限判断，同时防止除以零
        if proj_val >= proj_threshold && energy_val > 1e-10
%             score = proj_val / energy_val;
            score = proj_val - lambda * energy_val;
            if score > best_score
                best_score = score;
                best_val = energy_val;
                best_x = x;
            end
        end
        
    end
end



% 输出结果


disp('最优目标值:');
disp(best_val);







end
