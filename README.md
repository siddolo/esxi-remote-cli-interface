# esxi-remote-cli-interface
VMware ESXi remote CLI interface

        ./vmware.sh hostname {ls|running|stop|start|status} [vmid]

        Commands:
        	ls		Get all VMs
        	running		Get all running VMs
        	stop		Power off VM
        	start		Power on VM
        	status		Get VM status
        	
 	Example:
        	./vmware.sh vmware.domain.local ls
        	./vmware.sh vmware.domain.local status
        	./vmware.sh vmware.domain.local status 3
