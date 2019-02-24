output() {
    printf "\E[0;33;40m"
    echo $1
    printf "\E[0m"
}

displayErr() {
    echo
    echo $1;
    echo
    exit 1;
}
# Installing Yiimp
    output " "
    output " Installing Yiimp"
    output " "
    output "Grabbing yiimp fron Github, building files and setting file structure."
    output " "
    sleep 3
    
    
    # Generating Random Password for stratum
    blckntifypass=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    
    # Compile Blocknotify
    cd ~
    rm -r yiimp
    git clone https://github.com/tpruvot/yiimp.git
    cd $HOME/yiimp/blocknotify
    sudo sed -i 's/tu8tu5/'$blckntifypass'/' blocknotify.cpp
    sudo make
    
    # Compile iniparser
    cd $HOME/yiimp/stratum/iniparser
    sudo make
    
    # Compile Stratum
    cd $HOME/yiimp/stratum
    if [[ ("$BTC" == "y" || "$BTC" == "Y") ]]; then
    sudo sed -i 's/CFLAGS += -DNO_EXCHANGE/#CFLAGS += -DNO_EXCHANGE/' $HOME/yiimp/stratum/Makefile
    sudo make
    fi
    sudo make
    
    # Remove old files and copy Files (Blocknotify,iniparser,Stratum)
    cd $HOME/yiimp
    sudo sed -i 's/AdminRights/'$admin_panel'/' $HOME/yiimp/web/yaamp/modules/site/SiteController.php
    yes | sudo cp -r $HOME/yiimp/web /var/
    cd $HOME/yiimp/stratum
    yes | sudo cp -a config.sample/. /var/stratum/config
    yes | sudo cp -r stratum /var/stratum
    yes | sudo cp -r run.sh /var/stratum
    cd $HOME/yiimp
    yes | sudo cp -r $HOME/yiimp/bin/. /bin/
    yes | sudo cp -r $HOME/yiimp/blocknotify/blocknotify /usr/bin/
    yes | sudo cp -r $HOME/yiimp/blocknotify/blocknotify /var/stratum/
    sudo mkdir -p /etc/yiimp
    sudo mkdir -p /$HOME/backup/
    #fixing yiimp
    sed -i "s|ROOTDIR=/data/yiimp|ROOTDIR=/var|g" /bin/yiimp
    #fixing run.sh
    sudo rm -r /var/stratum/config/run.sh
    echo '
#!/bin/bash
ulimit -n 10240
ulimit -u 10240
cd /var/stratum
while true; do
./stratum /var/stratum/config/$1
sleep 2
done
exec bash
' | sudo -E tee /var/stratum/config/run.sh >/dev/null 2>&1
    sudo chmod +x /var/stratum/config/run.sh


    # Update Timezone
    output " "
    output "Update default timezone."
    output " "
    
    # Check if link file
    sudo [ -L /etc/localtime ] &&  sudo unlink /etc/localtime
    
    # Update time zone
    sudo ln -sf /usr/share/zoneinfo/$TIME /etc/localtime
    sudo aptitude -y install ntpdate
    
    # Write time to clock.
    sudo hwclock -w
