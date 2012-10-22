package OpenCL::Convenient;

use strict;
use warnings;
use 5.010;

use OpenCL;
use File::Slurp;
use File::ShareDir ':ALL';


=head1 NAME

OpenCL::Convenient - A convenience layer around OpenCL

=head1 SYNOPSIS

 use OpenCL::Convenient;
 OpenCL::Convenient->prepare('multiply');

=head1 DESCRIPTION

OpenCL::Convenient provides a convenience layer around OpenCL. It has
two major goals:

First, it offers simple wrapper functions around the boring stuff that
is equal for most OpenCL programs.

Second, it tries to understand your OpenCL kernels to offer better error
handling.

=head1 FUNCTIONS

=head2 prepare

  prepare($kernelfunction);

This function sets up your OpenCL environment for the typical case. It
creates a context for the first available device it finds.

=cut


sub prepare {
        my ($function, $options) = @_;
        my @platforms = OpenCL::platforms;
        my $platform = $platforms[0];

        my $dev;
        given ($options->{device}) {
                when ('CPU') { $dev = OpenCL::DEVICE_TYPE_CPU; }
                when ('GPU') { $dev = OpenCL::DEVICE_TYPE_GPU; }
                when ('ACCELERATOR') { $dev = OpenCL::DEVICE_TYPE_ACCELERATOR; }
                default { $dev = OpenCL::DEVICE_TYPE_DEFAULT; }
        }

        my $device=($platform->devices($dev))[0];
        my $ctx = $platform->context(undef, [$device], undef);
        my $queue = $ctx->queue ($device);
        my ($caller) = caller();
        my $cl_file = "$function.cl";
        $cl_file = module_file(  $caller,  $cl_file);

        my $src = File::Slurp::read_file($cl_file);
        my $prog = $ctx->program_with_source ($src);

        # build croaks on compile errors, so catch it and print the compile errors
        eval { $prog->build ( [$device], "");1 }
           or die $prog->build_log($device);
        my $kernel = $prog->kernel ($function);
        return $kernel;
}

1; # End package OpenCL::Convenient
