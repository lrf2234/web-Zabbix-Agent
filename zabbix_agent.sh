#!/bin/bash

#################################################################################
###########         所需 软件包 提前放在 ~/zabbix/   下面            ############
#################################################################################
###########需要软件包如下，源码包                                    ############
###########     zabbix-3.4.4.tar.gz                                  ############
#################################################################################

######### 全局变量  #####################
server_host='192.168.1.5'
work_dir='/root/Zabbix'
zabbi_agnet_dir='/root/Zabbix/zabbix-3.4.4'

########## 安装 基本依赖包 ###############
install_base(){
    yum install gcc pcre-devel
}

######### 源码安装 zabbix_agent ##########
install_zabbix_agent(){
    useradd zabbix
    cd  ${work_dir}
    tar  -xf  zabbix-3.4.4.tar.gz  -C .
    cd  ${zabbi_agnet_dir}
    ./configure --enable-agent
    make install
}

####### 修改zabbix_agent 配置文件 ########
config_zabbix_agent(){
    sed -i "s/^Server=127.0.0.1/Server=127.0.0.1,${server_host}/" /usr/local/etc/zabbix_agentd.conf
    sed -i "s/^ServerActive=127.0.0.1/ServerActive=${server_host}:10051/" /usr/local/etc/zabbix_agentd.conf
}

###### 启动 zabbix_agent 服务 ##########
start_zabbix_agent(){
    netstat -ntulp | grep zabbix_agent
    if [ $? -ne 0 ];then
        killall -9 zabbix_agent
        zabbix_agent
    fi 
    netstat -ntulp | grep zabbix_agent
    if [ $? -ne 0 ];then
        echo -e '\033[35mzabbix_agent 启动成功\033[0m'
    else 
        echo -e '\033[32mzabbix_agent 启动失败\033[0m'
    fi
}

install_base
install_zabbix_agent
config_zabbix_agent
start_zabbix_agent



