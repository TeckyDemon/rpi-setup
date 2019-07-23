use v5.10;
use strict;
use warnings;
use experimental 'smartmatch';
use Term::ANSIColor qw(color colored);
use Term::ReadPassword qw(read_password);
require File::Temp;

my $VERSION='1.0.3';

my $image_file;
my $device;
my $use_ssh=1;
my $configure_network=1;
my $SSID;
my $country_code;
my $configure_static_ip=1;
my $interface;
my $IP;
my $routers;
my $domain_name_servers;
my $block_size='4M';

sub get_arg{
	my $arg=shift @ARGV;
	if(!$arg||$arg=~/^-{1,2}/){die "Wrong number of arguments for \"$_\".\nExpected $_[1].\nGot ".($_[0]-1).".\n"}
	return $arg;
}
do{
	given(shift @ARGV){
		when(['-v','--version']){
			print "RPI-Setup v$VERSION\n";
			exit;
		}
		when(['-i','--image']){$image_file=get_arg(1,1)}
		when(['-d','--device']){$device=get_arg(1,1)}
		when(['-S','--no-ssh']){$use_ssh=0}
		when(['-N','--no-network']){$configure_network=0}
		when(['-s','--ssid']){$SSID=get_arg(1,1)}
		when(['-c','--countr-code']){$country_code=get_arg(1,1)}
		when(['-I','--no-static-ip']){$configure_static_ip=0}
		when('--interface'){$interface=get_arg(1,1)}
		when('--ip'){$IP=get_arg(1,1)}
		when(['-r','--routers']){$routers=get_arg(1,1)}
		when(['-D','--domain-name-servers']){$domain_name_servers=get_arg(1,1)}
		when(['-b','--block-size']){$block_size=get_arg(1,1)}
		default{
			print color 'blue';
			print "usage: perl main.pl [-h] [-v] -i FILE -d DEVICE [-S] [-N] [-s SSID] [-c CODE] [-I] [--interface INTERFACE] [--ip IP] [-r IP] [-D IP] [-b SIZE]\n";
			print "  -h, --help            show this help message and exit\n";
			print "  -v, --version            show version and exit\n";
			print "  -i, --image FILE\n            set path to the image file\n";
			print "  -d, --device DEVICE\n            set device\n";
			print "  -S, --no-ssh\n            turn off SSH\n";
			print "  -N, --no-network\n            turn off network configuration\n";
			print "  -s, --ssid SSID\n            set SSID\n";
			print "  -c, --country-code CODE\n            set country code\n";
			print "  -I, --no-static-ip\n            turn off static IP configuration\n";
			print "  --interface INTERFACE\n            set interface\n";
			print "  --ip IP\n            set static IP\n";
			print "  -r, --routers IP\n            set routers\n";
			print "  -D, --domain-name-servers IP\n            set domain name servers\n";
			print "  -b, --block-size SIZE\n            set block size\n";
			if(not $_~~[undef,'-h','--help']){die colored "Invalid option \"$_\".\n",'red'}
			print color 'reset';
			exit;
		}
	}
}while(@ARGV);
die colored "[-] This script has to be run as root.\n",'red' if($<!=0);
die colored "[-] \"-i\"/\"--image\" option is required.\n",'red' if(!$image_file);
die colored "[-] \"-d\"/\"--device\" option is required.\n",'red' if(!$device);

print colored "[+] Writing \"$image_file\" to \"$device\"\n",'green';
system 'dd',"if=$image_file","of=$device",'oflag=sync',"bs=$block_size",'status=progress' and exit $?>>8;
print colored "[+] Successfully wrote \"$image_file\" to \"$device\"\n",'green';

{
	my $boot=$device.($device=~/\/dev\/sd.*/ ?'':'p').'1';
	my $mount_point=File::Temp->newdir();
	print colored "[+] Mounting \"$boot\" at \"$mount_point\"\n",'green';
	system 'mount',$boot,$mount_point and exit $?>>8;
	print colored "[+] Successfully mounted \"$boot\" at \"$mount_point\"\n",'green';
	if($use_ssh){
		print colored "[+] Turning on SSH.\n",'green';
		print colored "[+] Creating \"$mount_point/ssh\"\n",'green';
		open my $ssh,'>',$mount_point.'/ssh' or die colored "[-] Can't open \"$mount_point/ssh\": $!.\n",'red';
		print colored "[+] Successfully created \"$mount_point/ssh\"",'green';
		print colored "[+] Closing \"$mount_point/ssh\"\n",'green';
		close $ssh or die colored "[-] Can't close \"$mount_point/ssh\": $!.\n",'red';
		print colored "[+] Successfully closed \"$mount_point/ssh\"\n",'green';
		print colored "[+] Successfully turned on SSH.\n",'green';
	}
	if($configure_network){
		print colored "[+] Starting network configuration.\n",'green';
		print color 'green';
		if(!$SSID){
			print 'SSID: ';
			$SSID=<STDIN>;
			chomp $SSID;
		}
		my $password=read_password 'Password: ';
		if(!$country_code){
			print 'Country code: ';
			$country_code=<STDIN>;
			chomp $country_code;
		}
		print color 'reset';
		print colored "[+] Opening \"$mount_point/wpa_supplicant.conf\"\n",'green';
		open my $wpa_supplicant,'>',$mount_point.'/wpa_supplicant.conf' or die colored "[-] Can't open \"$mount_point/wpa_supplicant.conf\": $!.\n",'red';
		print colored "[+] Successfully opened \"$mount_point/wpa_supplicant.conf\"\n",'green';
		print colored "[+] Writing to \"$mount_point/wpa_supplicant.conf\"\n",'green';
		print $wpa_supplicant (<<"		EOF")=~s/^\t{3}//grm;
			ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
			update_config=1
			country=$country_code

			network={
				ssid="$SSID"
				psk="$password"
				key_mgmt=WPA-PSK
			}
		EOF
		print colored "[+] Successfully wrote to \"$mount_point/wpa_supplicant.conf\"\n",'green';
		print colored "[+] Closing \"$mount_point/wpa_supplicant.conf\"\n",'green';
		close $wpa_supplicant or die colored "[-] Can't close \"$mount_point/wpa_supplicant.conf\": $!.\n",'red';
		print colored "[+] Successfully closed \"$mount_point/wpa_supplicant.conf\"\n",'green';
		print colored "[+] Successfully configured network.\n",'green';
	}
	print colored "[+] Unmounting \"$boot\"\n",'green';
	system 'umount',$boot and exit $?>>8;
	print colored "[+] Successfully unmounted \"$boot\"\n",'green';
}
if($configure_static_ip){
	print colored "[+] Configuring static IP address.\n",'green';
	my $root=$device.($device=~/\/dev\/sd.*/ ?'':'p').'2';
	my $mount_point=File::Temp->newdir();
	print colored "[+] Mounting \"$root\" at \"$mount_point\"\n",'green';
	system 'mount',$root,$mount_point and exit $?>>8;
	print colored "[+] Successfully mounted \"$root\" at \"$mount_point\"\n",'green';
	print color 'green';
	if(!$interface){
		print 'Interface: ';
		$interface=<STDIN>;
		chomp $interface;
	}
	if(!$IP){
		print 'IP: ';
		$IP=<STDIN>;
		chomp $IP;
	}
	if(!$routers){
		print 'Routers: ';
		$routers=<STDIN>;
		chomp $routers;
	}
	if(!$domain_name_servers){
		print 'Domain name servers: ';
		$domain_name_servers=<STDIN>;
		chomp $domain_name_servers;
	}
	print color 'reset';
	print colored "[+] Opening \"$mount_point/etc/dhcpcd.conf\"\n",'green';
	open my $dhcpcd,'>',$mount_point.'/etc/dhcpcd.conf' or die colored "[-] Can't open \"$mount_point/etc/dhcpcd.conf\": $!.\n",'red';
	print colored "[+] Successfully opened \"$mount_point/etc/dhcpcd.conf\"\n",'green';
	print colored "[+] Writing to \"$mount_point/etc/dhcpcd.conf\"\n",'green';
	print $dhcpcd (<<"	EOF")=~s/^\t{2}//grm;
		interface $interface
		static ip_address=$IP/24
		static routers=$routers
		static domain_name_servers=$domain_name_servers
	EOF
	print colored "[+] Successfully wrote to \"$mount_point/etc/dhcpcd.conf\"\n",'green';
	print colored "[+] Closing \"$mount_point/etc/dhcpcd.conf\"\n",'green';
	close $dhcpcd or die colored "[-] Can't close \"$mount_point/etc/dhcpcd.conf\": $!.\n",'red';
	print colored "[+] Successfully closed \"$mount_point/etc/dhcpcd.conf\"\n",'green';
	print colored "[+] Unmounting \"$root\"\n",'green';
	system 'umount',$root and exit $?>>8;
	print colored "[+] Successfully unmounted \"$root\"\n",'green';
	print colored "[+] Successfully configured static IP address.\n",'green';
}
