#! /usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 1;

use lib 't/lib/';

BEGIN { use_ok('OpenCL::Convenient') }


my $retval = OpenCL::Convenient::prepare('test');

is($retval, undef, 'OpenCL preparation finished');
