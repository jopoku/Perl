package SamO::Controller::Login;
use CB::Auth;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

SamO::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub signin :Path :Chained('object') {
    my ($self, $c ) = @_;

    # Get the username and password from form
    my $username = $c->request->params->{'username'};
    my $password = $c->request->params->{'password'};

    $c->log->debug( 'USER NAME ENTERED IS:' );
    $c->log->debug( $username );
    $c->log->debug( 'END OF DUMP.' );

    # If the username and password values were found in form
    if ($username && $password) {

        # Attempt to log the user in
        if ($c->authenticate({ username => $username,
                               password => $password  } )) {
            # If successful, then let them use the application
            $c->response->redirect($c->uri_for('index'));

            # $c->response->redirect($c->uri_for(
            #    $c->controller('System')->index));
            #    return;
        } else {
            # Set an error message
            $c->stash(error_msg => "Bad username or password.");
            $c->stash(template => 'signin');
        }
    } else {
        # Set an error message
        $c->stash(error_msg => "Empty username or password field.")
            unless ($c->user_exists);

        $c->stash(template => 'signin');
        return 0;
    }
    # If either of above don't work out, send to the login page       
    $c->stash(template => 'signin');
}

=encoding utf8

=head1 AUTHOR

=cut

sub index :Local {
    my ( $self, $c ) = @_;
    $c->stash->{sessionid} = $c->sessionid;
    $c->stash(username => 'John',
              template => 'system/index');
}

=head2 index

JOSEPH OPOKU,,,

=head1 LICENSE

=cut

__PACKAGE__->meta->make_immutable;

1;
