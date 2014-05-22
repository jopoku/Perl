#!/usr/bin/perl 
#################################################################################
#         PURPOSE: Connects, Logs in, passes commands to Cable Modems           #
#################################################################################
package Modem::Net::Telnet::Cisco;

use strict;
use Carp;
use NetAddr::IP;
use Data::Dumper;

use Moose;

use parent 'Net::Telnet::Cisco';

#######################
#   OPTIONS & USAGE   #
#######################

##############
#   CONFIG   #
##############
has 'device_ip' => ( 
    is => 'rw', 
    isa => 'IPv4Address', 
    default => 0,
); 

has 'device_user' => ( 
    is => 'rw', 
    isa => 'Str', 
    default => 0,
);

has 'device_password' => ( 
    is => 'rw', 
    isa => 'Str', 
    default => 0,
);

# usage:
#   ->new( $device_ip )



# NEW TELNET SESSION
sub connect {
    my $self = shift;
    
    if ($self->device_ip) {

        my $session_status;
        
        $session_status = eval {my $session = Net::Telnet::Cisco->new(Host => $self->device_ip, Input_log=>'/tmp/input.log')};
        
        if ($session_status) {
            print "\n SUSSECCFUL SESSION\n";
	      		return $session;            
        } else {
            ### UNSUCCESFUL SESSION 
            print "\n UNSUCSESFUL SESSION\n";
            print "\n ATTEMPTING SESSION AGAIN\n";
            my $second_session_status;
            $second_session_status = eval { my $session = Net::Telnet::Cisco->new( Host => $self->device_ip, Prompt => '/[:\$%#>]\s?$/', Timeout => 10, Input_log => '/tmp/input.log') };
            if ($second_session_status) {
               print "\n SUSSECCFUL SESSION NOW\n";
               return $session;
            }
        }
    } else {
        print "\nInvalid address usage\n";
    }
}


# END TELNET SESSION
sub disconnect {
	$self->close();
}

no Moose;
__PACKAGE__->meta->make_immutable;
