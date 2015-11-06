#!/bin/bash
TODAY=`date +%Y-%m-%d.%H:%M`
PRESENT=`date`
PRESENTDATE=`date +%Y-%m-%d.%H:%M:%S`
re='^[0-9]+$'
# ----------------------------------- Update your parameters below below this line ---------------------------------------------

# You can create your file name in two ways. This is file name in which all log will be generated.
FILE_NAME_WITHOUT_DATE=log_all.log
FILE_NAME_WITH_DATE=log_.$TODAY.log

# Change file naming type according to your requirement

# FILE_TO_BE_WRITTEN=$FILE_NAME_WITHOUT_DATE
FILE_TO_BE_WRITTEN=$FILE_NAME_WITHOUT_DATE

# You can also CHECK PATTERN in Log files and can also do specific operation on specific PATTERN. You can also make a new PATTERN by defining new variable and binding it to new operation.
PATTERN1="ERROR"
PATTERN2="Error"
PATTERN3="error" 

# ----------------------------------------- Dont' update anything below this line -----------------------------------------------------

D_CHECK=false
P_CHECK=false
T_CHECK=false
N_CHECK=false
F_CHECK=false
FS_CHECK=false
H_CHECK=false
A_CHECK=false
z_CHECK=false
HELP_CHECK=false

P_COUNT=0
F_COUNT=0
FS_COUNT=0
LAST=0

D_COUNTER=0
P_COUNTER=0
F_COUNTER=0
FS_COUNTER=0
T_COUNTER=0
N_COUNTER=0
A_COUNTER=0
Z_COUNTER=0
H_COUNTER=0
HELP_COUNTER=0

D_INT=0
P_INT=0
T_INT=0
N_INT=0
F_INT=0
FS_INT=0
A_INT=0
Z_INT=0
H_INT=0
HELP_INT=0

msg_show_once=false
APPEND_LOG=false
LOG_FILE_NAME_WITH_TIMESTAMP=false
EXPECTED_ARGS=1
E_BADARGS=65
COUNTER_INFO=true
LOG_PROPERTY_FILE=log.properties
MAN_FILE=/usr/man/man1/logdebugg.1.gz
log_file_created=false

show_start () {

	echo -##-------------------------------------------------------------------------------------------------------------------------------------##
		echo -e  -# '\t''\t''\t''\t''\t''\t''\t'--==* LOG FILE DEBUGGER *==--'\t''\t''\t''\t''\t''\t''\t'-#
		echo -##-------------------------------------------------------------------------------------------------------------------------------------##
}

show_at_illegal_arguments () {
	echo
		echo -e \!\!\!\!\! Invalid or incomplete argument\(s\).  \!\!\!\!\!
		echo
		echo --------------------------------------------------------------------
		echo \| \'Log File\' or \'Folder\' Path is expected after \'-p\' or \'-f\',\'-fs\' \|
		echo --------------------------------------------------------------------
		echo -e For More Help:
		echo -e '\t'  Execute : man logdebugg \(or\)
		echo -e '\t'  Execute : ./logdebugger.sh --help
}

show_help () {
	echo
		echo -e Usage: logdebugger [OPTION]... [PATH]...
		echo -e Filters and collects all logs based on user input log path and modes of filter.
		echo -e Greps logs based on:
		echo -e '\t''\t'1\) timestamp = logs touched \in \last t minute
		echo -e '\t''\t'2\) no-of-lines = n lines of logs from all specified logs
		echo -e 
		echo -e Mandatory arguments to long options are mandatory \for short options too.
		echo -e '\t'-a,'\t''\t'append new logs that are generated by grepping all logs
		echo -e '\t''\t''\t'to previous log file.
		echo
		echo -e '\t'-d,'\t''\t'It takes path of log \file\(s\) from log.properties \file \which 
		echo -e '\t''\t''\t'is auto generated \in present working directory.
		echo
		echo -e '\t'-f,'\t''\t'It takes folder\(s\) as an input, and searches all log files
		echo -e '\t''\t''\t'within folder and filters all logs based on timestamp or 
		echo -e '\t''\t''\t'no. of. logs.
		echo
		echo -e '\t'-fs,'\t''\t'It takes folder\(s\) as an input, and searches all log files
		echo -e '\t''\t''\t'within folders and sub-folders and filters all logs based on  
		echo -e '\t''\t''\t'timestamp or no. of. logs.
		echo
		echo -e '\t'-h,'\t''\t'It shows \help menu.
		echo
		echo -e '\t'-n,'\t''\t'It greps logs based on no-of-lines. It expects an integer 
		echo -e '\t''\t''\t'argument. Last \'n\'\(integer argument\) lines of all logs are filtered.
		echo -e '\t''\t''\t'If any integer is not passed after \'-n\' \then by default it
		echo -e '\t''\t''\t'takes 50 lines of logs. 
		echo
		echo -e '\t'-p,'\t''\t'It takes path of log \file\(s\) from user through terminal
		echo -e '\t''\t''\t'window. User can pass any number of path\(s\). Enter path of 
		echo -e '\t''\t''\t'log \file\(s\) just after \'-p\'.
		echo
		echo -e '\t'-t,'\t''\t'It greps logs based on timestamp. It expects an integer 
		echo -e '\t''\t''\t'argument. Logs touched after \'t\'\(integer argument\)mins are filtered.
		echo -e '\t''\t''\t'If any integer is not passed after \'-t\' \then by default it
		echo -e '\t''\t''\t'takes 5 mins. 
		echo
		echo -e '\t'-z,'\t''\t'It changes naming convention of new log file. By passing \'-z\' as
		echo -e '\t''\t''\t'an argument, new name of log \file becomes \'log_.yyyy-mm-dd.hh:mm.log\'.
		echo -e '\t''\t''\t'This helps users to keep logs of every minute and can later be used \for
		echo -e '\t''\t''\t'comparison.
		echo
		echo -e Report bugs to \'rishi.anand0@outlook.com\'.

}

show_commands () {
	echo -##-------------------------------------------------------------------------------------------------------------------------------------##
		echo -e  -# '\t''\t''\t''\t''\t''\t''\t'--==* LOG FILE DEBUGGER *==--'\t''\t''\t''\t''\t''\t''\t'-#
		echo -e  -# '\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t'-#
		echo -e  -# '\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t'-# 
		echo -e -#'\t''\t''\t''\t''\t''\t''\t'[ RISHI ANAND \| rishi@cliqr.com ] '\t''\t''\t''\t''\t''\t'-#
		echo -##-------------------------------------------------------------------------------------------------------------------------------------##
		echo 
		echo -e '\t''\t''\t''\t''\t''\t''\t'  Execute : man logdebugg \(or\)
		echo -e '\t''\t''\t''\t''\t''\t''\t'  Execute : ./logdebugger --help
		echo 
}

log_initial_write () {
	touch -- "$FILE_TO_BE_WRITTEN"

		echo  >> $FILE_TO_BE_WRITTEN
		echo -##-------------------------------------------------------------------------------------------------------------------------------------## >> $FILE_TO_BE_WRITTEN
		echo -e  -# '\t''\t''\t''\t''\t''\t''\t'--==* LOG FILE DEBUGGER *==--'\t''\t''\t''\t''\t''\t''\t'-# >> $FILE_TO_BE_WRITTEN
		echo -e  -# '\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t'-# >> $FILE_TO_BE_WRITTEN
		echo -e  -# '\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t'-# >> $FILE_TO_BE_WRITTEN
		echo -e -#'\t''\t''\t''\t''\t''\t''\t'[ RISHI ANAND \| rishi@cliqr.com ] '\t''\t''\t''\t''\t''\t'-# >> $FILE_TO_BE_WRITTEN
		echo -##-------------------------------------------------------------------------------------------------------------------------------------## >> $FILE_TO_BE_WRITTEN
		echo  >> $FILE_TO_BE_WRITTEN
		echo =================== Below Log is from Computer Name : $HOSTNAME =================== >> $FILE_TO_BE_WRITTEN 
		echo =================== Log Generation Time : $PRESENT =================== >> $FILE_TO_BE_WRITTEN 
#	echo =================== Log Generated Time : $PRESENTDATE =================== >> $FILE_TO_BE_WRITTEN 


}

qsort() {
	local pivot i smaller=() larger=()
		qsort_ret=()
		(($#==0)) && return 0
		pivot=$1
		shift
		for i; do
			if [[ $i < $pivot ]]; then
				smaller+=( "$i" )
			else
				larger+=( "$i" )
					fi
					done
					qsort "${smaller[@]}"
					smaller=( "${qsort_ret[@]}" )
					qsort "${larger[@]}"
					larger=( "${qsort_ret[@]}" )
					qsort_ret=( "${smaller[@]}" "$pivot" "${larger[@]}" )
}

create_man_page () {

	mancheck=/usr/man/
		if [ ! -d "$mancheck" ];then
			sudo mkdir /usr/man/
				fi

				mancheckman1=/usr/man/man1
				if [ ! -d "$mancheckman1" ];then
					sudo mkdir /usr/man/man1/
						fi


						echo .\" Process this \file with >> test.1.g
						echo .\" groff -man -Tascii logdebugg.1 >> test.1.g
						echo .\" >> test.1.g
						echo .TH logdebugg 1 \"JULY 2015\" Linux \"User Manuals\" >> test.1.g
						echo .SH NAME >> test.1.g
						echo logdebugg \-  debuggs and analyzes logs >> test.1.g
						echo .SH SYNOPSIS >> test.1.g
						echo .B logdebugg [-OPTIONS]... [-c >> test.1.g
						echo .I log.properties >> test.1.g
						echo .B ] >> test.1.g
						echo .I \file >> test.1.g
						echo .B ... >> test.1.g
						echo .SH DESCRIPTION >> test.1.g
						echo .B logdebugg >> test.1.g
						echo analyzes log based on timestamp or number of tail-lines from >> test.1.g
						echo each log file. This Shell Script collects all logs based on user Input Parameters. >> test.1.g
						echo Logs can be collected \in two Modes:  >> test.1.g
						echo .BR TimeStamp >> test.1.g
						echo or >> test.1.g
						echo .BR No. of Lines >> test.1.g
						echo In  >> test.1.g
						echo .BR TimeStamp >> test.1.g
						echo all logs will be collected \which are  >> test.1.g
						echo .BR touched  >> test.1.g
						echo .BR \in  >> test.1.g
						echo .BR ‘t’  >> test.1.g
						echo .BR minute  >> test.1.g
						echo duration. In  >> test.1.g
						echo .BR No.  >> test.1.g
						echo .BR of   >> test.1.g
						echo .BR Lines,  >> test.1.g
						echo .BR ‘n’  >> test.1.g
						echo .BR number  >> test.1.g
						echo .BR of  >> test.1.g
						echo .BR logs  >> test.1.g
						echo from end will be collected. Input path can be given \in two ways: >> test.1.g 
						echo by passing argument or by passing address \in properties file.  >> test.1.g
						echo User input is being  >> test.1.g
						echo .BR validated  >> test.1.g
						echo and \for incorrect user input, User is shown list of Parameters.  >> test.1.g
						echo Properties \file gets created automatically \if \do not exist,  >> test.1.g
						echo and shows \help menu whenever shell script is executed with  >> test.1.g
						echo .BR ‘--help command’   >> test.1.g
						echo and \then user can pass address of  >> test.1.g
						echo .BR multiple  >> test.1.g
						echo .BR log   >> test.1.g
						echo files. >> test.1.g
						echo Also it  >> test.1.g
						echo .BR Analyses  >> test.1.g
						echo .BR log  >> test.1.g
						echo .BR files  >> test.1.g
						echo with some  >> test.1.g
						echo .BR PATTERN  >> test.1.g
						echo and highlights area of log \file where PATTERN is found and a  >> test.1.g
						echo .BR specific  >> test.1.g
						echo .BR operation  >> test.1.g
						echo .BR can  >> test.1.g
						echo .BR be  >> test.1.g
						echo .BR performed  >> test.1.g
						echo \for each  >> test.1.g
						echo .BR PATTERN  >> test.1.g
						echo like  >> test.1.g
						echo .BR installing  >> test.1.g
						echo .BR a  >> test.1.g
						echo .BR service  >> test.1.g
						echo or  >> test.1.g
						echo .BR moving  >> test.1.g
						echo .BR some  >> test.1.g
						echo .BR \file  >> test.1.g
						echo from one DIRECTORY into another DIRECTORY. >> test.1.g
						echo .SH OPTIONS >> test.1.g
						echo .IP -d >> test.1.g
						echo Default option. It takes log \file path from >> test.1.g 
						echo .I \'log.properties\'  >> test.1.g
						echo file. >> test.1.g
						echo .IP \"-p\" >> test.1.g
						echo Takes User Input \in argument form. User can pass >> test.1.g 
						echo .BR path  >> test.1.g
						echo .BR of  >> test.1.g
						echo .BR log  >> test.1.g
						echo .BR files  >> test.1.g
						echo after \'-p\' command. User can pass any number of log files. >> test.1.g
						echo Output \file is generated \in >> test.1.g
						echo .IR \'\pwd\'. >> test.1.g
						echo .IP -t >> test.1.g
						echo It filters log \file and generates logs that are touched \in LAST >> test.1.g 
						echo .I \'t\' minute. >> test.1.g
						echo It expects an integer parameter. However \if integer is not passed,  >> test.1.g
						echo It takes \'5 min\' timestamp by default. >> test.1.g
						echo .IP -n >> test.1.g
						echo It filters log \file based on  >> test.1.g
						echo .I \'no. of lines\' >> test.1.g
						echo at \tail from each log file. It expects an integer parameter. However \if integer is not passed, >> test.1.g 
						echo It takes \'50 lines\' by default.  >> test.1.g
						echo .IP -f >> test.1.g
						echo It filters all log files \in folder that is given by user following >> test.1.g
						echo .I \'-f\' parameter  >> test.1.g
						echo and generates logs based on what user chooses, either  >> test.1.g
						echo .I \'t\' minute >> test.1.g
						echo timestamp or >> test.1.g
						echo .I \'n\' lines >> test.1.g
						echo of logs. >> test.1.g
						echo .IP -fs >> test.1.g
						echo It filters all log files \in folder and sub-folders \in it. Folder path is given by user following >> test.1.g
						echo .I \'-fs\' parameter  >> test.1.g
						echo and generates logs based on what user chooses, either  >> test.1.g
						echo .I \'t\' minute >> test.1.g
						echo timestamp or >> test.1.g
						echo .I \'n\' lines >> test.1.g
						echo .IP -a >> test.1.g
						echo It appends previous log \file \if it exists. If   >> test.1.g
						echo .I \'-a\' >> test.1.g
						echo is not passed as an argument \then Previous log \file is  >> test.1.g
						echo .I \'deleted\' >> test.1.g
						echo by default. >> test.1.g
						echo .IP -z >> test.1.g
						echo It changes new generated log \file naming convention. By passing >> test.1.g
						echo .I \'-z\' parameter  >> test.1.g
						echo new log \file is saved with timestamp \in its name. >> test.1.g
						echo .I  Eg\:log_.yyyy-mm-dd.hh:mm.log >> test.1.g
						echo .IP --h >> test.1.g
						echo It Shows  >> test.1.g
						echo .BR \help >> test.1.g
						echo option. >> test.1.g
						echo .SH FILES >> test.1.g
						echo .I \{\pwd\}\/log.properties >> test.1.g
						echo .RS >> test.1.g
						echo Contains default log \file location and patters. You >> test.1.g
						echo .BR register >> test.1.g
						echo any log \file \in your DIRECTORY and execute it with >> test.1.g
						echo .I \'-d\' command. >> test.1.g
						echo .SH ENVIRONMENT >> test.1.g
						echo .IP logdebugg >> test.1.g
						echo It \do not affects any configuration. >> test.1.g
						echo .SH BUGS >> test.1.g
						echo The \command name should have been chosen \more carefully >> test.1.g
						echo to reflect its purpose. >> test.1.g
						echo .SH AUTHOR >> test.1.g
						echo .BR RISHI  >> test.1.g
						echo .BR ANAND  >> test.1.g
						echo [ rishi.anand0@outlook.com ] >> test.1.g        
						echo .SH \"SEE ALSO\" >> test.1.g
						echo .BR \grep, >> test.1.g
						echo .BR \egrep, >> test.1.g
						echo .BR \fgrep >> test.1.g
						sudo cp test.1.g /usr/man/man1/logdebugg.1.gz
						sudo rm -rf test.1.g

}

create_log_properties_file() {


	if [ ! -e "$LOG_PROPERTY_FILE" ]
		then
			touch -- "$LOG_PROPERTY_FILE"

			echo  >> $LOG_PROPERTY_FILE
			echo log1=cd.log  >> $LOG_PROPERTY_FILE
			echo log2=/var/log/vmware/vmware-usbarb-3360.log  >> $LOG_PROPERTY_FILE
			echo log3=/var/log/glance/api.log  >> $LOG_PROPERTY_FILE
			echo log4=/var/log/vmware/vmware-usbarb-721.log  >> $LOG_PROPERTY_FILE
			echo log5=/var/log/glance/registry.log  >> $LOG_PROPERTY_FILE
			echo log6=/var/log/keystone/keystone-all.log  >> $LOG_PROPERTY_FILE
			echo log7=/var/log/keystone/keystone-manage.log  >> $LOG_PROPERTY_FILE
			echo log8=/var/log/neutron/dhcp-agent.log  >> $LOG_PROPERTY_FILE
			echo log9=/var/log/neutron/l3-agent.log >> $LOG_PROPERTY_FILE
			echo log10=/var/log/neutron/metadata-agent.log  >> $LOG_PROPERTY_FILE
			echo log11=/var/log/neutron/openvswitch-agent.log  >> $LOG_PROPERTY_FILE
			echo log12=/var/log/neutron/ovs-cleanup.log  >> $LOG_PROPERTY_FILE
			echo log13=/var/log/nova/nova-api.log  >> $LOG_PROPERTY_FILE
			echo log14=/var/log/nova/nova-c2015-07-15ert.log  >> $LOG_PROPERTY_FILE
			echo log15=/var/log/nova/nova-conductor.log  >> $LOG_PROPERTY_FILE
			echo log16=/var/log/nova/nova-consoleauth.log  >> $LOG_PROPERTY_FILE
			echo log17=/var/log/nova/nova-manage.log  >> $LOG_PROPERTY_FILE
			echo log18=/var/log/nova/nova-novncproxy.log  >> $LOG_PROPERTY_FILE
			echo log19=/var/log/nova/nova-compute.log  >> $LOG_PROPERTY_FILE
			echo log20=/var/log/nova/nova-scheduler.log  >> $LOG_PROPERTY_FILE
			echo log21=/var/log/openvswitch/ovs-ctl.log  >> $LOG_PROPERTY_FILE
			echo log22=/var/log/openvswitch/ovsdb-server.log  >> $LOG_PROPERTY_FILE
			echo log23=/var/log/openvswitch/ovs-vswitchd.log  >> $LOG_PROPERTY_FILE
			echo log24=/var/log/rabbitmq/shutdown_err  >> $LOG_PROPERTY_FILE
			echo log25=/var/log/rabbitmq/startup_err  >> $LOG_PROPERTY_FILE
			echo log26=/var/log/rabbitmq/startup_log  >> $LOG_PROPERTY_FILE
			echo log27=/var/log/rabbitmq/shutdown_log  >> $LOG_PROPERTY_FILE
			echo log28=ab.log  >> $LOG_PROPERTY_FILE
			echo log29=/var/log/mail.log  >> $LOG_PROPERTY_FILE
			echo log30=  >> $LOG_PROPERTY_FILE
			echo log31=  >> $LOG_PROPERTY_FILE
			echo log32=  >> $LOG_PROPERTY_FILE
			echo log33=  >> $LOG_PROPERTY_FILE
			echo log34=  >> $LOG_PROPERTY_FILE
			echo log35=  >> $LOG_PROPERTY_FILE
			echo log36=  >> $LOG_PROPERTY_FILE
			echo log37=  >> $LOG_PROPERTY_FILE
			echo log38=  >> $LOG_PROPERTY_FILE
			echo log39=  >> $LOG_PROPERTY_FILE
			echo log40=  >> $LOG_PROPERTY_FILE
			echo log41=  >> $LOG_PROPERTY_FILE
			echo log42=  >> $LOG_PROPERTY_FILE
			echo log43=  >> $LOG_PROPERTY_FILE
			echo log44=  >> $LOG_PROPERTY_FILE
			echo log45=  >> $LOG_PROPERTY_FILE
			echo log46=  >> $LOG_PROPERTY_FILE
			echo log47=  >> $LOG_PROPERTY_FILE
			echo log48=  >> $LOG_PROPERTY_FILE
			echo log49=  >> $LOG_PROPERTY_FILE
			echo log50=  >> $LOG_PROPERTY_FILE

			echo  >> $LOG_PROPERTY_FILE
			echo  >> $LOG_PROPERTY_FILE
			echo  >> $LOG_PROPERTY_FILE
			echo  >> $LOG_PROPERTY_FILE

			echo   >> $LOG_PROPERTY_FILE
			echo   >> $LOG_PROPERTY_FILE
			echo   >> $LOG_PROPERTY_FILE				
			echo PATTERN1=error  >> $LOG_PROPERTY_FILE
			echo MESSAGE_ON_PATTERN1=error#######error######error########error#######error######error#######error#######error >> $LOG_PROPERTY_FILE
			echo  >> $LOG_PROPERTY_FILE
			echo PATTERN2=Error  >> $LOG_PROPERTY_FILE
			echo MESSAGE_ON_PATTERN2=Error#######Error######Error########Error#######Error######Error#######Error#######Error >> $LOG_PROPERTY_FILE
			echo  >> $LOG_PROPERTY_FILE
			echo PATTERN3=ERROR  >> $LOG_PROPERTY_FILE
			echo MESSAGE_ON_PATTERN3=ERROR#######ERROR######ERROR########ERROR#######ERROR######ERROR#######ERROR#######ERROR >> $LOG_PROPERTY_FILE
                        echo >> $LOG_PROPERTY_FILE
                        echo >> $LOG_PROPERTY_FILE
                        echo >> $LOG_PROPERTY_FILE
                        echo >> $LOG_PROPERTY_FILE
                        echo >> $LOG_PROPERTY_FILE

			fi
}


if [ ! -e "$LOG_PROPERTY_FILE" ];then
create_log_properties_file
else
. log.properties
fi

if [ ! -e "$MAN_FILE" ];then
create_man_page
fi


if [ $# -lt $EXPECTED_ARGS ]
then
show_commands
create_log_properties_file
exit $E_BADARGS
fi
##################ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ

for ((i=0;i<=$#;i++));
do 

echo "$#" "$i" "${!i}"; 

if [ "${!i}" = -h ] && [ "$#" -lt 2 ];then
show_commands
h_count="$i"
H_INT="$i"
fi

if [ "${!i}" = --help ] && [ "$#" -lt 2 ];then
show_help
help_count="$i"
HELP_INT="$i"
fi

if [ "${!i}" = -d ];then
D_CHECK=true
D_INT="$i"

echo "D_Check"$D_CHECK
echo "D_INT"$D_INT
echo "D_Check"$D_CHECK

d_count="$i"
echo "d_count"$d_count
fi

if [ "${!i}" = -p ];then
P_CHECK=true
P_INT="$i"
fi

if [ "${!i}" = -t ];then
T_CHECK=true
T_INT="$i"
fi

if [ "${!i}" = -n ];then
N_CHECK=true
N_INT="$i"
fi

if [ "${!i}" = -f ];then
F_CHECK=true
F_INT="$i"
F_COUNT="$i"
fi

if [ "${!i}" = -fs ];then
FS_CHECK=true
FS_INT="$i"
FS_COUNT="$i"
fi

if [ "${!i}" = -a ];then
A_CHECK=true
A_INT="$i"
a_count="$i"
APPEND_LOG=true
fi

if [ "${!i}" = -z ];then
z_CHECK=true
Z_INT="$i"
z_count="$i"
LOG_FILE_NAME_WITH_TIMESTAMP=true
fi


done

## TIMESTAMP ONLY
if [ "$T_CHECK" = true ] && [ "$N_CHECK" = false ];then
	T_COUNT=$T_INT
((T_COUNT=T_COUNT+1))
	re='^[0-9]+$'
	if ! [[ ${!T_COUNT} =~ $re ]] ; then
	msg_show_once=true
	show_start
	echo Parameter after -t is expected to be Integer.
	echo Taking Default Timestamp : 5 min
	echo
	READ_METHOD=t
	METHOD=$READ_METHOD
	READ_COUNTER=5
	COUNTER=$READ_COUNTER

	else 
	READ_METHOD=t
	METHOD=$READ_METHOD
	READ_COUNTER=${!T_COUNT}
	COUNTER=$READ_COUNTER
	fi
	fi
## No of Lines ONLY
	if [ "$T_CHECK" = false ] && [ "$N_CHECK" = true ];then
	N_COUNT=$N_INT
((N_COUNT=N_COUNT+1))
	re='^[0-9]+$'
	if ! [[ ${!N_COUNT} =~ $re ]] ; then
	msg_show_once=true
	show_start
	echo Parameter after -n is expected to be Integer.
	echo Taking Default No. Of Lines : 50
	echo
	READ_METHOD=n
	METHOD=$READ_METHOD
	READ_COUNTER=50
	COUNTER=$READ_COUNTER

	else 
	READ_METHOD=n
	METHOD=$READ_METHOD
	READ_COUNTER=${!N_COUNT}
	COUNTER=$READ_COUNTER
	fi
	fi

	if [ "$T_CHECK" = true ] && [ "$N_CHECK" = true ];then

	show_commands
	exit
	fi

## Only Defalut
	if [ "$D_CHECK" = true ] && [ "$P_CHECK" = false ] && [ "$F_CHECK" = false ] && [ "$FS_CHECK" = false ];then
	READ_CONFIGURE_LOG=d
	CONFIGURE_LOG=$READ_CONFIGURE_LOG
	fi

## Only Path
	if [ "$D_CHECK" = false ] && [ "$P_CHECK" = true ] && [ "$F_CHECK" = false ] && [ "$FS_CHECK" = false ];then
	READ_CONFIGURE_LOG=p
	CONFIGURE_LOG=$READ_CONFIGURE_LOG

	fi

## No Modes
	if [ "$D_CHECK" = false ] && [ "$P_CHECK" = false ] && [ "$F_CHECK" = false ] && [ "$FS_CHECK" = false ];then
	READ_CONFIGURE_LOG=d
	CONFIGURE_LOG=$READ_CONFIGURE_LOG
	fi

## FOLDER MODES
	if [ "$D_CHECK" = false ] && [ "$P_CHECK" = false ]  && [ "$F_CHECK" = true ] && [ "$FS_CHECK" = false ];then
	READ_CONFIGURE_LOG=f
	CONFIGURE_LOG=$READ_CONFIGURE_LOG
	fi

## FOLDER & SUB-FOLDER MODES
	if [ "$D_CHECK" = false ] && [ "$P_CHECK" = false ]  && [ "$F_CHECK" = false ] && [ "$FS_CHECK" = true ];then
	READ_CONFIGURE_LOG=fs
	CONFIGURE_LOG=$READ_CONFIGURE_LOG
	fi

## ERROR MODES
	if [ "$D_CHECK" = true ] && [ "$P_CHECK" = true ]  && [ "$F_CHECK" = true ] && [ "$FS_CHECK" = false ];then
	echo Illegal Parameter Passing
	show_commands
	exit
	fi

## ERROR MODES
	if [ "$D_CHECK" = true ] && [ "$P_CHECK" = true ]  && [ "$F_CHECK" = false ] && [ "$FS_CHECK" = true ];then
	echo Illegal Parameter Passing
	show_commands
	exit
	fi

## ERROR MODES
	if [ "$D_CHECK" = true ] && [ "$P_CHECK" = true ]  && [ "$F_CHECK" = true ] && [ "$FS_CHECK" = true ];then
	echo Illegal Parameter Passing
	show_commands
	exit
	fi

## ERROR MODES
	if [ "$D_CHECK" = false ] && [ "$P_CHECK" = true ]  && [ "$F_CHECK" = true ] && [ "$FS_CHECK" = true ];then
	echo Illegal Parameter Passing
	show_commands
	exit
	fi

## ERROR MODES
	if [ "$D_CHECK" = false ] && [ "$P_CHECK" = false ]  && [ "$F_CHECK" = true ] && [ "$FS_CHECK" = true ];then
	echo Illegal Parameter Passing
	show_commands
	exit
	fi


## ERROR MODES
	if [ "$D_CHECK" = false ] && [ "$P_CHECK" = true ]  && [ "$F_CHECK" = false ] && [ "$FS_CHECK" = true ];then
	echo Illegal Parameter Passing
	show_commands
	exit
	fi


## ERROR MODES
	if [ "$D_CHECK" = false ] && [ "$P_CHECK" = true ]  && [ "$F_CHECK" = true ] && [ "$FS_CHECK" = false ];then
	echo Illegal Parameter Passing
	show_commands
	exit
	fi


## ERROR MODES
	if [ "$D_CHECK" = true ] && [ "$P_CHECK" = false ]  && [ "$F_CHECK" = false ] && [ "$FS_CHECK" = true ];then
	echo Illegal Parameter Passing
	show_commands
	exit
	fi

## ERROR MODES
	if [ "$D_CHECK" = false ] && [ "$P_CHECK" = true ]  && [ "$F_CHECK" = true ] && [ "$FS_CHECK" = false ];then

	echo Illegal Parameter Passing
	show_commands
	exit
	fi


	if [ "$CONFIGURE_LOG" = p ]; then
	P_COUNT=$P_INT
	D_COUNTER="$D_INT"
	P_COUNTER="$P_INT"
	T_COUNTER="$T_INT"
	N_COUNTER="$N_INT"
	F_COUNTER="$F_INT"
	FS_COUNTER="$FS_INT"
	a_conuter="$A_INT"
	H_COUNTER="$H_INT"

((P_COUNT=P_COUNT+1))
	LAST="$#"
((LAST=LAST+1))
	while [ "$P_COUNT" -ne "$D_COUNTER" ] && [ "$P_COUNT" -ne "$LAST" ] && [ "$P_COUNT" -ne "$T_COUNTER" ] && [ "$P_COUNT" -ne "$N_COUNTER" ] && [ "$P_COUNT" -ne "$F_COUNTER" ] && [ "$P_COUNT" -ne "$FS_COUNTER" ] && [ "$P_COUNT" -ne "$A_COUNTER" ] && [ "$P_COUNT" -ne "$Z_COUNTER" ] && [ "$P_COUNT" -ne "$H_COUNTER" ] 
	do
	i=1
	logfiles=( "${logfiles[@]}" "${!P_COUNT}" )

((P_COUNT=P_COUNT+1))
	done
	if [ -z "$logfiles" ]
	then

	show_at_illegal_arguments
	exit
	fi

	fi




	if [ "$CONFIGURE_LOG" = f ]; then
	F_COUNT=$F_INT
	D_COUNTER="$D_INT"
	P_COUNTER="$P_INT"
	T_COUNTER="$T_INT"
	N_COUNTER="$N_INT"
	F_COUNTER="$F_INT"
	FS_COUNTER="$FS_INT"
	a_conuter="$A_INT"
	Z_COUNTER="$Z_INT"
	H_COUNTER="$H_INT"

((F_COUNT=F_COUNT+1))
	LAST="$#"
((LAST=LAST+1))
	while [ "$F_COUNT" -ne "$D_COUNTER" ] && [ "$F_COUNT" -ne "$LAST" ] && [ "$F_COUNT" -ne "$T_COUNTER" ] && [ "$F_COUNT" -ne "$N_COUNTER" ] && [ "$F_COUNT" -ne "$P_COUNTER" ] && [ "$F_COUNT" -ne "$FS_COUNTER" ] && [ "$F_COUNT" -ne "$A_COUNTER" ] && [ "$F_COUNT" -ne "$Z_COUNTER" ] && [ "$F_COUNT" -ne "$H_COUNTER" ]
	do
	i=1
	logfiles=( "${logfiles[@]}" "${!F_COUNT}" )

((F_COUNT=F_COUNT+1))
	done

	if [ -z "$logfiles" ]
	then

	show_at_illegal_arguments
	exit
	fi

	fi



	if [ "$CONFIGURE_LOG" = fs ]; then
	FS_COUNT=$FS_INT
	D_COUNTER="$D_INT"
	P_COUNTER="$P_INT"
	T_COUNTER="$T_INT"
	N_COUNTER="$N_INT"
	F_COUNTER="$F_INT"
	FS_COUNTER="$FS_INT"
	a_conuter="$A_INT"
	Z_COUNTER="$Z_INT"
	H_COUNTER="$H_INT"

((FS_COUNT=FS_COUNT+1))
	LAST="$#"
((LAST=LAST+1))
	while [ "$FS_COUNT" -ne "$D_COUNTER" ] && [ "$FS_COUNT" -ne "$LAST" ] && [ "$FS_COUNT" -ne "$T_COUNTER" ] && [ "$FS_COUNT" -ne "$N_COUNTER" ] && [ "$FS_COUNT" -ne "$P_COUNTER" ] && [ "$FS_COUNT" -ne "$F_COUNTER" ] && [ "$FS_COUNT" -ne "$A_COUNTER" ] && [ "$FS_COUNT" -ne "$Z_COUNTER" ] && [ "$FS_COUNT" -ne "$H_COUNTER" ]
	do
	i=1
	logfiles=( "${logfiles[@]}" "${!FS_COUNT}" )

((FS_COUNT=FS_COUNT+1))
	done

	if [ -z "$logfiles" ]
	then

	show_at_illegal_arguments
	exit
	fi

	fi





	if [ "$F_CHECK" = true ] && [ "$N_CHECK" = true ];then

	READ_METHOD=fsn
	METHOD=$READ_METHOD

	N_COUNT=$N_INT
((N_COUNT=N_COUNT+1))
	READ_COUNTER=${!N_COUNT}
	COUNTER=$READ_COUNTER
	fi


	if [ "$F_CHECK" = true ] && [ "$T_CHECK" = true ];then
	READ_METHOD=fst
	METHOD=$READ_METHOD
	T_COUNT=$T_INT
((T_COUNT=T_COUNT+1))
	READ_COUNTER=${!T_COUNT}
	COUNTER=$READ_COUNTER
	fi


	if [ "$FS_CHECK" = true ] && [ "$N_CHECK" = true ];then
	READ_METHOD=fsn
	METHOD=$READ_METHOD
	T_COUNT=$T_INT
	N_COUNT=$N_INT
((N_COUNT=N_COUNT+1))
	READ_COUNTER=${!N_COUNT}
	COUNTER=$READ_COUNTER
	fi


	if [ "$FS_CHECK" = true ] && [ "$T_CHECK" = true ];then
	READ_METHOD=fst
	METHOD=$READ_METHOD
	T_COUNT=$T_INT
((T_COUNT=T_COUNT+1))
	READ_COUNTER=${!T_COUNT}
	COUNTER=$READ_COUNTER
	fi



	if [ "$LOG_FILE_NAME_WITH_TIMESTAMP" = true ];then
	FILE_TO_BE_WRITTEN=$FILE_NAME_WITH_DATE
	fi

	if [ "$LOG_FILE_NAME_WITH_TIMESTAMP" = false ];then
	FILE_TO_BE_WRITTEN=$FILE_NAME_WITHOUT_DATE
	fi




#--------------------------- Creating File -------------------------- Creating File -------------------------------------------

	DIRECTORY=$(pwd)
HOSTNAME=$(hostname)


	if [ "$METHOD" = t ] || [ "$METHOD" = n ] || [ "$METHOD" = fn ] || [ "$METHOD" = ft ] || [ "$METHOD" = fsn ] || [ "$METHOD" = fst ]; then

#	echo Inside METHOD  rishi 
	if [ ! -e "$FILE_TO_BE_WRITTEN" ]
	then
	if [ "$msg_show_once" = false ]
	then
	show_start
	fi
	log_initial_write
        log_file_created=true
	echo -------
	echo Creating New Log file : $DIRECTORY/$FILE_TO_BE_WRITTEN
	echo ------- 
	fi


	if [ -s "$FILE_TO_BE_WRITTEN" ] && [ "$APPEND_LOG" = true ] && [ "$log_file_created" = false ]
	then
	echo =================== Below Log is from Computer Name : $HOSTNAME =================== >> $FILE_TO_BE_WRITTEN
	echo =================== Log Generated Time : $PRESENT =================== >> $FILE_TO_BE_WRITTEN	
	if [ "$msg_show_once" = false ]
	then
	show_start
	fi
	echo -------
	echo Appending Previous Log file : $DIRECTORY/$FILE_TO_BE_WRITTEN
	echo ------- 
	fi
	if [ -s "$FILE_TO_BE_WRITTEN" ] && [ "$APPEND_LOG" = false ] && [ "$log_file_created" = false ]
	then  

	rm -rf $FILE_TO_BE_WRITTEN
	log_initial_write
	if [ "$msg_show_once" = false ]
	then
	show_start
	fi
	echo -------
	echo Creating New Log file : $DIRECTORY/$FILE_TO_BE_WRITTEN
	echo -------

	fi

	fi


#--------------------------- Creating File -------------------------- Creating File -------------------------------------------









######### LOG FILES ######### LOG FILES ######### LOG FILES ######### LOG FILES ######### LOG FILES ######## LOG FILES ######## LOG FILES #####

# --------[DEFAULT]-------[DEFAULT]------------ Update your parameters below below this line --------[DEFAULT]-------[DEFAULT]------------
	if [ "$CONFIGURE_LOG" = d ];then

	declare -a logfiles=("$log1" "$log2" "$log3" "$log4" "$log5" "$log6" "$log7" "$log8" "$log9" "$log10" "$log11" "$log12" "$log13" "$log14" "$log15" "$log16" "$log17" "$log18" "$log19" "$log20" "$log21" "$log22" "$log23" "$log24" "$log25" "$log26" "$log27" "$log28" "$log29" "$log30" "$log31" "$log32" "$log33" "$log34" "$log35" "$log36" "$log37" "$log38" "$log39" "$log40" "$log41" "$log42" "$log43" "$log44" "$log45" "$log46" "$log47" "$log48" "$log49" "$log50")


	fi
# --------[DEFAULT]-------[DEFAULT]------------ Update your parameters above below this line --------[DEFAULT]-------[DEFAULT]------------

######### LOG FILES ######### LOG FILES ######### LOG FILES ######### LOG FILES ######### LOG FILES ######## LOG FILES ######## LOG FILES #####









############# METHOD : No OF LINE [STARTS] ########### METHOD : No OF LINE [STARTS] ########### METHOD : No OF LINE [STARTS] ############### 

	if [ "$METHOD" = n ];then
	N_COUNT=$N_INT
        echo "N_COUNT"$N_COUNT
((N_COUNT=N_COUNT+1))
	re='^[0-9]+$'
	if ! [[ ${!N_COUNT} =~ $re ]] ; then
	READ_COUNTER=50
        echo "inside n if not valid counter"
	COUNTER=$READ_COUNTER
	fi
        echo "READ_COUNTER"$READ_COUNTER
	numberoflines=$COUNTER
        echo "numberoflines"$numberoflines
	echo inside N

	for i in "${logfiles[@]}"
          
	do
        echo $i
	if [ -e "$i" ]; then
        echo inside $i
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo -------------------------------- "$i" ------------------------------------>> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo "$i"

       
	tail -n $numberoflines "$i" | while read line ; do
	echo "$line" >> $FILE_TO_BE_WRITTEN

	echo "$line" | grep -i "$PATTERN1"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN1" >> $FILE_TO_BE_WRITTEN

	fi
	echo "$line" | grep -i "$PATTERN2"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN2" >> $FILE_TO_BE_WRITTEN

	fi
	echo "$line" | grep -i "$PATTERN3"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN3" >> $FILE_TO_BE_WRITTEN

	fi
	done
	fi
	done
	fi

############# METHOD : No OF LINE [ENDS] ########### METHOD : No OF LINE [ENDS] ########### METHOD : No OF LINE [ENDS] ###############







######### METHOD : TIMESTAMP ########### METHOD : TIMESTAMP ########### METHOD : TIMESTAMP ########### METHOD : TIMESTAMP ###########
	if [ "$METHOD" = t ];then
	CHECK=false
	T_COUNT=$T_INT
((T_COUNT=T_COUNT+1))
	re='^[0-9]+$'
	if ! [[ ${!T_COUNT} =~ $re ]] ; then
	READ_COUNTER=5
	COUNTER=$READ_COUNTER
	fi
	TIME=$COUNTER

	DIRECTORY=$(pwd)
HOSTNAME=$(hostname)

	echo ----- Computer Name : $HOSTNAME ------

	CURRENT_TIME=$(date +'%Y-%m-%d %H:%M')
	REVISED_TIME=$(date -d "$TIME min ago" +'%Y-%m-%d %H:%M')
	echo CURRENT TIME = $CURRENT_TIME
	echo REVISED_TIME = $REVISED_TIME

	for i in "${logfiles[@]}"
	do
	if [ -e "$i" ]; then
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo -------------------------------- "$i" ------------------------------------ >> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo File : "$i"


	CHECK=false
	TIME=$COUNTER
	while [ $TIME -gt -1 ] && [ "$CHECK" = false ] 
	do

	CHECK=true
	REVISED_TIME=$(date -d "$TIME min ago" +'%Y-%m-%d %H:%M')
	grep "$REVISED_TIME" -A 50000 -B 0 "$i" || CHECK=false
((TIME=TIME-1))    

	done

	grep "$REVISED_TIME" -A 50000 -B 0 "$i" | while read line ; do
	echo "$line" >> $FILE_TO_BE_WRITTEN
	echo "$line" | grep -i "$PATTERN1"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN1" >> $FILE_TO_BE_WRITTEN

	fi
	echo "$line" | grep -i "$PATTERN2"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN2" >> $FILE_TO_BE_WRITTEN

	fi
	echo "$line" | grep -i "$PATTERN3"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN3" >> $FILE_TO_BE_WRITTEN

	fi


	done
	fi
	done
	fi


######### METHOD : TIMESTAMP [ENDS] ########### METHOD : TIMESTAMP [ENDS] ########### METHOD : TIMESTAMP [ENDS] ###########TIMESTAMP #######






############# FOLDER-METHOD : No OF LINE [STARTS] ########### FOLDER-METHOD : No OF LINE [STARTS] ########### FOLDER-METHOD : No OF LINE [STARTS] ############### 

	if [ "$METHOD" = fn ];then
	N_COUNT=$N_INT
((N_COUNT=N_COUNT+1))
	re='^[0-9]+$'
	if ! [[ ${!N_COUNT} =~ $re ]] ; then
	READ_COUNTER=50
	COUNTER=$READ_COUNTER
	fi
	numberoflines=$COUNTER 
	for i in "${logfiles[@]}"

	do

	echo Inside DIRECTORY : "$i"
	cd $i

	for j in *.log
	do
	echo inside fo
	if [ -e "$j" ]; then
	echo "====" > $FILE_TO_BE_WRITTEN
	echo "====" > $FILE_TO_BE_WRITTEN
	echo "====" > $FILE_TO_BE_WRITTEN
	echo -------------------------------- "$j" ------------------------------------>> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo "$j"


	tail -n $numberoflines "$j" | while read line ; do
	echo "$line"
	echo "$line" >> $FILE_TO_BE_WRITTEN



	echo "$line" | grep -i "$PATTERN1"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN1" >> $FILE_TO_BE_WRITTEN

	fi
	echo "$line" | grep -i "$PATTERN2"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN2" >> $FILE_TO_BE_WRITTEN

	fi
	echo "$line" | grep -i "$PATTERN3"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN3" >> $FILE_TO_BE_WRITTEN
	fi


	done
	fi
	done
	done


	fi

#--------------------------------------------------------------------------------------------------------------------------------------

############# FOLDER-METHOD : No OF LINE [ENDS] ########### FOLDER-METHOD : No OF LINE [ENDS] ########### FOLDER-METHOD : No OF LINE [ENDS] ###############






######### FOLDER-METHOD : TIMESTAMP [START] ########### FOLDER-METHOD : TIMESTAMP [START] ########### FOLDER-METHOD : TIMESTAMP [START] ########### FOLDER-METHOD : TIMESTAMP [START] ###########


	if [ "$METHOD" = ft ];then
	CHECK=false


	T_COUNT=$T_INT
((T_COUNT=T_COUNT+1))
	re='^[0-9]+$'
	if ! [[ ${!T_COUNT} =~ $re ]] ; then
	READ_COUNTER=5
	COUNTER=$READ_COUNTER
	fi
	TIME=$COUNTER

	CURRENT_TIME=$(date +'%Y-%m-%d %H:%M')
	REVISED_TIME=$(date -d "$TIME min ago" +'%Y-%m-%d %H:%M')
	echo CURRENT TIME = $CURRENT_TIME
	echo REVISED_TIME = $REVISED_TIME


	DIRECTORY=$(pwd)
HOSTNAME=$(HOSTNAME)

	echo ----- Computer Name : $HOSTNAME ------

	CURRENT_TIME=$(date +'%Y-%m-%d %H:%M')
	REVISED_TIME=$(date -d "$TIME min ago" +'%Y-%m-%d %H:%M')
	echo CURRENT TIME = $CURRENT_TIME
	echo REVISED_TIME = $REVISED_TIME
	for i in "${logfiles[@]}"
	do
	echo Inside DIRECTORY : "$i"
	cd $i
	for j in *.log
	do
	if [ -e "$j" ]; then
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo -------------------------------- "$j" ------------------------------------ >> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo File : "$j"
	CHECK=false
	TIME=$COUNTER
	while [ $TIME -gt -1 ] && [ "$CHECK" = false ] 
	do
	CHECK=true
	REVISED_TIME=$(date -d "$TIME min ago" +'%Y-%m-%d %H:%M')
	grep "$REVISED_TIME" -A 50000 -B 0 "$j" || CHECK=false
((TIME=TIME-1))    
	done
	grep "$REVISED_TIME" -A 50000 -B 0 "$j" | while read line ; do

	echo "$line" >> $FILE_TO_BE_WRITTEN
	echo "$line" | grep -i "$PATTERN1"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN1" >> $FILE_TO_BE_WRITTEN

	fi
	echo "$line" | grep -i "$PATTERN2"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN2" >> $FILE_TO_BE_WRITTEN

	fi
	echo "$line" | grep -i "$PATTERN3"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN3" >> $FILE_TO_BE_WRITTEN
	fi
	done
	fi
	done

	done
	fi


######### METHOD : TIMESTAMP [ENDS] ########### METHOD : TIMESTAMP [ENDS] ########### METHOD : TIMESTAMP [ENDS] ###########TIMESTAMP #######




############# FOLDER-METHOD : No OF LINE [STARTS] ########### FOLDER-METHOD : No OF LINE [STARTS] ########### FOLDER-METHOD : No OF LINE [STARTS] ############### 

	if [ "$METHOD" = fsn ];then

	N_COUNT=$N_INT
((N_COUNT=N_COUNT+1))
	re='^[0-9]+$'
	if ! [[ ${!N_COUNT} =~ $re ]] ; then
	READ_COUNTER=50
	COUNTER=$READ_COUNTER
	fi
	numberoflines=$COUNTER 

	echo no of lines $numberoflines
	for i in "${logfiles[@]}"
	do
	echo Inside DIRECTORY : "$i"
allfilesinfolder=$(find $i -name \*.log)
	for j in $allfilesinfolder
	do
	if [ -e "$j" ]; then
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo -------------------------------- "$j" ------------------------------------>> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo "$j"

	tail -n $numberoflines "$j" | while read line ; do
	echo "$line" >> $FILE_TO_BE_WRITTEN

	echo "$line" | grep -i "$PATTERN1"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN1" >> $FILE_TO_BE_WRITTEN

	fi
	echo "$line" | grep -i "$PATTERN2"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN2" >> $FILE_TO_BE_WRITTEN

	fi
	echo "$line" | grep -i "$PATTERN3"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN3" >> $FILE_TO_BE_WRITTEN

	fi


	done
	fi
	done
	done
	fi

############# FOLDER-METHOD : No OF LINE [ENDS] ########### FOLDER-METHOD : No OF LINE [ENDS] ########### FOLDER-METHOD : No OF LINE [ENDS] ###############






######### FOLDER-METHOD : TIMESTAMP [START] ########### FOLDER-METHOD : TIMESTAMP [START] ########### FOLDER-METHOD : TIMESTAMP [START] ########### FOLDER-METHOD : TIMESTAMP [START] ###########


	if [ "$METHOD" = fst ];then
	CHECK=false


	T_COUNT=$T_INT
((T_COUNT=T_COUNT+1))
	re='^[0-9]+$'
	if ! [[ ${!T_COUNT} =~ $re ]] ; then
	READ_COUNTER=5
	COUNTER=$READ_COUNTER
	fi
	TIME=$COUNTER
	DIRECTORY=$(pwd)
HOSTNAME=$(hostname)

	CURRENT_TIME=$(date +'%Y-%m-%d %H:%M')
	REVISED_TIME=$(date -d "$TIME min ago" +'%Y-%m-%d %H:%M')
	echo CURRENT TIME = $CURRENT_TIME
	echo LOG_COLLECTION_TIME\(after\) = $REVISED_TIME
	echo
	for i in "${logfiles[@]}"
	do
	echo Inside DIRECTORY : "$i"
allfilesinfolder=$(find $i -name \*.log)
	for j in $allfilesinfolder
	do
	if [ -e "$j" ]; then
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo -------------------------------- "$j" ------------------------------------ >> $FILE_TO_BE_WRITTEN
	echo ==== >> $FILE_TO_BE_WRITTEN
	echo File : "$j"
	CHECK=false
	TIME=$COUNTER
	while [ $TIME -gt -1 ] && [ "$CHECK" = false ] 
	do
	CHECK=true
	REVISED_TIME=$(date -d "$TIME min ago" +'%Y-%m-%d %H:%M')
	grep "$REVISED_TIME" -A 50000 -B 0 "$j" || CHECK=false
((TIME=TIME-1))    
	done
	grep "$REVISED_TIME" -A 50000 -B 0 "$j" | while read line ; do

	echo "$line" >> $FILE_TO_BE_WRITTEN

	echo "$line" | grep -i "$PATTERN1"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN1" >> $FILE_TO_BE_WRITTEN

	fi
	echo "$line" | grep -i "$PATTERN2"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN2" >> $FILE_TO_BE_WRITTEN

	fi
	echo "$line" | grep -i "$PATTERN3"
	if [ $? = 0 ]; then
	echo "Found an error: $line"
	echo "$MESSAGE_ON_PATTERN3" >> $FILE_TO_BE_WRITTEN
	fi
	done
	fi
	done

	done
	fi


######### METHOD : TIMESTAMP [ENDS] ########### METHOD : TIMESTAMP [ENDS] ########### METHOD : TIMESTAMP [ENDS] ###########TIMESTAMP #######





	exit
