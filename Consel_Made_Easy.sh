#!/bin/bash
#Consel made easy by Simon Uribe-Convers
# http://www.simonuribe.com
#December 19 2011
#version 1.0
echo ""
echo ""
echo ""
echo "~~~~>>>>> O <<<<<~~~~"
echo ""
echo "Welcome to Consel made easy!"
echo "Written by Simon Uribe-Convers"
echo "www.simonuribe.com"
echo "University of Idaho"
echo ""
echo "I have a couple of asumptions:"
echo "1- The name of the constraint file is: *_constraint"
echo "2- The phylip file you'll use for RAxML is the only *.phy file in the directory"
echo "3- You already conducted an unconstraint analysis in RAxML and the best tree with bipartitions of that analysis is in this directory"
echo ""
echo "Also, I'll assume that you have an executable threaded version of RAxML in your /usr/local/bin/ directory"
echo ""
echo "~~~~~~~~ATTENTION~~~~~~~~~"

echo "If this script finishes too quickly and there are no AUTest results, there is something wrong with your initial trees"
echo "Check the file 'info_RAxML_with_constraint.log' for errors during RAxML execution"
echo ""
echo ""
echo "Which version of RAxML would you like to use? Please type the line number of the version you want to use. ~~Up to 5 versions can be chosen~~"
ls /usr/local/bin/|grep raxm* | sed -n '1p'>1 | ls /usr/local/bin/|grep raxm* | sed -n '2p'>2 | ls /usr/local/bin/|grep raxm* | sed -n '3p'>3 | ls /usr/local/bin/|grep raxm* | sed -n '4p'>4| ls /usr/local/bin/|grep raxm* | sed -n '5p'>5
chmod 755 1 2 3 4 5
echo "-T 2 -f a -x 12456 -p 987 -\# 250 -m GTRGAMMA -g *_constraint -s *.phy -n zz_analysis_with_constranit > info_RAxML_with_constraint.log" > RAxML_commands
echo "-T 2 -f g -m GTRGAMMA -z File_with_unconstraint_and_constraint_trees -s *.phy -n PSL > info_per_site_likelihoods.log" > per_site_likelihood_commands
cat 1 RAxML_commands | tr '\n' ' ' | cat > 1_RAxML
cat 2 RAxML_commands | tr '\n' ' ' | cat > 2_RAxML
cat 3 RAxML_commands | tr '\n' ' ' | cat > 3_RAxML
cat 4 RAxML_commands | tr '\n' ' ' | cat > 4_RAxML
cat 5 RAxML_commands | tr '\n' ' ' | cat > 5_RAxML
cat 1 per_site_likelihood_commands | tr '\n' ' ' | cat > 1_per_site_likelihood
cat 2 per_site_likelihood_commands | tr '\n' ' ' | cat > 2_per_site_likelihood
cat 3 per_site_likelihood_commands | tr '\n' ' ' | cat > 3_per_site_likelihood
cat 4 per_site_likelihood_commands | tr '\n' ' ' | cat > 4_per_site_likelihood
cat 5 per_site_likelihood_commands | tr '\n' ' ' | cat > 5_per_site_likelihood
chmod 755 1_RAxML 2_RAxML 3_RAxML 4_RAxML 5_RAxML 1_per_site_likelihood 2_per_site_likelihood 3_per_site_likelihood 4_per_site_likelihood 5_per_site_likelihood
rm 1 2 3 4 5
ls /usr/local/bin/|grep raxm*
read RAxML
if [ $RAxML == 1 ]
then
	./1_RAxML | rm 2_RAxML 3_RAxML 4_RAxML 5_RAxML 2_per_site_likelihood 3_per_site_likelihood 4_per_site_likelihood 5_per_site_likelihood
elif [ $RAxML == 2 ]
then
	./2_RAxML | rm 1_RAxML 3_RAxML 4_RAxML 5_RAxML 1_per_site_likelihood 3_per_site_likelihood 4_per_site_likelihood 5_per_site_likelihood
elif [ $RAxML == 3 ]
then
	./3_RAxML | rm 1_RAxML 2_RAxML 4_RAxML 5_RAxML 2_per_site_likelihood 1_per_site_likelihood 4_per_site_likelihood 5_per_site_likelihood
elif [ $RAxML == 4 ]
then
	./4_RAxML | rm 1_RAxML 2_RAxML 3_RAxML 5_RAxML 2_per_site_likelihood 3_per_site_likelihood 1_per_site_likelihood 5_per_site_likelihood
elif [ $RAxML == 5 ]
then
	./5_RAxML | rm 1_RAxML 2_RAxML 3_RAxML 4_RAxML 2_per_site_likelihood 3_per_site_likelihood 4_per_site_likelihood 1_per_site_likelihood
else
	echo "No RaxML version available"
	echo "Program Terminated"

echo "     ___     "
echo "  .-\'   \`-."	        
echo " / /\   /\ \ "	        
echo ". /__\ /__\ ."	        
echo "|___  ^  ___|"	        
echo "    |   |    "	        
echo "    |[[[|    "	        
echo ""
echo ""
echo ""
exit
fi
echo ""
echo "I'm creating a file containing two trees, the first one obtained from an unconstraint ML analysis and the second one from a ML constraint one"
cat RAxML_bipartitions.* > File_with_unconstraint_and_constraint_trees
echo ""
echo "Obtaining per site likelihoods"
./*_per_site_likelihood 
rm RAxML_commands per_site_likelihood_commands *_RAxML *_per_site_likelihood
echo ""

if cat info_RAxML_with_constraint.log | grep ERROR; then
echo""
echo""
echo "~~~~~~~~ATTENTION~~~~~~~~~ERROR~~~~~~~~ATTENTION~~~~~~~~~"
echo""
echo "There is an error with your RAxML trees, check the info_RAxML_with_constraint.log for more information"
echo "" 
echo "" 
echo "" 
exit 1

elif grep exiting info_RAxML_with_constraint.log; then

echo""
echo""
echo "~~~~~~~~ATTENTION~~~~~~~~~ERROR~~~~~~~~ATTENTION~~~~~~~~~"
echo""
echo "You have old files in your working directory that need to be deleted, check the info_RAxML_with_constraint.log for more information"
echo "" 
echo "" 
echo "" 
exit 1

else
echo "" 
fi

echo "Running Consel in a directory called AUTest"
mkdir AUTest
cp RAxML_perSiteLLs.* ./AUTest
cd AUTest
seqmt --puzzle RAxML_perSiteLLs.*
makermt *.mt
consel *.rmt
catpv *.pv>Results_AuTest.txt
echo ""
echo "Boomslam! Your results are ready, leave that snack and get to work!"
echo "                                                           _"
echo "                                                          //"
echo "                                                         //"
echo "                                         _______________//__"
echo "                                       .(______________//___)."
echo "                                       |              /      |"
echo "                                       |. . . . . . . / . . .|"
echo "                                       \ . . . . . ./. . . . /"
echo "                                        |           / ___   |"
echo "                    _.---._             |::......./../...\.:|"
echo "                _.-~       ~-._         |::::/::\::/:\::::::|"
echo "            _.-~               ~-._     |::::\::/::::::X:/::|"
echo "        _.-~                       ~---.;:::::::/::\::/:::::|"
echo "    _.-~                                 ~\::::::n::::::::::|"
echo " .-~                                    _.;::/::::a::::::::/"
echo " :-._                               _.-~ ./::::::::d:::::::|"
echo " \`-._~-._                   _..__.-~ _.-~|::/::::::::::::::|"
echo "  /  ~-._~-._              / .__..--~----.YWWWWWWWWWWWWWWWP\'"
echo " \_____{_;-._\.        _.-~_/       ~).. . \"
 "   /{_____  \`--...--~_.-~______..-+_______/"
 "  __________/\`--...---/    _/           /\"
echo " /-._     \_     /___./_..-~__.....__..-~./"
echo " \`-._~-._   ~\--------~  .-~_..__.-~ _.-~"
echo "     ~-._~-._ ~---------\'  / .__..--~"
echo "         ~-._\.        _.-~_/"
echo "             \`--...--~_.-~"
echo "              \`--...--~"
echo ""
echo ""
echo "~~~~>>>>> O <<<<<~~~~"