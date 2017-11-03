# SUSE's openQA tests
#
# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2017 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Simple memtest
# Maintainer: Oliver Kurz <okurz@suse.de>

use base "opensusebasetest";
use strict;
use testapi;
use utils 'ensure_shim_import';

sub run {
    my $self = shift;

    ensure_shim_import;
    $self->select_bootmenu_more('inst-onmemtest', 1);
    assert_screen "pass-complete", check_var('VIRSH_VMM_FAMILY', 'hyperv') ? 1100 : 700;
    send_key "esc";
}

sub test_flags {
    return {fatal => 1};
}

1;
# vim: set sw=4 et:
