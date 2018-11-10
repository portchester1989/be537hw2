label_table = readtable('../images/labels.csv','Format','%u%s%s');
L = table2array(label_table(:,1));
[image_fixed,spacing] = myReadNifti('../images/atlas_2mm_1006_3.nii');
[image_moving,~] = myReadNifti('../images/atlas_2mm_1008_3.nii');
[segmentation_fixed,~] = myReadNifti('../images/atlasseg_2mm_1006_3.nii');
[segmentation_moving,~] = myReadNifti('../images/atlasseg_2mm_1008_3.nii');
params = myFullRegInit(image_fixed,image_moving);
params.flags.plot_iter = 1;
params.flags.print_iter = 0;
p = myFullReg(image_fixed,image_moving,params);
aff_img = myFullTransformImage(p,image_moving,1);
full_img = myFullTransformImage(p,image_moving,0);
aff_seg = myFullTransformImage(p,segmentation_moving,1);
full_seg = myFullTransformImage(p,segmentation_moving,0);
myView(aff_seg,spacing,[],[],'jet')
myView(full_seg,spacing,[],[],'jet')
[gdsc_naive,~] = myDiceOverlap(segmentation_moving,segmentation_fixed,L);
[gdsc_aff,~] = myDiceOverlap(aff_seg,segmentation_fixed,L);
[gdsc_full,~] = myDiceOverlap(full_seg,segmentation_fixed,L);