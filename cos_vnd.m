% cos_vnd
nii2=load_untouch_nii('F:\article-2\result\rat_3621_TI\rat_1mA_ef_TI_medium.nii');
nii1=load_untouch_nii('F:\article-2\result\rat_3621_TI\rat_1mA_ef_TI_fine.nii');
% nii1=load_untouch_nii('D:\article-2\result\human_reverse_tACS\33_1.0_1.0_74_117_138_2_TI_brain.nii');
% nii2=load_untouch_nii('D:\article-2\result\human_33_TI\human_1mA_ef_TI.nii');
img1=double(nii1.img);
img2=double(nii2.img);
mask = ~isnan(img1) & ~isnan(img2);

v1 = img1(mask);
v2 = img2(mask);

n1 = norm(v1);
n2 = norm(v2);

if n1 == 0 || n2 == 0
    cos_sim = NaN;
    vnd = NaN;
    vnd_norm = NaN;
    warning('向量范数为0，无法计算相似度或归一化范数差。');
else
    cos_sim = dot(v1, v2) / (n1 * n2);
    vnd = norm(v1 - v2);
    vnd_norm = vnd / (n1 + n2);
end

fprintf('Cosine Similarity: %.4f\n', cos_sim);
fprintf('Vector Norm Difference (VND): %.4f\n', vnd);
fprintf('Normalized VND (0–1): %.4f\n', vnd_norm);

