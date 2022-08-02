TIME_START="$(cat /proc/uptime | awk '{print $1}')"
if ! [[ $# -eq 1 ]]
    then 
        echo "Please run script with only one argument"
        exit 0
    elif ! [[ $1 =~ /$ ]]
    then 
        echo "Please run script with correct argument - path to folder must ends with '/' symbol"
        exit 0
    elif ! [[ -d $1 ]]
    then
        echo "No such directory"
        exit 0
fi
###########
echo "Total number of folders (including all nested ones) = $(( find $1 -type d | wc -l) )"

###########
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
TOP5FOLDERS_N=( $(du -h $1 | sort -rh | head -5 | awk '{print $2}') )
TOP5FOLDERS_S=( $(du -h $1 | sort -rh | head -5 | awk '{print $1}') )
NUM=0

for (( i=0; i<${#TOP5FOLDERS_N[@]}; i++ ))
do
  echo -e "$((i+1)) - ${TOP5FOLDERS_N[i]}, ${TOP5FOLDERS_S[i]}b"
done

###########
echo "Total number of files = $(ls $1 | wc -l)"

function count_files {
  local PATH_TO_DIR=$1
  shift
  local EXTENTIONS=("${@}")
  local COUNT=0
  for file in "${EXTENTIONS[@]}"
  do
    let COUNT="$(find $PATH_TO_DIR -name $file | wc -l)+$COUNT"
  done
  echo "$COUNT"
}

CONF_FILES=('*.conf' '*.ext')
TEXT_FILES=('*.txt')
LOG_FILES=('*.log')
ARCH_FILES=('*.tar' '*.zip' '*.7z' '*.rar' '*.gz')
echo "Configuration files (with the .conf extension) = $(count_files $1 ${CONF_FILES[*]})"
echo "Text files = $(count_files $1 ${TEXT_FILES[*]})"
echo "Executable files = $(ls $1 -F -1 | grep * | wc -l)"
echo "Archive files = $(count_files $1 ${ARCH_FILES[*]})"
echo "Symbolic links = $(ls $1 -F -1 | grep @ | wc -l)"

###########
TOP10FILES=( $(find $1 -xdev -type f -exec du -sh {} ';' | sort -rh | head -10 | awk '{print $2}') )
TOP10EXEFILES=( $(find $1 -xdev -type f -executable -exec du -sh {} ';' | sort -rh | head -10 | awk '{print $2}') )
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
NUM=0
for fullpath in "${TOP10FILES[@]}"
do
  ((NUM++))
  filename="${fullpath##*/}"
  base="${filename%.[^.]*}"
  ext="${filename:${#base} + 1}"
  size="$(du -h "$fullpath" | cut -f1)"
  if [[ -z "$base" && -n "$ext" ]]; then
    base=".$ext"
    ext=""
  fi
  echo -e "$NUM - $fullpath, ${size}b,\t$ext"
done
echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file)"
NUM=0
for fullpath in "${TOP10EXEFILES[@]}"
do
  ((NUM++))
  size="$(du -h "$fullpath" | cut -f1)"
  MD5="$(md5sum "$fullpath" | awk '{print $1}')"
  echo -e "$NUM - $fullpath, ${size}b,\t$MD5"
done
TIME_END="$(cat /proc/uptime | awk '{print$1}')"
awk "BEGIN {printf \"Script execution time (in seconds) = %.2f\n\",${TIME_END}-${TIME_START}}"
