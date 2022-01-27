#!bin/zsh
START_DIR="$PWD"
TESTDIR_NAME=".test1"
SUBFOLDER_NAME=".02"
TOCPY_DIRNAME=".t02"
CP_DIRPATH="$HOME/Desktop/$TOCPY_DIRNAME"

function change_time_single_file() {
	touch -t 202001101125 $1
}

#function to apply change_time_single_file recursively
function apply_to_every_subfolder() {
	#this for loop will iterate through all the files in the $1 directory
	for d in $(find $1 -mindepth 1 -maxdepth 7 -type d)
		do
		#Do something, the directory is accessible with $d:
		echo $d
	done
}


# function apply_to_every_subfolder() {
#     #for every subfolder in the current folder
#     for subfolder in $1; do
#         #if this element is a folder, then call this function again
#         if [ -d "${subfolder}" ]; then
#             cd "${subfolder}"
#             echo subfolder: "${subfolder}"
#             apply_to_every_subfolder $1
#             cd ..
#         else
#             #if this element is a file, then change the time
#             echo file: "${subfolder}"
#             #change_time_single_file "${subfolder}"
#         fi
#     done
# }

echo $START_DIR
cd /goinfre
if [ -d $TESTDIR_NAME ]
then
	echo $TESTDIR_NAME present
else
	echo $TESTDIR_NAME creating it
	mkdir $TESTDIR_NAME
fi
change_time_single_file $TESTDIR_NAME
cd $TESTDIR_NAME
change_time_single_file $SUBFOLDER_NAME
if [ -d $SUBFOLDER_NAME ]
then
	echo $SUBFOLDER_NAME present
else
	echo $SUBFOLDER_NAME creating it
	mkdir $SUBFOLDER_NAME
fi
cd $SUBFOLDER_NAME
cp -R $CP_DIRPATH .

apply_to_every_subfolder $PWD
#touch -t 202001101125 . every file and folder starting from .
#find . -type f -exec touch -t 202001101125 {} \;
cd $START_DIR
history -c
exec zsh