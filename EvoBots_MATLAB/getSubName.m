function [ nameTests ] = getSubName( root_dir )
%get the number of test folders in the root
d = dir(root_dir);
isub = [d(:).isdir]; %# returns logical vector
nameTests = {d(isub).name}';
%remove over directories
nameTests(ismember(nameTests,{'.','..'})) = [];

end

