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
  echo HOSTNAME = $HOSTNAME

  # временная зона в виде: America/New_York UTC -5 
  # (временная зона, должна браться из системы и быть корректной для текущего местоположения)
  echo TIMEZONE = $TIMEZONE

  # текущий пользователь который запустил скрипт
  echo USER = $USER

  # тип и версия операционной системы
  echo OS = $OS

  # текущее время в виде: 12 May 2020 12:24:36
  echo DATE = $DATE

  # время работы системы
  echo UPTIME = $UPTIME

  # время работы системы в секундах
  echo UPTIME_SEC = $UPTIME_SEC

  # ip-адрес машины в любом из сетевых интерфейсов
  echo IP = $IP

  # сетевая маска любого из сетевых интерфейсов в виде: xxx.xxx.xxx.xxx
  echo MASK = $MASK

  # ip шлюза по умолчанию
  echo GATEWAY = $GATEWAY

  # размер оперативной памяти в Гб c точностью три знака после запятой в виде: 3.125 Gb
  echo RAM_TOTAL = $RAM_TOTAL

  # размер используемой памяти в Гб c точностью три знака после запятой
  echo RAM_USED = $RAM_USED

  # размер свободной памяти в Гб c точностью три знака после запятой
  echo RAM_FREE = $RAM_FREE

  # размер рутового раздела в Mб с точностью два знака после запятой в виде: 254.25 MB
  echo SPACE_ROOT = $SPACE_ROOT

  # размер занятого пространства рутового раздела в Mб с точностью два знака после запятой
  echo SPACE_ROOT_USED = $SPACE_ROOT_USED

  # размер рутового раздела в Mб с точностью два знака после запятой
  echo PACE_ROOT_FREE = $SPACE_ROOT_FREE
}
printall
echo -e "Do you want to write all this data to file?\nY\\N \n"
read ANSW

if [[ "y" = "$ANSW" || "Y" = "$ANSW" ]] ; then
printall > $FILENAME
fi

