use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> 'Math::Random',
    'VERSION_FROM'	=> 'Random.pm',
    'OBJECT'		=> '$(O_FILES)',
    'LIBS'		=> ['-lm'],
    'DEFINE'		=> '',
    'INC'		=> '',     # e.g., '-I/opt/pkg/perl5.002/dist' 
    'dist'		=> { COMPRESS=>"gzip -9", SUFFIX=>"gz" }
);
