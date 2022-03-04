#!/usr/bin/python3
############################################
#                                          #
#  THE FRC DETECTIVE PROJECT               #
#  GITHUB.COM/MITCHELLBLASER/FRCDETECTIVE  #
#                                          #
############################################

#TODO: Implement function here.
#      Needs to be able to handle new dictionary keys being added after initial commit
#      e.g. Team photo may not exist in commit 0 but might in commit 3
#      so we would need to make sure that isn't left behind.
# 
#      If our function ever needs to make a change, we would add a new commit to the file,
#      with the most up-to-date timestamp+0.000001 (or something?) 
#
#      Also, do we need functionality to account for the very rare edge-case where we have
#      two commits with the same exact timestamp? If we do this we can use the same timestamp
#      in our merges, and just have it sit below the other one in the file or something.
#
#      An afterthought - is this going to be easier if it's done on the client-side?