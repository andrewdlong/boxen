require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::homebrewdir}/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
  #  fail('Please enable full disk encryption and try again')
  }

  # node versions
#  nodejs::version { 'v0.6': }
#  nodejs::version { 'v0.8': }
#  nodejs::version { 'v0.10': }

  # default ruby versions
#  ruby::version { '1.9.3': }
#  ruby::version { '2.0.0': }
#  ruby::version { '2.1.0': }
#  ruby::version { '2.1.1': }
#  ruby::version { '2.1.2': }

  # common, useful packages
  package {
    [

      'findutils',
      'gnu-tar'
    ]:
  }
	# Install term2
	include iterm2::stable


	#install 1passwod
	include onepassword

	include onepassword::chrome

	# install quicksilver
	include quicksilver

	# For the latest version of v2
	include sublime_text::v2
	sublime_text::v2::package { 'Emmet':
	  source => 'sergeche/emmet-sublime'
	}

	# install omnifocus
	include omnifocus

	# install evernote
	include evernote

	# install dropbox
	include dropbox

	# install thunderbird
	include thunderbird

	# install firefox
	include firefox

	# install vmware fusion
	include vmware_fusion

	# install chrome
	include chrome

	# include skitch
	include skitch
	
	# include spotify
	include spotify 

	# include dash
	include dash

	# include trackballworks
	include trackballworks

	# include vlc
	include vlc	

	# install transit
	include transmit

	# install sequel_pro
	include sequel_pro 

	# install divvy
	include divvy

	# install google drive
	include googledrive	

	# install airfoil
	include airfoil

	# install xtrafinder
	include xtrafinder

	# install getsync
	include btsync

	# Install the default version of both the JDK and JRE
	include java


  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
