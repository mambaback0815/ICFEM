function generate_lfm(savepath,name,elecnum)
% 在postGetDP_YI的基础上将原有的自动生成leadField路径更改为了自定义路径

load([savepath name '_mesh.mat'],'node');

A_all = nan(size(node,1),3,elecnum);
for i = 1: elecnum
    disp(['packing electrode ' num2str(i) ' out of ' num2str(elecnum) ' ...']);
    fid = fopen([savepath name '_e' num2str(i) '.pos']);
    fgetl(fid);
    C = textscan(fid,'%d %f %f %f');
    fclose(fid);
    A_all(C{1},:,i) = cell2mat(C(2:4));
end



    %delete([leadField_path_dirname baseFilename '_' uniTag '_e' num2str(indSolved(i)) '.pos']);    
disp('保存结果...')

writeNPY(A_all,[savepath  name '.npy']);

disp('======================================================');
disp('leadfield矩阵已保存至');

disp([savepath  name '.npy']);
disp('======================================================');

% disp(['Voltage: ' dirname filesep baseFilename '_' uniTag '_v.pos']);
% disp(['E-field: ' dirname filesep baseFilename '_' uniTag '_e.pos']);

    
