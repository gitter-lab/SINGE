#!/bin/bash
# Compare the SCINGE_Example.m output with the reference output
# Must have already run SCINGE_Example.m using the default output directory
# Must have Python package csvdiff installed https://pypi.org/project/csvdiff/
csvdiff --style=summary --sep='	' --significance=5 Gene_Name ../Output/SCINGE_Gene_Influence.txt reference/SCINGE_Gene_Influence.txt
