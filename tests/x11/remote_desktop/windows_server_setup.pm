# SUSE's openQA tests
#
# Copyright 2018 SUSE LLC
# SPDX-License-Identifier: FSFAP
#
# Summary: Remote Login: SLED access Windows over RDP
# Maintainer: GraceWang <gwang@suse.com>
# Tags: tc#1610392

use strict;
use warnings;
use base 'x11test';
use testapi;
use lockapi;
use mmapi 'wait_for_children';

sub run {
    my $self = shift;

    assert_and_click "start";
    sleep 5;
    assert_and_click "system-settings";
    wait_still_screen;
    type_string "allow remote connections";
    assert_and_click "windows-settings-allow-remote-connections";

    assert_and_click "show-settings";
    assert_and_click "allow-remote-connections";
    assert_screen "allow-connections-with-nla-enabled";

    if (!get_var('NLA')) {
        send_key "alt-n";
        assert_screen "allow-connections-without-nla-enabled";
    }

    assert_and_click "system-properties-ok";
    assert_and_click "close-settings";

    mutex_create 'win_server_ready';
    wait_for_children;

    # In case execute the client job costs too much time
    # Add this part to deal with the lock screen

    assert_screen(['grub-boot-windows', 'update-required', 'generic-desktop']);
    if (match_has_tag 'grub-boot-windows') {
        send_key "esc";
        assert_screen "windows-login";
        type_password;
        send_key "ret";
    }
    elsif (match_has_tag 'update-required') {
        assert_and_click "close-update-required";
    }
}
1;
