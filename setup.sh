#!/bin/bash

test -f setupLog.txt && rm setupLog.txt

printSuccesOrFailure ()
{
	if [ $? -eq 0 ]; then
		(echo $1 : OK ; echo "") >> setupLog.txt
		(echo "#################" $1 : OK "##################" ; echo "")
	else
		(echo $1 : FAILURE ; echo "") >> setupLog.txt
		failedPrograms+=( $1 )
		(echo "#################" $1 : FAILURE "#############" ; echo "")
	fi
}

## declare an array of programs to install

declare -a programs=(	"git"
			"gitk"
			"make"
			"cmake"
			"vim"
			"g++"
			"clang"
			"gdb"
			"valgrind"
			"clang-tidy"
			"kdiff3"
			"dos2unix"
			"wget"
			"snapd-xdg-open"
			"libgconf-2-4" ## dependency for discord
			"libappindicator1" ## dependency for discord
		    )
## declare an array of programs that needs to be installed via snapd

declare -a snapPrograms=( "discord"
			  "code"
			)

## declare an array of failed programs

declare -a failedPrograms=()

## loop over the array and install programs

for i in "${programs[@]}"
do
	sudo apt-get install "$i" -y
	printSuccesOrFailure $i
done

## loop over the array and install snapPrograms

for i in "${snapPrograms[@]}"
do
	sudo snap install "$i"
	printSuccesOrFailure $i 
done

## print programs that ended with failure (if there are any)

if [ ${#failedPrograms[@]} != 0 ]; then
	echo "These packages ended with FAILURE: "
	for i in "${failedPrograms[@]}"
	do
		(echo ""$i"" ; echo "")
	done
fi
