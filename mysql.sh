#!/bin/bash

LOG_FOLDER="/var/log/expenses/"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y%m%d%H)
PID=$$
LOGFILE="$LOG_FOLDER/$SCRIPT_NAME_$PID_$TIMESTAMP.log"


USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
C="\e[36m"

CHECK_ROOT() {
    if [ $USERID -ne 0 ]; then
        echo -e "$R Please run this script with root user privilage $N " | tee -a $LOGFILE
        exit 1
    fi
}

VALIDATE() {
    if [ $1 -ne 0 ]; then
    echo -e "$2 is .... $R FAILED $N " | tee -a $LOGFILE
    exit 1
    else
    echo -e "$2 is .... $G SUCCESS $N " | tee -a $LOGFILE
    fi
}

echo -e "$C Script started executing at: $(date) $N" | tee -a $LOGFILE

CHECK_ROOT

dnf install mysql-server -y &>> $LOGFILE
VALIDATE $? "Installing MySQL server"

systemctl enable mysqld &>> $LOGFILE
VALIDATE $? "Enabling MySQL server"

systemctl start mysqld &>> $LOGFILE
VALIDATE $? "Starting MySQL server"

mysql -h mysql.laven.online -u root -pExpenseApp@1 -e 'show databases;' &>> $LOGFILE
if [ $? -ne 0 ]
then
echo "MySQL root password is not setup,  $Y setting now $N" &>>$LOGFILE
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "Setting UP root password"
else
    echo -e "MySQL root password is already setup...$Y SKIPPING $N" | tee -a $LOGFILE
fi

