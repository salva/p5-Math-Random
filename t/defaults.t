# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..5\n"; }
END {print "not ok 1\n" unless $loaded;}
use Math::Random qw(:all);
$loaded = 1;
print "ok 1\n";

# test seeds and random uniform deviates (test 2)
$phrase = 'sands476';
$n = 10; $low = 0; $high = 1;
random_set_seed(random_seed_from_phrase($phrase));
@randu1 = random_uniform($n, $low, $high);

random_set_seed_from_phrase($phrase);
@randu2 = random_uniform($n);

$bad = 0;
for ($i = 0; $i < $n; $i++) {
   $bad = 1, last unless float_eq($randu1[$i],$randu2[$i]);
}
print "not " if $bad;
print "ok 2\n";

# test seeds and random uniform integer deviates (test 3)
$phrase = 'xargsfix54';
$n = 30; $low = -15; $high = 25;
random_set_seed(random_seed_from_phrase($phrase));
@randu1 = random_uniform_integer($n, $low, $high);

random_set_seed_from_phrase($phrase);
@randu2 = random_uniform_integer($n, $low, $high);

$bad = 0;
for ($i = 0; $i < $n; $i++) {
   $bad = 1, last if ($randu1[$i]-$randu2[$i]);
}
print "not " if $bad;
print "ok 3\n";

# test seeds and random permutations (test 4)
$phrase = '36fhte87';
random_set_seed_from_phrase($phrase);
@randperm1 = random_permutation(@randu1);

random_set_seed_from_phrase($phrase);
@randperm2 = @randu1[(random_permuted_index(scalar(@randu1)))];

$bad = 0;
for ($i = 0; $i < $n; $i++) {
   $bad = 1, last if ($randperm1[$i]-$randperm2[$i]);
}
print "not " if $bad;
print "ok 4\n";

# test the normal distribution (test 5). Take this with a
# big grain of salt.
@normaldata = random_normal(500, 1.0, 0.25);
($sum, $avg, $adev, $sdev, $var, $skew, $curt) =
   moments(\@normaldata);

$good_avg = float_eq($avg, 1.0, 0.02);
$good_sdev = float_eq($sdev, 0.25, 0.01);
$good_skew = float_eq($skew, 0.0, 0.01) && ($skew < 0.17);
$good_kurt = float_eq($curt, 0.0, 0.05) && ($curt < 0.44);
$good = ($good_avg && $good_sdev && $good_skew && $good_kurt);
print "not " unless $good;
print "ok 5\n";

sub float_eq {
   my ($n1, $n2, $tolerance) = @_;

   $tolerance = 1.0e-15 unless $tolerance;
   abs($n1-$n2) < $tolerance ? 1 : 0;
}

# courtesy "Numerical Recipes in C", 2nd Ed. pg. 613
sub moments {
   my ($data) = @_;

   my ($sum, $avg, $adev, $sdev, $var, $skew, $curt) = (0.0) x 7;
   my $len = scalar(@$data);
   return undef unless $len;

   for ($j = 0; $j < $len; $j++) {$sum += $data->[$j];}
   $avg = $sum / $len;

   for ($j = 0; $j < $len; $j++) {
      my $dev = $data->[$j] - $avg;
      my $absdev = abs($dev);
      $dev2 = $absdev * $absdev;
      $dev3 = $dev2 * $dev;
      $dev4 = $dev2 * $dev2;
      $var += $dev2;
      $skew += $dev3;
      $curt += $dev4;
   }
   $adev /= $len;
   $var = $var / ($len - 1);
   $sdev = sqrt($var);
   if ($var) {
      $skew /= ($len * $var * $sdev);
      $curt = ($curt/($len * $var * $var)) - 3.0;
   }
   ($sum, $avg, $adev, $sdev, $var, $skew, $curt);
}

