# SUSE's openQA tests
#
# Copyright 2021 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Summary: View list of available extension and modules including
# development versions in module registration.
#
# Maintainer: QA SLE YaST team <qa-sle-yast@suse.de>

use base 'y2_installbase';
use strict;
use warnings;

sub run {
    $testapi::distri->get_module_registration()->view_development_versions();
}

1;
