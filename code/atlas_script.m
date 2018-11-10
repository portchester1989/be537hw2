%read each file
file_list = dir('../images/altas_*.nii');
seg_list = dir('../images/altasseg*.nii');
label_table = readtable('../images/labels.csv','Format','%u%s%s');
L = table2array(label_table(:,1));
iter_num = 5;
mean_GDSC = zeros(1,iter_num);
mean_sq_int = zeros(1,iter_num);
%create template
for k = 1:iter_num
    for i = 1:size(file_list,1)
        [atlas_img,spacing] = myReadNifti(file_list(i).name);
        if exist('atlas_imgs','var') == 0
            atlas_imgs = zeros([size(atlas_img) size(file_list,1)]);
        end
        atlas_imgs(:,:,:,i) = altas_img;    
    end
    template = mean(atlas_imgs,4);
    segs = cell(size(file_list,1),1);
    for j = 1:size(file_list,1)
       J = atlas_imgs(:,:,:,j);
       [J_seg,~] = myReadNifti(seg_list(i));
       param = myFullRegInit(template,J,spacing);
       p = myFullReg(template,J,param);
       J_resliced = myFullTransformImage(p,J);
       segs{j} = myFullTransformImage(p,J_seg);
       atlas_imgs(:,:,:,j) = J_resliced;
    end
   segs_after_iteration = myMajorityVote(segs);
   GDSC = zeros(size(file_list,1),1);
   for l = 1:size(file_list,1)
       [GDSC(l),~] = myDiceOverlap(seg{l},segs_after_iteration,L);
   end
   mean_GDSC(k) = mean(GDSC);
   int_difference = (template - atlas_imgs) .^ 2;
   mean_sq_int(k) = sum(int_difference) / size(file_list,1);
   myView(template,spacing);
   myView(segs_after_iteration,spacing);
   
end