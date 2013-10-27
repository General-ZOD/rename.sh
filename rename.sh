RETVAL=0
command_name=rename.sh #dynamically change to the name of file
option=$1
old_file=$2
new_file=$3
directory_option="-d"
file_option="-f"
error_mesg=

help_function(){
  echo -e "To use command, enter '$command_name option old_file new_file'"
  echo -e "Options are -f for files or -d for directory"
}

copy_directory(){
 echo -e "Copying $old_file....\c"
 cp -r "$old_file" "$new_file"
 RESULT=$?
 if test $RESULT != "0"
   then mesg="Error copying the folder. Command aborted"
    RETVAL=2
 else
    rm -rf "$old_file"
    RESULT=$?
    if test $RESULT != "0"
     then mesg="Error deleting the folder. Command aborted"
          display_mesg
       RETVAL=2
    else mesg="Done"
         display_mesg
         RETVAL=0
    fi
 fi
}

copy_file(){
 echo -e "Copying $old_file....\c"
 cp "$old_file" "$new_file"
 RESULT=$?
 if test $RESULT != "0"
   then mesg="Error copying the file. Command aborted"
    RETVAL=2
 else
    rm -f "$old_file"
    RESULT=$?
    if test $RESULT != "0"
     then mesg="Error deleting the file. Command aborted"
          display_mesg
       RETVAL=2
    else mesg="Done"
         display_mesg
         RETVAL=0
    fi
 fi
}

display_mesg(){
 echo -e "$mesg"
}

if test $# -ne 3
 then help_function
  RETVAL=1 
elif test $option != $directory_option && test $option != $file_option
 then help_function
  RETVAL=2
elif test ! -f "$old_file" && test ! -d "$old_file" # old_file does not exists as file
 then 
  echo -e "$old_file does not exist. Command aborted"
  RETVAL=2
elif test -f "$new_file" && test "$option" = $file_option #new filename already exists
 then
  echo -e "$new_file already exists. Command aborted"
  RETVAL=2
elif test -d "$new_file" && test "$option" = $directory_option #new directory already exists
 then
  echo -e "$new_file already exists. Command aborted"
  RETVAL=2
elif test -f "$old_file" && test "$option" != "$file_option"
 then
  echo -e "$old_file must be a file. Command aborted"
  RETVAL=2 
elif test -d "$old_file" && test "$option" != "$directory_option"
 then
  echo -e "$old_file must be a folder. Command aborted"
  RETVAL=2
else #do the appropriate thing
   if test $option = $directory_option # copy directory
    then
     copy_directory
   else # copy file
     copy_file
   fi
fi

exit $RETVAL
