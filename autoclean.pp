# Auto cleaner 

class clean {
	$path1 = "/${identity['user']}"
	exec { 'cd1':
		cwd => $path1,
		command => 'cd libpcap-1.9.0',
		provider => shell,
		path => '/usr/bin:/usr/sbin:/bin',

	}
	
	->
	notify {'n1':
		message => "Changing directory to libpcap-1.9.0...",
		loglevel => info,
	}
	
	->
	exec {'uninstall':
		command => 'sudo make uninstall',
		cwd => "${path1}/libpcap-1.9.0",
		path => '/usr/bin:/usr/lib/',
		require => Exec['cd1'],
		
	}
	->
	exec {'clean':
		command => 'sudo make clean',
		cwd => "${path1}/libpcap-1.9.0",
		path => '/usr/bin:/usr/lib/',
		require => Exec['uninstall'],
		
	}
	->
	notify {'n2':
		message => "Successfully executed sudo make uninstall and sudo make clean!",
		loglevel => info,
	}

}
