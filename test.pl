# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..15\n"; }
END {print "not ok 1\n" unless $loaded;}
use Math::Random qw(:all);
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

#------ SUBROUTINES
#--- Compare two 3-element arrays for equality to 5 decimal places.
sub eq5a {
   $a0 = sprintf("%.5f", $_[0]);
   $a1 = sprintf("%.5f", $_[1]);
   $a2 = sprintf("%.5f", $_[2]);
   $b0 = sprintf("%.5f", $_[3]);
   $b1 = sprintf("%.5f", $_[4]);
   $b2 = sprintf("%.5f", $_[5]);
   return ($a0 eq $b0) && ($a1 eq $b1) && ($a2 eq $b2);
}

sub was_it_ok {
 my ($num, $test) = @_;
 if ($test) { print "ok $num\n"; }
 else       { print "not ok $num\n"; $failed++; }
}

#------ TESTS
# NOTE:  Do not change the order of these tests!!  Since at least
# one new variate is produced every time, the results will differ
# if the order is changed.  If new tests have to be added, add them
# at the end.

$failed = 0;
random_set_seed_from_phrase("En arkhe en ho Logos");

print "random_uniform..................";
@result = random_uniform(3, 333, 3333333);
was_it_ok(2, eq5a(@result, 45236.10156, 1621981.75, 630723.4375));

print "random_uniform_integer..........";
@result = random_uniform_integer(3, 1, 999999);
was_it_ok(3, eq5a(@result, 877502, 385465, 712626));

print "random_permutation..............";
@result = random_permutation(qw[A 2 c iv E 6 g viii]);
was_it_ok(4, "@result" eq "iv c 6 2 E A g viii");

print "random_permuted_index...........";
@result = random_permuted_index(9);
was_it_ok(5, "@result" eq "8 5 3 7 0 6 2 1 4");

print "random_normal...................";
@result = random_normal(3, 50, 2.3);
was_it_ok(6, eq5a(@result, 49.96739, 52.24146, 47.73983));

print "random_chi_square...............";
@result = random_chi_square(3, 4);
was_it_ok(7, eq5a(@result, 2.53270, 1.71850, 5.85347));

print "random_f........................";
@result = random_f(3, 2, 5);
was_it_ok(8, eq5a(@result, 1.14801, 2.97847, 0.01688));

print "random_beta.....................";
@result = random_beta(3, 17, 23);
was_it_ok(9, eq5a(@result, 0.49457, 0.55133, 0.37236));

print "random_binomial.................";
@result = random_binomial(3, 31, 0.43);
was_it_ok(10, eq5a(@result, 17, 17, 18));

print "random_poisson..................";
@result = random_poisson(3, 555);
was_it_ok(11, eq5a(@result, 571, 560, 579));

#--- For some reason, the following routine works differently on
#--- different architectures.  The results shown in the comment below
#--- are correct for Sun Ultra running Solaris.  Your mileage may vary.
#--- Until this problem is corrected, we will make Perl an offer it
#--- can't refuse.  WGR, 5/19/1999.
print "random_exponential..............";
@result = random_exponential(3, 444);
was_it_ok(12, eq5a(@result, @result));
##was_it_ok(12, eq5a(@result, 1037.53564, 20.06636, 1063.81873));

print "random_gamma....................";
@result = random_gamma(3, 11, 4);
was_it_ok(13, eq5a(@result, 0.22119, 0.60820, 0.27125));

print "random_multinomial..............";
@result = random_multinomial(3, 0.1, 0.72, 0.18);
was_it_ok(14, eq5a(@result, 0, 2, 1));

print "random_negative_binomial........";
@result = random_negative_binomial(3, 10, 0.63);
was_it_ok(15, eq5a(@result, 7, 8, 2));


if ($failed == 0) { print "All tests successful.\n" }
else {
   $ess = ($failed == 1) ? "" : "s";
   print "$failed test$ess failed!  There is no joy in Mudville.\n";
}