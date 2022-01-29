#!bin/zsh

#/*
# Simple script to hide a folder zipped with password in a specified location
#*/

START_DIR="$PWD"
END_DIR="/goinfre"
TESTDIR_NAME=".test1"
SUBFOLDER_NAME=".02"
TOCPY_DIRNAME=".t2"
ZIP_NAME="zip"
CP_DIRPATH="$HOME/Desktop/$TOCPY_DIRNAME"
ZIP_NAME_DOT_ZIP="$ZIP_NAME.zip"
ZIP_PATH="$HOME/Desktop/$ZIP_NAME_DOT_ZIP"

function change_time_single_file() {
	touch -t 06011102 $1
	echo "Time changed for $1"
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

echo $START_DIR
cd $CP_DIRPATH
echo "cd $CP_DIRPATH"
cd ..
zip -er $ZIP_NAME_DOT_ZIP $CP_DIRPATH
cd $END_DIR
rm -rf $TESTDIR_NAME || true
echo "rm -rf $TESTDIR_NAME"
mkdir $TESTDIR_NAME
echo "mkdir $TESTDIR_NAME"
cd $TESTDIR_NAME
rm -rf $SUBFOLDER_NAME || true
echo "rm -rf $SUBFOLDER_NAME"
mkdir $SUBFOLDER_NAME
echo "mkdir $SUBFOLDER_NAME"
cd $PWD/$SUBFOLDER_NAME

apply_to_every_subfolder $PWD
#touch -t 202001101125 . every file and folder starting from .
#find . -type f -exec touch -t 202001101125 {} \;
cp $ZIP_PATH .
cd $START_DIR
change_time_single_file $END_DIR/$TESTDIR_NAME
change_time_single_file $END_DIR/$TESTDIR_NAME/$SUBFOLDER_NAME
exec zsh