# Copyright 2018 SUSE LLC
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Summary: Setup environment for openscap test
# Maintainer: llzhao <llzhao@suse.com>
# Tags: poo#37006

use base 'consoletest';
use strict;
use warnings;
use testapi;
use utils;
use openscaptest;
use version_utils 'is_opensuse';

sub run {

    zypper_call('in openscap-utils libxslt-tools');

    oscap_get_test_file("oval.xml");
    oscap_get_test_file("xccdf.xml");

    # xccdf.xml is for SLE, the CPE is different on openSUSE
    if (is_opensuse) {
        assert_script_run "sed -i 's#cpe:/o:suse#cpe:/o:opensuse#g' xccdf.xml";
    }
}

sub test_flags {
    return {milestone => 1, fatal => 1};
}

1;
