#  GOGO APP INSTALLATION INSTRUCTIONS


    

## 1. INTRODUCTION


    

### 1.1. Purpose of this document
The purpose of this documennt is to provide a quick start for developing the basic-scala-console-app application. 

    

### 1.2. Skills requirements
Linux , bash , Windows Server , remoting , basic networking

    

### 1.3. Desired target setup
The desired target setup is to have a virtual machine running perl  mojolicous web framework and the custom developed basic-scala-console-app and basic-scala-console-app_ui projects fetching data from a local mysql db and local file system. 

    

### 1.4. Passwords management
Do use a personal passord managemenet dedicated program - a clear text cheat sheet is not that. Futurice centric password management is done via the dedicated web app:
https://password.futurice.com/

    

### 1.5. Additional information resources


    

### 1.6. Installation of the Windows host
In this setup a Windows OS running laptop acts as a host for running Linux guests. 

    

#### 1.6.1. Install Microsoft Office - optional. 
Install Microsoft Office for viewing and editing Microsoft centric file formats. 

    

#### 1.6.2. Install pdf reader
Install pdf reader to be able to read this guide / other documents in pdf format. 

    

#### 1.6.3. Install a Password Manager application
Install a Password Manager application - in this setup we use PasswordSafe:
https://pwsafe.org/


    

#### 1.6.4. install cygwin64 bit
Install the cygwin 64-bit from the following url:
https://cygwin.com/install.html
The cygwin run-time is used as the run-time for the ssh client as well as for runnnig some of the bash scripts, but as a whole you could install ja use any ssh client ( for example putty ) ja other text editors such as vim.
Download the cygwin64 setup exe into the following dir:
C:\var\hosts\< < your-win-host-name > >\bin

     

#### 1.6.5. Configure your Windows Path
Press Start , type Advanced System Settings, Environmental Variables , System Variables , Path 

    :: add the path where the VirtualBox.exe will be situated
    C:\Program Files\Oracle\VirtualBox
    
    :: add also the following dir to your Windows path
    C:\var\hosts\< < your-win-host-name > >\bin

#### 1.6.6. Install additional cygwin binaries
Install the following cygwin binaries. Start , Run , type:

    :: copy the setup-x86_64 into a dir of your Windows path
    setup-x86_64.exe -q -s http://cygwin.mirror.constant.com -P "inetutils,wget,open-ssh,curl,grep,egrep,git,vim,zip,unzip"

### 1.7. Oracle Virtual Box installation and provisioning
Install and configure the Oracle Virtual Host. 

    

#### 1.7.1. download ja install the Oracle Virtual Box
download the Oracle Virtual Box from here:
https://www.virtualbox.org/wiki/downloads. 
install with default settings

    :: create the dir for the setup files , Start , Run , type cmd , paste
    mkdir C:\var\pckgs\oracle\virtual-box

#### 1.7.2. 64-bit virtualization support in BIOS
Change the BIOS settings to support 64-bit virtualization. 

    :: check your Windows System info
    :: Start - Run , type cmd
    msinfo32
    
    :: check and google for your model for example
    google Lenovo 80MK get to BIOS

#### 1.7.3. download ja install the Oracle VM VirtualBox Extension Pack
Download the Oracle VM VirtualBox Extension Pack:
https://www.virtualbox.org/wiki/downloads. 
Install with default settings. 

    

#### 1.7.4. Provision the vm 
In the Oracle Virtual Box from the menu - File - New. 
For name of the virtual machiine: proj_host
This will be the one to refer to the vm via the VirtualBox command line.
For Type: choose Linux
For Version: type Ubuntu 64-bit
Click next , choose the amount of RAM depending on how-much you have on yor physical laptop. 
Choose "create virtual hard disk now".
For hard disk file type , choose vmdk.
For storage of physically hard disk , choose dynamically allocated. 
For the size of the virtual hard disk type 25GB.
Cick ok.  


    

#### 1.7.5. download and install Ubuntu Xenial as the OS for the vim
Download the Ubuntu 16.04. Xenial iso image file. Save into the dir belllow. Shift + F10 , a to store the path of the iso image file 

In the VirtualBox UI , right click the newly created vm , choose Start , Normal Start , you will be asked for a media to boot from for first time.

In the VirtualBox UI , View , Scaled mode. Start following the Ubuntu installation instructions.

In this mode the Oracle VirtualBox captures the whole input , the default is Right Control to "uncapture" the input from your keyboard to your windows host. 

In the Linux setup wizard , choose English. 
Choose install Ubuntu Server
For the installation process language choose English.
For location choose Finland.
For locale choose US_us.UTF8
Follow the keyboard instructions to detect your keyboard layout.
For host name type: proj-host ( this could be changed later ) 
For full name of the user type: Project Application User
For "username of your account type" : appuser
For "password" type : 
This is a good moment to store the user name and the password into your password manager application. 

For "encrypt your home dir " choose "Yes"
For "time-zone" choose Helsinki Europe.
For "partition disk" use "guided - use the whole disk
Accept erasing of data , cick Enter twice.
Do not choose automatic updates
Software packages : choose only standard system utilities
Choose to install boot loader.




    :: create the dir for the iso image file
    mkdir C:\var\pckgs\gnu\Ubuntu
    

##### 1.7.5.1. configure network settings
The desired setup for the network settings is to have multiple gues machines on the host machine. 
All of the gueest machines should be able to access the Internet. 

    
    No LSB modules are available.
    Distributor ID: Ubuntu
    Description:    Ubuntu 16.04 LTS
    Release:        16.04
    Codename:       xenial

##### 1.7.5.2. add the Host-only-Adapter
The Linux guest should be stopped in order to be able to add a new Adapter for it. 
Add a new Adapter by :
Open the Oracle Virtual Box.
Select the guest , Ctrl + S to open its settings.
Network.
Select the check box on the Adapter 2
Attached to: Host-only Adapter

Name: Virtual Box host only adapter

Advanced:
Promiscious mode: Allow All

Check: cable connnected.

    :: after installation check on Windows
    VBoxManage showvminfo proj_host | less

##### 1.7.5.3. configure "bridged mode" for Adapter1
The Linux guest should be stopped in order to be able to add a new Adapter for it. 
Add a new Adapter by :
Open the Oracle Virtual Box.
Select the guest , Ctrl + S to open its settings.
Network.
Select the check box on the Adapter 2
Attached to: Host-only Adapter

Name: Virtual Box host only adapter

Advanced:
Promiscious mode: Allow All

Check: cable connnected.

    

##### 1.7.5.4. Configure port forwarding
Configure the port forwarding between the guest and the host. 

    VBoxManage modifyvm "proj_host" --natpf1 "9000,tcp,,9000,,9000"
    

### 1.8. Linux OS initial configurations and installations
This section contains instructions on how-to perform some basic OS level configurations ja installations

    :: to start the vm from the command line:
    :: Start , Run , type : 
    VBoxManage startvm "proj_host" --type headless

#### 1.8.1. Go to the Linux UI via the host
After the installation has finnished ja the guest has been shutdown, open the Virtual Box UI, select the guest machine , right click , Start , Normal Start. 
In the Linux guest windows , Start the Terminal type the ifconfig command.

You should see the ip address to ssh to from the cygwin terminal - something like 192.168.56.101.

    ifconfig | less
    
    # install the ssh utils
    sudo apt-get install ssh 
    
    
    

#### 1.8.2. Go to the linux ui via the shell:
Open the cygwin terminal. Run the commands bellow

    # this is the ip address you got above
    ssh appuser@192.168.1.182

#### 1.8.3. Enable passwordless access to the Linux guest
Open the Windows cygwin terminal.

    # START === how-to implement public private key ( pkk ) authentication 
    # create pub private keys on the client
    # START copy 
    ssh-keygen -t rsa
    # Hit enter twice 
    # copy the rsa pub key to the ssh server
    scp ~/.ssh/id_rsa.pub  $ssh_user@$ssh_server:/home/$ssh_user/
    # STOP copy
    # now go on the server
    ssh $ssh_user@$ssh_server
    
    # START copy 
    # set a nice prompt
    export PS1="\h [\d \t] [\w] $ \n\n  "
    # run this only for first time ssh-keygen -t rsa
    cat id_rsa.pub >> ~/.ssh/authorized_keys
    cat ~/.ssh/authorized_keys
    chmod -v 0700 ~/.ssh
    chmod -v 0600 ~/.ssh/authorized_keys
    chmod -v 0600 ~/.ssh/id_rsa
    chmod -v 0644 ~/.ssh/id_rsa.pub
    find ~/.ssh -exec stat -c "%U:%G %a %n" {} \;
    exit
    # and verify that you can go on the server without having to type a pass
    ssh $ssh_user@$ssh_server
    # remove this file ONLY if you got the passwordlesss login to work 
    rm -fv ~/id_rsa.pub
    # STOP COPY

#### 1.8.4. Access to the Linux virtual machine
You would have to know the IP address of your Linux guest in order to be abble to ssh to it. 
Once the VirtualBox starts the UI of a guest in a separate window it "captures" your keyboard input - e.g. Alt + Tab to switch into another winows in your host OS will naturally evoke the Alt + Tab on the Guest machine ja it will switch the windws on the Guest machine. 
Thus , if you want to switch between the Windows on the host out of the Guest UI you would have to press the "host key" which is usually the RIGHT CTRL key on your keyboard ja than to uncapture the keyboard input ja after that the Alt + Tab would switch the windows on your host machine. 
Thus if you pin the VirtualBox on the taskbar you will be able to access your guest machines by WinLog + <<Number>> ja get out of the Linux UI by Right Ctrl , Alt + Tab. 

     :: to start the vm without ui 
    VBoxManage startvm "lp_host_name" --type headless
    
    :: to start the vm with ui
    VBoxManage startvm "lp_host_name"
    
    :: to save the state of the vm
    VBoxManage controlvm lp_host_name  savestate
    
    :: to shutdown the vm
    VBoxManage controlvm lp_host_name  poweroff

#### 1.8.5. add the Ubuntu GK user to the  sudoers group
To avoid the typing of passwords all the time. 

    cp -v /etc/sudoers /etc/sudoers.`date +%Y%m%d_%H%M%S`
    
    sudo echo '# ui_user does not want to type passwords with sudo >> /etc/sudoers
    sudo echo 'ui_user  ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
    

### 1.9. Network settings of the Linux guest
Check the /etc/hosts/hosts file

You should have Internet access from the Linux guest at this stage - if not something has went wrong in the previous stages. 

    # check that you are able to accesss the Internet ja DNS works 
    wget www.google.com
    
    127.0.0.1       localhost
    
    # add your host name bellow
    127.0.1.1       lp-host-name

### 1.10. install Virtual Box guest addtions
Prepare for the install Virtual Box guest addtions by running the following commands:

    # in the guest shell
    suudo apt-get install dkms build-essential linux-headers-$(uname -r)

#### 1.10.1. download Virtual Box guest addtions and configure in Windows
download Oracle Virtual Host Guest Additions to your Windows host. Save the iSO file path. 

Open the Virtual Box user interface , select the guest machine , Ctrl + S to open its settings , Storage , click the cd icon , add the path to the iso file of the guest additions. 

     apt-get update
    # you need those headers otherwise the additions installer will fail or not work properly
    apt-get install dkms build-essential linux-headers-$(uname -r)
    # mount the clicked iso file in the ui
    mount /dev/cdrom /mnt
    cd /mnt
    # Action !!! run the installer
    ./VBoxLinuxAdditions.run --nox11

#### 1.10.2. Install the guest additions in the Linux Guest
In the Linux guest terminal run as run the following commands . Check the following source if something goes wrong: 
https://www.turnkeylinux.org/docs/virtualbox-guest-addons

    apt-get update
    # you need those headers otherwise the additions installer will fail or not work properly
    apt-get install dkms build-essential linux-headers-$(uname -r)
    # mount the clicked iso file in the ui
    mount /dev/cdrom /mnt
    cd /mnt
    # Action !!! run the installer
    ./VBoxLinuxAdditions.run --nox11

### 1.11. configure filesharing between the host and the guest
Avaaa Virtual Box:in asetukset, klikkaa Shared Folders. Click the "Adds new share folder icon". 

"folder path" asetus kirjoita "C:\var" path

"folder name" asetus  kirjoita "/vagrant"

    # run the followinng commjas on the guest 
    # make a backup of the fstab file
    cp -v /etc/fstab /etc/fstab.`date +%Y%m%d_%H%M%S`
    
    echo '# this line enables the virtual machine shared folder'>>/etc/fstab
    echo '/media/sf_/vagrant /vagrant bind defaults,bind 0 0'>>/etc/fstab

### 1.12. How-to start , stop efficiently the virtual machines
Somme commands to start , stop efficiently the virtual machines from windows

    # check first your current vms 
     VBoxManage list vms
    
     # start a vm:
    VBoxManage startvm "ygeo_host_name"
    
    # or 
    VBoxManage controlvm ysg_host_name  start
    
    # start a vim without UI
    VBoxManage startvm "ygeo_host_name" --type headless
    
    # save the state of a vm
    VBoxManage controlvm ygeo_host_name  savestate
    
    # shutdown the vm
    VBoxManage controlvm ygeo_host_name  poweroff

## 2. Linux OS configurations and installations
Tässä ossioissa asennella sovelluskerroksen ajo-ympäristöt - java, play2 framework ja konfiguroidaan niitä. 

The application user could be your personal Linux OS user. 

     

### 2.1. Install additional usefull binaries
Install the following usefull binaries for Linux

    apt-get intall wget 
    apt-get install curl
    apt-get install tmux

#### 2.1.1. Customize the Linux user .bashrc file
The following configurations enable a small file usage report and a nice prompt to always know on which host and which dir path are you:

    
    # set a nice prompt
    export PS1=" \u@\h [\d \t] [\w] $ \n\n  "
    
    # # show a disk usage report
    df -a -h | tail -n +2   | perl -nle 'm/(.*)\s+(\d{1,2}%\s+(.*))/g;printf "%-20s %-15s %-70s \n","$2",$3,$1' | sort -nr

#### 2.1.2. Customize the history usage of the Linux user
More efficient bash history usage as follows:

    
    # Avoid duplicates
    export HISTCONTROL=ignoredups:erasedups
    # When the shell exits, append to the history file instead of overwriting it
    shopt -s histappend
    
    # After each command, append to the history file and reread it
    export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
    


