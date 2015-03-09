%this script deletes every 4th file in a directory for creating a
%successful synth run

target_dir='C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\FloorPhone_TL';

flist=getAllFiles(target_dir);

jump=5;

for i=1:jump:length(flist)
    delete(flist{i});
    
end