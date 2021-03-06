# SUSE's openQA tests
#
# Copyright 2017 SUSE LLC
# SPDX-License-Identifier: FSFAP
#
# Summary: This test changes the VERSION to TARGET_DEVELOPING_VERSION and reload needles.
#          This test should be loaded after host upgrade.
#          It needs to be wrapped in test because
#          set_var with reload_needles option needs to be run in test files rather than main.pm,
# Maintainer: xlai@suse.com


use strict;
use warnings;
use base "virt_autotest_base";
use testapi;

sub run {
    #switch VERSION TO TARGET_DEVELOPING_VERSION
    set_var('VERSION', get_required_var('TARGET_DEVELOPING_VERSION'), reload_needles => 1);
}

1;

