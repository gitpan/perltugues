package perltugues;

=head1 NAME

perltugues - pragma para programar usando portugues estruturado

=cut

=head1 VERSION

0.1

=cut

=head1 SYNOPSIS

    use perltugues;
    
    inteiro: i, j;
    texto: k;
    inteiro: l;
    
    para i (de 1 a 100 a cada 5) {
       escreva i, quebra de linha;
       k = "lalala";
       escreva k, quebra de linha;
       escreva j, quebra de linha;
    }
    
    enquanto(i >= j){
       escreva 'i e j => ', i, " >= ", j++, quebra de linha;
    }
    
    escreva quebra de linha; 
    
    escreva de 0 a 50 a cada 10, quebra de linha;

=head1 AUTHOR

Fernando Correa de Oliveira <fco@cpan.org>

=head1 DESCRIPTION

C<Perltugues> eh uma forma facil de se aprender algoritmo. Com ele vc tem uma "linguagem" (quase) completa em portugues, o que facilita muito a aprendizagem. E a tranzicao para o C<perl> eh muito simples.

=head2 Variaveis:

Todos os nomes de variaveis em C<perltugues> devem comecar com uma letra (/^[a-zA-Z]/)

=head3 Tipos de variaveis

Em C<perltugues> existem 4 tipos de variaveis:

=head4 caracter

=head4 inteiro

=head4 real

=head4 texto

=head3 Declaracao de variaveis

Variaveis sao declaradas da seguinte forma:

    inteiro: i;
    inteiro: j;

    inteiro: i, j;

    texto: str;

    caracter: chr1, chr2;

=head2 Estruturas de Iteracao:

=head3 para

    para i (de 0 a 10){
        ...
    }

=head3 enquanto

    enquanto(i != j){
        ...
    }

=head3 ateh que

    ateh que(i == j){
        ...
    }

=cut

require 5.005_62;
use strict;
use warnings;

BEGIN {
   $perltugues::AUTHOR  = "Fernando C. de Oliveira <fco\@cpan.org>";
   $perltugues::VERSION = 0.1;
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
   s#\ba\s+n[aa]o\s+ser(?:\s+q(?:ue)?)?\b\s*(.*?)\{#unless $1\{$/#gm;
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
   die qq#Nome invalido da variavel "$err_var".$/# if defined $err_var;

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
      die qq#Nome invalido da variavel "$err_var".$/# if defined $err_var;

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
         s/([^\$])\b$var\[(.*?)\]\s*=\s*((['"])?.*?\3?)\s*;/$1($2 <= \$#$var?\$$var\[$2]->vale($3):die qq#O array "$var" esta sendo acessado numa posicao inexistente\$\/#);/g;
         s/([^\$])\b$var\[(.*?)\]/$1($2 <= \$#$var?\$$var\[$2]:die qq#O array "$var" esta sendo acessado numa posicao inexistente\$\/#)/g;
         s/([^@#])\b$var\b(?!\[.*?\])/$1\@$var/g;
         s/\btamanho\s*\($var\)/\$#$var/g;
      }
   }
};

=over

=item filter()

metodo new...

=back

=cut

42;
__END__
