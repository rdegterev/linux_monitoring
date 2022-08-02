OS="$(cat /etc/*-release | grep PRETTY | cut -d = -f 2)"
TIMEZONE="$(sh timezone.sh)"
DATE="$(date)"
UPTIME="$(uptime -p)"
UPTIME_SEC="$(cat /proc/uptime | awk '{print $1}')"
IPM="$(ip address show | grep "inet " | awk 'NR == 2{print $2}')"
IP="$( echo $IPM | cut -d / -f 1)"
PREFMASK="$( echo $IPM | cut -d / -f 2)"
MASK="$(ipcalc $PREFMASK | awk 'NR == 2{print $2}')"
GATEWAY="$(ip ro | awk 'NR == 1{print $3}')"

RAM_TOTAL=$(sh ram.sh 2)
RAM_USED=$(sh ram.sh 3)
RAM_FREE=$(sh ram.sh 4)

SPACE_ROOT=$(sh space.sh 2)
SPACE_ROOT_USED=$(sh space.sh 3)
SPACE_ROOT_FREE=$(sh space.sh 4)

FILENAME="$(date +"%d_%m_%y_%H_%M_%S").status"


printall() {
  # сетевое имя
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}HOSTNAME${TEXT_COLOR[0]}"\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$HOSTNAME${TEXT_COLOR[0]}

  # временная зона в виде: America/New_York UTC -5 
  # (временная зона, должна браться из системы и быть корректной для текущего местоположения)
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}TIMEZONE${TEXT_COLOR[0]}"\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$TIMEZONE${TEXT_COLOR[0]}

  # текущий пользователь который запустил скрипт
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}USER${TEXT_COLOR[0]}"\t\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$USER${TEXT_COLOR[0]}

  # тип и версия операционной системы
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}OS${TEXT_COLOR[0]}"\t\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$OS${TEXT_COLOR[0]}

  # текущее время в виде: 12 May 2020 12:24:36
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}DATE${TEXT_COLOR[0]}"\t\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$DATE${TEXT_COLOR[0]}

  # время работы системы
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}UPTIME${TEXT_COLOR[0]}"\t\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$UPTIME${TEXT_COLOR[0]}

  # время работы системы в секундах
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}UPTIME_SEC${TEXT_COLOR[0]}"\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$UPTIME_SEC${TEXT_COLOR[0]}

  # ip-адрес машины в любом из сетевых интерфейсов
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}IP${TEXT_COLOR[0]}"\t\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$IP${TEXT_COLOR[0]}

  # сетевая маска любого из сетевых интерфейсов в виде: xxx.xxx.xxx.xxx
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}MASK${TEXT_COLOR[0]}"\t\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$MASK${TEXT_COLOR[0]}

  # ip шлюза по умолчанию
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}GATEWAY${TEXT_COLOR[0]}"\t\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$GATEWAY${TEXT_COLOR[0]}

  # размер оперативной памяти в Гб c точностью три знака после запятой в виде: 3.125 Gb
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}RAM_TOTAL${TEXT_COLOR[0]}"\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$RAM_TOTAL${TEXT_COLOR[0]}

  # размер используемой памяти в Гб c точностью три знака после запятой
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}RAM_USED${TEXT_COLOR[0]}"\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$RAM_USED${TEXT_COLOR[0]}

  # размер свободной памяти в Гб c точностью три знака после запятой
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}RAM_FREE${TEXT_COLOR[0]}"\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$RAM_FREE${TEXT_COLOR[0]}

  # размер рутового раздела в Mб с точностью два знака после запятой в виде: 254.25 MB
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}SPACE_ROOT${TEXT_COLOR[0]}"\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$SPACE_ROOT${TEXT_COLOR[0]}

  # размер занятого пространства рутового раздела в Mб с точностью два знака после запятой
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}SPACE_ROOT_USED${TEXT_COLOR[0]}"\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$SPACE_ROOT_USED${TEXT_COLOR[0]}

  # размер рутового раздела в Mб с точностью два знака после запятой
  echo -e ${TEXT_COLOR[$1]}${BG_COLOR[$2]}PACE_ROOT_FREE${TEXT_COLOR[0]}"\t= "${TEXT_COLOR[$3]}${BG_COLOR[$4]}$SPACE_ROOT_FREE${TEXT_COLOR[0]}
}

TEXT_COLOR=('\033[0m' '\033[37m' '\033[31m' '\033[32m' '\033[34m' '\033[35m' '\033[30m')
BG_COLOR=('\033[0m' '\033[47m' '\033[41m' '\033[42m' '\033[44m' '\033[45m' '\033[40m')


case $1+$2+$3+$4 in
  [1-6]+[1-6]+[1-6]+[1-6]) 
      if [[ $1 != $2 ]] && [[ $3 != $4 ]]
        then
            printall $2 $1 $4 $3
        else
            echo "Colors of text and backgound shuld be different"
      fi;;
  *) echo "Bad argument"
      echo "Обозначения цветов: (1 - white, 2 - red, 3 - green, 4 - blue, 5 – purple, 6 - black)"
      echo "Параметр 1 - это фон названий значений (HOSTNAME, TIMEZONE, USER и т.д.)"
      echo "Параметр 2 - это цвет шрифта названий значений (HOSTNAME, TIMEZONE, USER и т.д.)"
      echo "Параметр 3 - это фон значений (после знака '=')"
      echo "Параметр 4 - это цвет шрифта значений (после знака '=')"
  ;;
esac



