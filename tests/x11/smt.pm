# SUSE's openQA tests
#
# Copyright 2016-2019 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Package: smt smt
# Summary: Add smt configuration test
#    test installation and upgrade with smt pattern, basic configuration via
#    smt-wizard and validation with smt-repos smt-sync return value
# Maintainer: Jozef Pupava <jpupava@suse.com>, Wei Gao <wegao@suse.com>

use base 'x11test';
use strict;
use warnings;
use testapi;
use repo_tools;
use utils 'zypper_call';
use x11utils 'turn_off_gnome_screensaver';

sub run {
    x11_start_program('xterm -geometry 150x35+5+5', target_match => 'xterm');
    # Avoid blank screen since smt sync needs time
    turn_off_gnome_screensaver;
    become_root;
    # remove apache2-example-pages to avoid warning message shown during smt test
    # if return 104 means the apache2-example-pages not exist, continue the test
    zypper_call("rm apache2-example-pages", exitcode => [0, 104]);
    smt_wizard();
    assert_script_run 'smt-sync', 800;
    assert_script_run 'smt-repos';

    # mirror and sync a base repo from SCC
    smt_mirror_repo();
    enter_cmd "killall xterm";
}

sub test_flags {
    return {fatal => 1};
}

1;
