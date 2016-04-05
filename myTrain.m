train_dir = 'speechdata/Training'
% Remember to change for CDF file structure
bnt_dir = 'bnt'
M = 8;
Q = 3;
initType = 'kmeans';
max_iter = 3;
output_file = './hmm/';

speakers = dir([train_dir, filesep])

TIMITlst = {'b','d','g','p','t','k','dx','q','jh','ch','s','sh','z','zh','f','th','v', 'dh','m','n','ng','em','en','eng','nx','l','r','w','y','hh','hv','el','iy','ih', 'eh','ey','ae','aa','aw','ah','ao','oy','ow','uh','uw','ux','er','ax','ix','axr', 'ax-h','pau','epi','h#','1','2','bcl','dcl', 'gcl', 'pcl', 'tcl', 'kcl'};
