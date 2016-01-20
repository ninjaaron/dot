#!/usr/bin/env perl
use strict;
use Encode::BetaCode qw(beta_decode beta_encode);

my $greek = beta_decode('greek', $ARGV[0]);
print "$greek\n";
