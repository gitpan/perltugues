package perltugues::tipo;

use strict;

use overload
   '""'  => sub {
                my $r    = shift;
                $r->{valor};
              },
   '0+'  => sub {
                my $r    = shift;
                $r->{valor};
              },
   'x'  => sub {
                my $r    = shift;
                $r->{valor} x shift;
              },
   '.'  => sub {
                my $r    = shift;
                $r->{valor} . shift;
              },
   '-'  => sub {
                my $r    = shift;
                $r->{valor} - shift;
              },
   '+'  => sub {
                my $r    = shift;
                $r->{valor} + shift;
              },
   '*'  => sub {
                my $r    = shift;
                $r->{valor} * shift;
              },
   '/'  => sub {
                my $r    = shift;
                $r->{valor} / shift;
              },
   '**'  => sub {
                my $r    = shift;
                $r->{valor} ** shift;
              };

sub new {
   my $class   = shift;
   my $r;
   $r->{valor} = 0;
   $r->{regex} = '^$';
   bless $r, $class
}
sub vale{
   my $r     = shift;
   my $tmp   = shift;
   my $regex = $r->{regex};
   die qq/"$tmp" /, $r->{msg}, $/ unless $tmp =~ /$regex/;
   $r->{valor} = $tmp;
}
42;
