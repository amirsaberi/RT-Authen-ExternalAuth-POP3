# BEGIN BPS TAGGED BLOCK {{{
#
# COPYRIGHT:
#
# This software is Copyright (c) 1996-2016 Best Practical Solutions, LLC
#                                          <sales@bestpractical.com>
#
# Developed by Amirhossein Saberi - https://github.com/amirsaberi
#
# (Except where explicitly superseded by other copyright notices)
#
#
# LICENSE:
#
# This work is made available to you under the terms of Version 2 of
# the GNU General Public License. A copy of that license should have
# been provided with this software, but in any event can be snarfed
# from www.gnu.org.
#
# This work is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301 or visit their web page on the internet at
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.html.
#
#
# CONTRIBUTION SUBMISSION POLICY:
#
# (The following paragraph is not intended to limit the rights granted
# to you to modify and distribute this software under the terms of
# the GNU General Public License and is only of importance to you if
# you choose to contribute your changes and enhancements to the
# community by submitting them to Best Practical Solutions, LLC.)
#
# By intentionally submitting any modifications, corrections or
# derivatives to this work, or any other work intended for use with
# Request Tracker, to Best Practical Solutions, LLC, you confirm that
# you are the copyright holder for those contributions and you grant
# Best Practical Solutions,  LLC a nonexclusive, worldwide, irrevocable,
# royalty-free, perpetual, license to use, copy, create derivative
# works based on those contributions, and sublicense and distribute
# those contributions and any derivatives thereof.
#
# END BPS TAGGED BLOCK }}}

package RT::Authen::ExternalAuth::POP3;


use Net::POP3;
use warnings;
use strict;

=head1 NAME

RT::Authen::ExternalAuth::POP3 - POP3 source for RT authentication

=head1 DESCRIPTION

Provides the LDAP implementation for L<RT::Authen::ExternalAuth>.

=head1 SYNOPSIS

    Set($ExternalSettings, {
        # AN EXAMPLE LDAP SERVICE
        'POP3'  =>      {
                'type'   => 'pop3',
                'server' => '1.1.1.1',
            'attr_match_list' => [
                'Name',
                'EmailAddress'
            ],
            'attr_map' => {
                'Name' => 'username',
                'EmailAddress' => 'username'
            },

        },

    } );

=head1 CONFIGURATION


=over 4

=item server

The server hosting the POP3.

=item user, pass

The username and password RT should use to connect to the POP3
server.

=item server

The POP3 server.

=back

=cut

sub GetAuth {

    	my ($service, $username, $password) = @_;
	
	my $config = RT->Config->Get('ExternalSettings')->{$service};

    	$RT::Logger->debug( "Trying external auth service:",$service);

        my $pop = Net::POP3->new($config->{'server'};);
        if ($pop->login("$username", "$password")) {
                $RT::Logger->debug("POP3 password validation result success!! - $username");
        } else {
                $RT::Logger->debug("POP3 password validation result failed!! - $username");
                return 0;
        }

    	return 1;

}


sub CanonicalizeUserInfo {

    my ($service, $key, $value) = @_;


    my $found = 1;

    my %params = (Name         => $value,
                  EmailAddress => $value);

    return ($found, %params);
}

sub UserExists {

    # No need to check multiple time
    return 1;
}

sub UserDisabled {

    my ($username,$service) = @_;

}


# }}}

RT::Base->_ImportOverlays();

1;
