function dist=get_dist(imfolder, start_name, end_name,delta)


cd(imfolder)

scene1Image=imread(strcat(start_name,'.pgm'));
scene2Image=imread(strcat(end_name,'.pgm'));

cd('C:\Users\SUTD\Documents\GitHub\STARScontrol')
[newexitPolygon1, newpipePolygon1, EP1, PP1]=Obj_reco_final(scene1Image,imfolder);

[newexitPolygon2, newpipePolygon2, EP2, PP2]=Obj_reco_final(scene2Image,imfolder);


if EP1>PP1
    
    p1=newexitPolygon1(2,1)-newexitPolygon1(1,1);
    p2=newexitPolygon2(2,1)-newexitPolygon2(1,1);
else p1=newpipePolygon1(2,1)-newpipePolygon1(1,1);
    p2=newpipePolygon2(2,1)-newpipePolygon2(1,1);
end

dist=p2*delta/(p2-p1);
