use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Math::Random',
    'VERSION_FROM'	=> 'Random.pm',
    'OBJECT'		=> '$(O_FILES)',
    'LIBS'		=> ['-lm'],   # e.g., '-lm' 
    'DEFINE'		=> '',     # e.g., '-DHAVE_SOMETHING' 
    'INC'		=> '',     # e.g., '-I/opt/pkg/perl5.002/dist' 
    'dist'		=> { COMPRESS=>"gzip -9", SUFFIX=>"gz" }
);
