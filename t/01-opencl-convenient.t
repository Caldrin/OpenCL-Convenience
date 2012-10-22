#! /usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 2;

use lib 't/lib/';

BEGIN { use_ok('OpenCL::Convenient::Testing') }


my $retval = OpenCL::Convenient::Testing::prepare('testing');

is(ref $retval, 'OpenCL::Kernel', 'OpenCL preparation finished');
