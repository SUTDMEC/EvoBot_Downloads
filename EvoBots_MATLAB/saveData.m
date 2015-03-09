function out = saveData (in)

dropdir='Z:\Temasek Laboratories\STARS\in datas\';
filename=strcat(dropdir,'all_data',datestr(now,'yy_mm_dd_HH_MM'),'.mat');

results=dir(dropdir);
num= length(results(not([results.isdir])));
if exist(filename, 'file') == 2 %increment file in case the old file exists
    filename=strcat(dropdir,'all_data',datestr(now,'yy_mm_dd_HH_MM'),'_',num+1,'_','.mat');
else
   save(filename,'in');
end
out.success=1;

out.filename=filename;
