case $1 in
    *[2-4]*) RAM_TOTAL_MB="$(free -m | awk -v i=$1 'NR == 2{print $i}')"
             awk "BEGIN {printf \"%.3f Gb\",${RAM_TOTAL_MB}/1024}" ;;
    *'') echo "Bad argument";;
esac
