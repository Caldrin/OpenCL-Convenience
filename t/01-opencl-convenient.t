#! /usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 1;

BEGIN { use_ok('OpenCL::Convenient') }


my $retval = OpenCL::Convenient::prepare('multiply');

is($retval, undef, 'OpenCL preparation finished');
