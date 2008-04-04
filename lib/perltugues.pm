=head1 NAME

perltugues - pragma para programar usando portugues estruturado

=cut

package perltugues;

require 5.005_62;
use strict;
use warnings;

BEGIN {
   $perltugues::AUTHOR  = "Fernando C. de Oliveira <smokemachine [at] cpan [dot] org>";
   $perltugues::VERSION =  0.0.1;
}

my $VERSION = '0.1';

use Filter::Simple;

FILTER_ONLY
  all => sub {
  my $package = shift;
  my %par = @_;
  my $DEBUG = $par{DEBUG} if $par{DEBUG};
  return unless $DEBUG;
  my $i = 0;
  my @qq = /"(.*?)"/g;
  push @qq, /'(.*?)'/g;
  s/"(.*?)"/'"$' . ($i++) . '$"'/ge;
  s/'(.*?)'/"'\$" . ($i++) . "\$'"/ge;
  filter($_);
  s/"\$(\d+)\$"/'"' . (shift @qq) . '"'/ge;
  s/'\$(\d+)\$'/"'" . (shift @qq) . "'"/ge;
  Perl::Tidy::perltidy(source => \$_, destination => \$_)
   if eval "require Perl::Tidy";
  print if $DEBUG;
  exit;
},
  code_no_comments  => \&filter;
my $tipo = "inteiro|texto|real|caracter";

sub filter {
   my @var;
   my @varArray;
   $_ = "use strict;$/" . $_;
   s#\bse\b\s*(.*?)\{#if $1\{$/#gm;
   s#\ba\s+n[ãa]o\s+ser(?:\s+q(?:ue)?)?\b\s*(.*?)\{#unless $1\{$/#gm;
   s#\bpara\b\s+(\w+)(.*?)\{#for $2\{\$$1->vale(\$_);$/#gm;
   s#\benquanto\b\s*(.*?)\{#while $1\{$/#gm;
   s#\bat(?:eh?|é)(?:\s+q(?:ue)?)?\b\s*(.*?)\{#until $1\{$/#gm;
   s/\bescreva\b(.*?)(;|$)/print($1);/g;
   s/\bleia\b(?:\s*\(?(.*?)\)?)?\s*;/chomp(my \$_tmp_=<>);\$$1->vale(\$_tmp_);/g;
   s/\bde\s+(.+?)\s+a\s+(.+?)(?:\s+a\s+cada\s+(.+?))(\s*[])};,])/map({(\$_ * $3) + $1} 0 .. (int($2\/$3) - ($1?1:0)))$4/g;
   s/\bde\s+(.+?)\s+a\s+(.+?)(\s*[])};,])/($1 .. $2)$3/g;
   s#quebra\s+de\s+linha#\$/#g;
   s#fim de texto#"\\0"#g;

### ___   Tipos Escalares  ___ ###

   my @varB = grep {!/^\s*$/} m#(?:^|;)\s*\b(?:$tipo)\s*:\s*([\w, ]+)\s*;#gsm;
   push(@var, split /\s*,\s*/, join ",", @varB);

   my $redef = (grep{my $v=$_; 1 < grep {$v eq $_} @var} @var)[0];
   die qq#Variavel "$redef" redefinida!$/# if defined $redef;

   my $err_var = (grep{!/^[a-z,A-Z]/} @var)[0];
   die qq#Nome inválido da variavel "$err_var".$/# if defined $err_var;

   my($t, $v);
   my %tipo = m#(?:^|;)\s*\b($tipo)\s*:\s*([\w, ]+)\s*;#gsmx;
   for my $t(keys %tipo){
      $_ = "use perltugues::$t;$/" . $_;
   }
   s#((?:^|;)\s*)\b($tipo)\s*:\s*([\w, ]+)\s*;
    #$1 . join$/,map{"my \$$_ = perltugues::$2->new;"}split/\s*,\s*/, $3
    #gesmx;
   for my $var(@var){
      s/([^\$])\b$var\s*=\s*((['"])?.*?\3?)\s*;/$1\$$var->vale($2);/g;
      s/([^\$])\b$var\b/$1\$$var/g;
   }

### ___   Tipos Array  ___ ###

   {
      my @varB = grep {!/^\s*$/} m#\barray\s+(?:$tipo)\s*:\s*([]\w, []+)\s*;#gsm;
      @varB = map {/^(\w+)/; $1} @varB;
      push(@varArray, split /\s*,\s*/, join ",", @varB);

      my $redef = (grep{$v=$_; 1 < grep {$v eq $_} @varArray} @varArray)[0];
      die qq#Variavel "$redef" redefinida!$/# if defined $redef;

      my $err_var = (grep{!/^[a-z,A-Z]/} @varArray)[0];
      die qq#Nome inválido da variavel "$err_var".$/# if defined $err_var;

      my($t, $v);
      my %tipo = m#\barray\s+($tipo)\s*:\s*([]\w, []+)\s*;#gxsm;
      for my $t(keys %tipo){
         $_ = "use perltugues::$t;$/" . $_;
      }
      s#\barray\s+($tipo)\s*:\s*([]\w, []+)\s*;
       #my $_tipo = $1;
        my $_var  = $2;
        join$/,map{
                     "my \@$1 = (" . (join",", ("perltugues::$_tipo->new") x $2) . ");"
                        if /^(\w+)\[(\d+)\]$/
                  }split/\s*,\s*/, $_var
       #gexsm;
      for my $var(@varArray){
         s/([^\$])\b$var\[(.*?)\]\s*=\s*((['"])?.*?\3?)\s*;/$1($2 <= \$#$var?\$$var\[$2]->vale($3):die qq#O array "$var" está sendo acessado numa posição inexistente\$\/#);/g;
         s/([^\$])\b$var\[(.*?)\]/$1($2 <= \$#$var?\$$var\[$2]:die qq#O array "$var" está sendo acessado numa posição inexistente\$\/#)/g;
         s/([^@#])\b$var\b(?!\[.*?\])/$1\@$var/g;
         s/\btamanho\s*\($var\)/\$#$var/g;
      }
   }
};
=over

=item filter()

metodo new...

=cut

=back

42;
__END__
