dbclear all;

% compile matlab wrappers
disp('Building wrappers ...');
mex('matcherMex.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\matcher.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\filter.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\triangle.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\matrix.cpp','-IC:\Users\SUTD\Documents\GitHub\STARScontrol\src\','CXXFLAGS=-msse3 -fPIC');
mex('visualOdometryStereoMex.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\viso_stereo.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\viso.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\matcher.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\filter.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\triangle.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\matrix.cpp','-IC:\Users\SUTD\Documents\GitHub\STARScontrol\src\','CXXFLAGS=-msse3 -fPIC');
mex('visualOdometryMonoMex.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\viso_mono.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\viso.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\matcher.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\filter.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\triangle.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\matrix.cpp','-IC:\Users\SUTD\Documents\GitHub\STARScontrol\src\','CXXFLAGS=-msse3 -fPIC');
mex('reconstructionMex.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\reconstruction.cpp','C:\Users\SUTD\Documents\GitHub\STARScontrol\src\matrix.cpp','-IC:\Users\SUTD\Documents\GitHub\STARScontrol\src\','CXXFLAGS=-msse3 -fPIC');
disp('...done!');

