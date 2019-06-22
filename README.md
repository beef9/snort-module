# snort-module
Automatic installation of Snort via Puppet

#### Details:
The Puppet script automatically installs the necessary libraries and modules for Snort, and then installs the main Snort package, without any additional plug-ins.

### Currently supported platforms: 
- Ubuntu 18.04 LTS

### Prerequisites
- Puppet
- Facter

Install Puppet and Facter:
```sh
$ sudo apt-get install puppet
$ sudo apt-get install facter
```

### Using Puppet:
The script "snort.pp" can be executed using:
```sh
$ sudo puppet apply snort.pp
```
Then, Snort can be started for testing using:
```sh
$ sudo snort -A  fast  -b  -p  -v  -u  snort  -g  snort  -c /etc/snort/snort.conf -k none -i <interface_name>
```

### Important:
If the instalation fails with the following message:
`ERROR!  Libpcap library version >= 1.0.0  not found.`
then, "libpcap-dev" must be uninstalled using:
```sh
$ sudo apt-get remove libpcap-dev
```
This is due to some conflict issues regarding library files from /usr/local/lib/libpcap.a, /usr/lib/ respectively.
Then, the autoclean.pp can be executed using:
```sh
$ sudo puppet apply autoclean.pp
```
This will uninstall libpcap library, and then execute the snort.pp script in order to install Snort again.

The code has been tested on Ubuntu 18.04 LTS.


### Updates coming soon!
- including support for other platforms
- including additional plug-ins for Snort

