ICFEM Toolbox: reverse_tACS Function Documentation
Inverse Optimization for Implanted Electrode Configurations

📜 Function Description
reverse_tACS performs inverse optimization to determine the optimal electrode configuration for targeted transcranial alternating current stimulation in implanted electrode setups. It supports multi-species anatomical models (mouse/rat/monkey) and outputs optimized electric field distributions.

🛠️ Installation & Dependencies
Requirements
MATLAB ≥ R2019b

ISO2Mesh (for tetrahedral mesh generation)

3D Anatomical Models (MNI152 for human, species-specific atlases for rodents)


matlab
reverse_tACS(tissuemaskpath, savepath, tag, species, showbrain, coordspath, targetcoord, method)
🔍 Input Parameters
Parameter	Type	Description	Example Value
tissuemaskpath	string	Path to directory containing tissue segmentation masks (.nii files)	pwd (current directory)
savepath	string	Output directory for results (optimized fields & electrode positions)	'F:\results\mice_tACS\'
tag	string	Identifier for the simulation (used in output filenames)	'mice'
species	string	Anatomical model ('mice', 'rat', 'monkey')	'mice'
showbrain	0/1	Visualize 3D brain model with electric fields (1=enable)	1
coordspath	string	Path to electrode coordinates file (.txt format)	'.\coords_mice.txt'
targetcoord	[x,y,z]	Voxel coordinates of the target brain region	[203, 139, 130]
method	string	Optimization objective ('intensity' or 'focus')	'intensity'
📂 File Formats
1. Electrode Coordinates File (coordspath)
Plain text file with one electrode per line (X/Y/Z voxel coordinates):

text
192 150 120  
185 155 118  
...  
2. Output Files
Optimized electric field map: {tag}_optimized_field.nii

Electrode configuration: {tag}_optimal_positions.pos

Log file: {tag}_optimization_log.txt

🚀 Example Usage
Case 1: Maximize Field Intensity in Mouse Hippocampus
matlab
tissuemaskpath = pwd;  
savepath = 'F:\results\mice_tACS\';  
tag = 'mice_hippocampus';  
species = 'mice';  
showbrain = 1;  
coordspath = 'coords_mice.txt';  
targetcoord = [203, 139, 130];  
method = 'intensity';  

reverse_tACS(tissuemaskpath, savepath, tag, species, showbrain, coordspath, targetcoord, method);  
Case 2: Optimize for Focality in Rat Cortex
matlab
species = 'rat';  
targetcoord = [180, 200, 150];  
method = 'focus';  
reverse_tACS(pwd, 'F:\results\rat_focus\', 'rat_cortex', species, 0, 'coords_rat.txt', targetcoord, method);  
⚠️ Troubleshooting
Issue	Solution
Error: Invalid tissue mask	Ensure tissuemaskpath contains valid .nii files segmented by tissue type.
Missing ISO2Mesh	Download from SourceForge and add to MATLAB path.
Electrode out of bounds	Check coordspath values are within the anatomical model dimensions.
📜 Citation
If using this tool in your research, please cite:


