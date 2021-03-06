# XEN regression tests
#
# Copyright 2020 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Package: rpm
# Summary: Test the host kernel
# Maintainer: Pavel Dostal <pdostal@suse.cz>

use base 'consoletest';
use virt_autotest::common;
use warnings;
use strict;
use virt_autotest::kernel;
use testapi;
use utils;
use qam;

sub run {
    my $self = shift;
    my $kernel_log = shift // '/tmp/virt_kernel.txt';

    script_run "rpm -qa > /tmp/rpm-qa.txt";
    upload_logs("/tmp/rpm-qa.txt");

    check_virt_kernel(log_file => $kernel_log);
    upload_logs($kernel_log);
}

sub post_run_hook {
}

sub test_flags {
    return {fatal => 1};
}

1;

