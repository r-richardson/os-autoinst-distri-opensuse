# Evolution tests
#
# Copyright 2016 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Test Case #1503976 Pop Meeting

# Package: evolution
# Summary: Test Case #1503976 Pop Meeting
#    This case is used for tc#1503976, send the meeting request by evolution and the
#    receiver will get the meeting request with POP3 protocol.
# - Setup a pop account with credentials from internal_account_A
# - Send a meeting request, from internal_account_A to internal_account_B,
#   subject: current date and random strings and check
# - Exit evolution
# - Setup a pop account with credentials from internal_account_B
# - Check for email with invitation and check results
# - Exit evolution
# Maintainer: Zhaocong Jia <zcjia@suse.com>

use base "x11test";
use strict;
use warnings;
use testapi;
use utils;

sub run {
    my $self = shift;
    my $mail_subject = $self->get_dated_random_string(4);
    # Select correct account to use with multimachine.
    my $account = "internal_account";
    my $hostname = get_var('HOSTNAME');
    if ($hostname eq 'client') {
        #Setup account account C, and use it to send a meeting
        #send meet request by account D
        $self->setup_pop("internal_account_C");
        $self->send_meeting_request("internal_account_C", "internal_account_D", $mail_subject);
        assert_screen "evolution_mail-ready", 60;
        # Exit
        send_key "alt-f";
        send_key "q";
        wait_still_screen;
        #login with account D and check meeting request.
        $self->setup_pop("internal_account_D");
        $self->check_new_mail_evolution($mail_subject, "internal_account_D", "POP");

    }
    else {
        #Setup account account A, and use it to send a meeting
        #send meet request by account A
        $self->setup_pop("internal_account_A");
        $self->send_meeting_request("internal_account_A", "internal_account_B", $mail_subject);
        assert_screen "evolution_mail-ready", 60;
        # Exit
        send_key "alt-f";
        send_key "q";
        wait_still_screen;
        #login with account B and check meeting request.
        $self->setup_pop("internal_account_B");
        $self->check_new_mail_evolution($mail_subject, "internal_account_B", "POP");
    }
    wait_still_screen;
    # Exit
    send_key "ctrl-q";
}

1;
