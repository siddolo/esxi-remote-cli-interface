#!/bin/bash
#
# VMware ESXi remote CLI interface
# Author: Pasquale 'sid' Fiorillo

args=("$@")
HOST=${args[0]}
COMMAND=${args[1]}


function usage {
	echo -e "$0 hostname {ls|running|stop|start|status} [vmid]\n"
	echo -e "Commands:"
	echo -e "\t ls\t\tGet all VMs"
	echo -e "\t running\tGet all running VMs"
	echo -e "\t stop\t\tPower off VM"
	echo -e "\t start\t\tPower on VM"
	echo -e "\t status\t\tGet VM status\n"
	echo -e "Example:"
	echo -e "\t$0 vmware.domain.local ls"
	echo -e "\t$0 vmware.domain.local status"
	echo -e "\t$0 vmware.domain.local status 3"
}

function ask_vmid {
		if [ ${args[2]} ]; then
			VMID=${args[2]}
		else
			echo -e "\e[0;32mPlease select VMID to perform action: \e[0m"
			read VMID
			echo -e "\e[0;32mPlease wait...\e[0m"
		fi
}

function confirm {
	read -p "Are you sure? (Y/n) " RESP
	if [ "$RESP" != "Y" ]; then
		exit 0;
	fi
}


if [ "$#" -lt 2 ]; then
	usage
	exit 1
fi

case $COMMAND in
	ls)
		echo -e "\e[0;32mGetting all vms...\e[0m"
		ssh $1 "vim-cmd vmsvc/getallvms"
		;;

	running)
		echo -e "\e[0;32mGetting all running vms...\e[0m"
		ssh $1 "esxcli vm process list"
		;;

	stop)
		$0 $1 ls
		ask_vmid
		confirm
		ssh $1 "vim-cmd vmsvc/power.shutdown $VMID"
		;;

	start)
		$0 $1 ls
		ask_vmid
		confirm
		ssh $1 "vim-cmd  vmsvc/power.on $VMID"
		;;

	status)
		$0 $1 ls
		ask_vmid
		ssh $1 "vim-cmd vmsvc/power.getstate $VMID"
		ssh $1 "vim-cmd vmsvc/get.summary $VMID" | egrep 'guestFullName|uptimeSeconds|maxCpuUsage|maxMemoryUsage|memorySizeMB|numCpu|numEthernetCards|numVirtualDisks|committed|uncommitted|unshared|overallCpuUsage|overallCpuDemand|guestMemoryUsage|hostMemoryUsage|privateMemory|sharedMemory|swappedMemory|balloonedMemory|consumedOverheadMemory'
		;;

	uptime)
		$0 $1 ls
		ask_vmid
		ssh $1 "vim-cmd vmsvc/get.summary $VMID |grep uptimeSeconds"
		;;

	*)
		usage
		;;
esac
