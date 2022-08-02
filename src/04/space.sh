case $1 in
    *[2-4]*) SPACE_ROOT_KB="$(df -k / | awk -v i=$1 'NR == 2{print $i}')"
             awk "BEGIN {printf \"%.2f Mb\",${SPACE_ROOT_KB}/1024}" ;;
    *'') echo "Bad argument";;
esac
