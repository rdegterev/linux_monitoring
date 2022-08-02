case $1 in
    *[!0-9]|[!-0-9]*) echo $1 ;;
    *[0-9]*) echo "Number argument is not allowed" ;;
    *'') echo "No argument";;
esac
