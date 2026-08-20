helper scripts for use when Alpine is in data mode (vs 'sys'mode)

server-install.sh	can be used to install all prereqs and k3s server itself.
agent-install.sh	can be used to install all prereqs plus a k3s agent. Must be edited to specify K3S_URL and K3S_TOKEN

In order to clone the repo containing these scripts you have to use the following command because my CA cert is not a public one.

     git clone -c http.sslVerify=false  https://gitea.symphorines.home/chris/k3sproject

Both scripts will install my own CA certificate so you should not have to do it the next time you clone from gitea.symphorines.home
Both scrip use LBU to make sure the config is saved and, hence, restored when the system reboots


