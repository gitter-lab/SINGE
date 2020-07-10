#!/bin/bash
# Compile SINGE_GLG_Test.m and SINGE_Aggregate.m for macOS
# Run from the repository base directory

# Compile SINGE creating binaries for SINGE_GLG_Test.m and SINGE_Aggregate.m
# Rename both files to include the _mac suffix so that there are not filename collisions
mv code/SINGE_GLG_Test.m code/SINGE_GLG_Test_mac.m
mcc -N -m -R -singleCompThread -R -nodisplay -R -nojvm -a ./glmnet_matlab/ -a ./code/ SINGE_GLG_Test_mac.m
mv code/SINGE_GLG_Test_mac.m code/SINGE_GLG_Test.m
mv readme.txt readme_SINGE_GLG_Test_mac.txt

mv code/SINGE_Aggregate.m code/SINGE_Aggregate_mac.m
mcc -N -m -R -singleCompThread -R -nodisplay -R -nojvm -a ./code/ SINGE_Aggregate_mac.m
mv code/SINGE_Aggregate_mac.m code/SINGE_Aggregate.m
mv readme.txt readme_SINGE_Aggregate_mac.txt

tar cfz SINGE_mac.tgz SINGE_GLG_Test_mac.app SINGE_Aggregate_mac.app
rm -rf SINGE_GLG_Test_mac.app
rm -rf SINGE_Aggregate_mac.app
