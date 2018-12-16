#!/bin/bash
now=$(date)
PROGNAME=$(basename $0)
AUTHOR="A.Fontana"
VERSION="1.0.0"
OWNER="(c) by Net2Action  - 2016"

if [ -z "$logFile" ]; then
   mkdir -p ../log
   log=../log/$(echo $PROGNAME | cut -d "." -f 1)
   logFile=$log.log
fi



function error_exit
{
        echo "${PROGNAME}:[$LINENO] ${1}"
        echo "[$now] ${PROGNAME}:[$LINENO] ${1}" >> ${logFile}
        msgLine "---------------------------------------"
        echo "BUILD FAIL"
        exit 1
}

function msgLine
{
        echo "${PROGNAME}:[$LINENO] ${1}" 1>&2
        echo "[$now] ${PROGNAME}:[$LINENO] ${1}" >> ${logFile}
}

function usage
{
  echo "*----------------------------------------------------------------------------------"
  echo "| ${OWNER}"
  echo "| Author : ${AUTHOR}"
  echo "| Program : ${PROGNAME} ${VERSION}"
  echo "| ========================== "
  echo "| ${PROGNAME}  [-b backupPath] -g [oraDba]"
  echo "|"
  echo "| backupPath : Path where will be put backup images, default is /backup/oraDump"
  echo "| oraDba : a :Oracle dba owner group, default is dba"
  echo "|"
  echo "*----------------------------------------------------------------------------------"
}

msgLine "Preset environment for DB2 begin at $(date)"

bckPath=/backup/oraDump
oraDba=dba

# Parse the command-line arguments
while [ "$#" -gt "0" ]; do
  case "$1" in
    -b)
      bckPath="$2"
      shift 2
    ;;
	-g)
      oraDba="$2"
      shift 2
    ;;
    -?|--help)
      usage
    exit 0
    ;;
    *)
      break
    ;;
  esac
done




chmod 775 ${bckPath}
chown  ${oraDba} ${bckPath}


#Setting fileopen etc etc
limits=/etc/security/limits.conf
echo "# ----------------------------------------------" >> $limits
echo "#  Added by Oracle Setup script " >> $limits
echo "* - nofile 65536" >> $limits
echo "* - nproc 16384" >> $limits




msgLine "---------------------------------------"
msgLine "BUILD SUCESSS"
msgLine "End: $(date)"

exit 0
