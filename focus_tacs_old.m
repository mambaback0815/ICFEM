function best_x=focus_tacs(lfm, lfm_target)
threshold = 0.2;
module_lfm= sqrt(sum(lfm.^2, 2));
module_lfm = squeeze(module_lfm); 

module_target= sqrt(sum(lfm_target.^2, 2));
module_target = squeeze(module_target); 
module_target = mean(module_target,1);
n=size(lfm,3);

found = false;

while ~found && threshold > 0.1  % 设置一个较小的下限以防死循环
    best_val = inf;
    best_x = [];

    for i = 1:n
        for j = 1:n
            if i == j
                continue;
            end

            x = zeros(n, 1);
            x(i) = 1;
            x(j) = -1;

            % 检查是否满足阈值约束
            if abs(module_target * x) >= threshold
                val = norm(module_lfm * x, 2);
                if val < best_val
                    best_val = val;
                    best_x = x;
                    found = true;
                end
            end
        end
    end

    % 如果没找到合适的x，则降低threshold
    if ~found
        threshold = threshold * 0.8;
    end
end

% 输出结果
if found
    disp(['找到满足条件的x，threshold = ', num2str(threshold)]);
    disp('最优目标值:');
    disp(best_val);
%     disp('最优x:');
%     disp(best_x);
else
    disp('未找到满足条件的x，即使降低threshold至最小值。');
end






end
