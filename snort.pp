
# Declaration of classes with packages required for running snort - Ubuntu 
class packages {  

	$libs = [ 'tar', 'wget', 'sudo', 'build-essential', 'libpcre3-dev', 'libdumbnet-dev', 'zlib1g-dev', 'liblzma-dev', 'openssl', 'libssl-dev', 'bison', 'flex' ]
	package { $libs: 
		ensure => 'latest',
		provider => 'apt',
	}
}

class libcap{
	$path1 = "/${identity['user']}"
	
	exec { 'wget1':
		cwd => $path1,
		command => 'wget http://www.tcpdump.org/release/libpcap-1.9.0.tar.gz',
		creates => "${path1}/libpcap-1.9.0.tar.gz",
		path => '/usr/bin/',
	}
	->
	notify { 's1':
		message => 'Archive downloaded',
		loglevel => info,
	}

	->
	exec { 'tar1':
		cwd => $path1,
		command => "tar -xvzf ${path1}/libpcap-1.9.0.tar.gz",
		creates => "${path1}/libpcap-1.9.0",
		require => Exec['wget1'],
		path => '/usr/lib/:/bin/',
	}
	->
	notify { 's2':
		message => 'Libcap archive extracted',
		loglevel => info,
	}
	->
	exec { 'cd1':
		cwd => $path1,
		command => 'cd libpcap-1.9.0',
		provider => shell,
		path => '/usr/bin:/usr/sbin:/bin',
		require => Exec['tar1'],

	}
	
	->
	notify {'s5':
		message => "Executing sudo ./configure...",
		loglevel => info,
	}

	->

	exec {'install_1_a':
		command => 'sudo ./configure',
		cwd => "${path1}/libpcap-1.9.0",
		path => '/usr/bin:/usr/lib/',
		require => Exec['cd1'],
		
	}
	->
	

	notify {'s6':
		message => "Executing sudo make...",
		loglevel => info,
	}

	->

	exec {'install_2_a':
		command => 'sudo make',
		cwd => "${path1}/libpcap-1.9.0",
		path => '/usr/bin:/usr/lib/',
		require => Exec['install_1_a'],
		
	
	}
	->
	notify {'s7':
		message => "Executing sudo make install...",
		loglevel => info,
	}
	->

	exec {'install_3_a':
		command => 'sudo make install',
		cwd => "${path1}/libpcap-1.9.0",
		path => '/usr/bin:/usr/lib/',
		require => Exec['install_2_a'],
		

	}
	->
	exec {'install_4_a':
		command => 'sudo cp /usr/local/lib/libpcap.a /usr/lib/',
		cwd => "${path1}/libpcap-1.9.0",
		path => '/bin:/usr/bin/',
		require => Exec['install_3_a'],
		
	}
	
	->
	notify {'s8':
		message => 'Successfully installed libcap',
		loglevel => info,
	}
}

class daq {

	$path1 = "/${identity['user']}"
	#$path1 = "~/Downloads"
	
	exec { 'wget':
		cwd => $path1,
		command => 'wget https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz',
		creates => "${path1}/daq-2.0.6.tar.gz",
		path => '/usr/bin/',
	}

	->
	notify { 'n2':
		message => 'Archive downloaded',
		loglevel => info,
	}

	->
	notify {'n3':
		message => 'Extracting archive...',
		loglevel => info,
	}

	->
	exec { 'tar':
		cwd => $path1,
		command => "tar -xvzf ${path1}/daq-2.0.6.tar.gz",
		creates => "${path1}/daq-2.0.6",
		require => Exec['wget'],
		path => '/usr/lib/:/bin/',
	}

	->

	exec { 'cd':
		cwd => $path1,
		command => 'cd daq-2.0.6',
		provider => shell,
		path => '/usr/bin:/usr/sbin:/bin',
		require => Exec['tar'],

	}

	->
	notify {'n4':
		message => "Directory changed",
		loglevel => info,
	}

	->
	notify {'n5':
		message => "Executing sudo ./configure...",
		loglevel => info,
	}

	->

	exec {'install_1':
		command => 'sudo ./configure',
		cwd => "${path1}/daq-2.0.6",
		path => '/usr/bin:/usr/lib/',
		require => Exec['cd'],
		
	}
	->

	notify {'n6':
		message => "Executing make...",
		loglevel => info,
	}

	->

	exec {'install_2':
		command => 'sudo make',
		cwd => "${path1}/daq-2.0.6",
		path => '/usr/bin:/usr/lib/',
		require => Exec['install_1'],
		
	
	}
	->
	notify {'n7':
		message => "Executing make install...",
		loglevel => info,
	}
	->

	exec {'install_3':
		command => 'sudo make install',
		cwd => "${path1}/daq-2.0.6",
		path => '/usr/bin:/usr/lib/',
		require => Exec['install_2'],
		

	}
	
	->
	notify {'n8':
		message => 'Successfully installed daq',
		loglevel => info,
	}


}

class snort {
	#$requirements = []	

	package {'snort':
		ensure => 'installed',
		#require => $requirements,
	}
}

if ($operatingsystem == "Ubuntu") { 
   #$message = "This machine OS is of the type $OperatingSystem \n" 
    class { 'packages': }
    class { 'libcap': }
	class { 'daq': }
	class { 'snort': }
} else { 
   #$message = "This machine is unknown \n" 
  notify {'not_supported':
		message => 'Only Ubuntu is currently supported!',
		loglevel => crit,
	}
} 
	

