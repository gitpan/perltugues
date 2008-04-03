package perltugues::caracter;

use perltugues::tipo;

use overload 
   "=="  => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} eq $o->{valor}
                 }else{
                    return $r->{valor} eq $o
                 }
              },
   "!="  => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} ne $o->{valor}
                 }else{
                    return $r->{valor} ne $o
                 }
              },
   ">"  => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} gt $o->{valor}
                 }else{
                    return $r->{valor} gt $o
                 }
              },
   "<"  => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} lt $o->{valor}
                 }else{
                    return $r->{valor} lt $o
                 }
              },
   ">=" => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} ge $o->{valor}
                 }else{
                    return $r->{valor} ge $o
                 }
              },
   "<=" => sub{
                 my $r = shift;
                 my $o = shift;
                 if(ref $o =~ /perltugues::\w+/) {
                    return $r->{valor} le $o->{valor}
                 }else{
                    return $r->{valor} le $o
                 }
              },
;

@perltugues::caracter::ISA = qw/perltugues::tipo/;

sub new {
   my $class   = shift;
   my $r = $class->SUPER::new;
   $r->{valor} = 0;
   $r->{regex} = '^.?$';
   $r->{msg}   = 'Não é um Caracter';
   bless $r, $class
}
42;
