use ExtUtils::MakeMaker;

#--- Original or revised phrtsd?
$OPT = $ARGV[0];
if ($OPT =~ /phrtsd_orig/i) {
   warn "*"x40, "\nUsing original phrtsd\n", "*"x40, "\n";
   $def = '-DPHRTSD_ORIG';
   copy('test1.pl', 'test.pl');
} else {
   $def = '';
   copy('test2.pl', 'test.pl');
}

WriteMakefile(
    'NAME'		=> 'Math::Random',
    'VERSION_FROM'	=> 'Random.pm',
    'OBJECT'		=> '$(O_FILES)',
    'LIBS'		=> ['-lm'],
    'DEFINE'		=> $def,
    'INC'		=> '',     # e.g., '-I/opt/pkg/perl5.002/dist' 
    'dist'		=> { COMPRESS=>"gzip -9", SUFFIX=>"gz" },
);

sub copy {
 my ($in, $out) = @_;
 open(I, $in) or die "Could not open $in: $!";
 open(O, ">$out") or die "Could not open $out: $!";
 while (<I>) { print O; }
 close I;
 close O;
}

# Automatic generation of C API
package MY;

sub postamble {
    my $self = shift;
    my $author = $self->{AUTHOR};
    $author = join(', ', @$author) if ref $author;
    $author =~ s/'/'\''/g;

    return <<MAKE_FRAG

c_api.h: c_api.decl
	make_perl_module_c_api module_name=\$(NAME) module_version=\$(VERSION) author='$author'
MAKE_FRAG
}

sub init_dirscan {
    my $self = shift;
    $self->SUPER::init_dirscan(@_);
    push @{$self->{H}}, 'c_api.h' unless grep $_ eq 'c_api.h', @{$self->{H}};
}
