# Shotwell tests
#
# Copyright 2016-2017 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Package: shotwell nautilus
# Summary: Shotwell: Export images to folder
# Maintainer: Zhaocong Jia <zcjia@suse.com> Grace Wang <grace.wang@suse.com>
# Tags: tc#1503754

use base "x11test";
use strict;
use warnings;
use testapi;

sub run {
    my $self = shift;
    my @pictures = qw(shotwell_test.jpg shotwell_test.png);

    # Open shotwell
    $self->start_shotwell;

    # Import two test pictures into the library
    $self->import_pictures(\@pictures);

    # Export the first picture(png format) to jpeg format
    send_key "alt-home";
    send_key "ctrl-shift-e";
    assert_screen 'shotwell-export-prompt';
    send_key "alt-f";    # Choose jpeg format to export
    send_key "down";
    assert_screen 'shotwell-export-jepg';
    send_key "alt-o";
    assert_and_dclick "shotwell-export-to-desktop";
    send_key "ret";
    wait_still_screen;
    send_key "ctrl-q";    # Quit shotwell
    wait_still_screen;

    # Check the exported file
    x11_start_program('nautilus');
    wait_screen_change { send_key 'ctrl-l' };
    enter_cmd "/home/$username/Desktop";
    send_key "ret";
    assert_screen 'shotwell-exported-file';
    send_key "ctrl-w";

    # Clean shotwell's library then remove the test pictures
    $self->clean_shotwell();
}

1;
