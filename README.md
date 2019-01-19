# RT-Authen-ExternalAuth-POP3
Request Tracker 4 authentication with POP3

# About request tracker
Request Tracker receives and manages all email sent to your key email addresses: support@, sales@, helpdesk@, security@.
https://bestpractical.com/request-tracker/

# Configuration

- Copy POP3.pm to the library folder under Authen/ExternalAuth - lib/RT/Authen/ExternalAuth/POP3.pm
- Make below changes to the ExternalAuth.pm file

Line 264 add: 

.. code-block:: 

    use RT::Authen::ExternalAuth::POP3;

Line 568 make below changes to add pop3 as elsif

.. code-block:: 

    if ($config->{'type'} eq 'db') {
        $success = RT::Authen::ExternalAuth::DBI::GetAuth($service,$username,$password);
        $RT::Logger->debug("DBI password validation result:",$success);
    } elsif ($config->{'type'} eq 'ldap') {
        $success = RT::Authen::ExternalAuth::LDAP::GetAuth($service,$username,$password);
        $RT::Logger->debug("LDAP password validation result:",$success);
    } elsif ($config->{'type'} eq 'pop3') {
        $success = RT::Authen::ExternalAuth::POP3::GetAuth($service,$username,$password);
        $RT::Logger->debug("POP3 password validation result:",$success);
    }

Line 596

.. code-block:: 

    if ($config->{'type'} eq 'db') {
        $success = RT::Authen::ExternalAuth::DBI::UserExists($username,$service);
    } elsif ($config->{'type'} eq 'pop3') {
        $RT::Logger->debug("POP3 using: $username");
        $success = RT::Authen::ExternalAuth::POP3::UserExists($username,$service);
    } elsif ($config->{'type'} eq 'ldap') {
        $success = RT::Authen::ExternalAuth::LDAP::UserExists($username,$service);
    }

Line 644

.. code-block:: 

        } elsif ($config->{'type'} eq 'pop3') {
                RT::Authen::ExternalAuth::POP3::UserExists($username,$service);
                $user_disabled = 0;
        }
        
- Make below changes to the `Users.pm`

Line 792 

.. code-block:: 

            } elsif ($config->{'type'} eq 'pop3') {
                ($found, %params) = RT::Authen::ExternalAuth::POP3::CanonicalizeUserInfo($service,$key,$value);
            }

- Open your configuration file `50-debconf.pm` and add pop3 

.. code-block:: 

    Set($ExternalSettings, {
        # AN EXAMPLE LDAP SERVICE
        'POP3'  =>      {
                'type'   => 'pop3',
                'server' => 'server.test.com',
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


# Improvment
Check if pop3 user exist is bypassed on this script.
