# SUSE's openQA tests
#
# Copyright 2018 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Package: wicked
# Summary: Advanced test cases for wicked
# Test 9 : Create a tap interface from legacy ifcfg files
# Maintainer: Anton Smorodskyi <asmorodskyi@suse.com>
#             Jose Lausuch <jalausuch@suse.com>
#             Clemens Famulla-Conrad <cfamullaconrad@suse.de>

use base 'wickedbase';
use strict;
use warnings;
use testapi;
use utils 'file_content_replace';

sub run {
    my ($self) = @_;
    my $config = '/etc/sysconfig/network/ifcfg-tap1';
    my $openvpn_server = '/etc/openvpn/server.conf';
    record_info('Info', 'Create a TAP interface from legacy ifcfg files');
    $self->get_from_data('wicked/ifcfg/tap1_ref', $config);
    $self->get_from_data('wicked/openvpn/server.conf', $openvpn_server);
    file_content_replace($openvpn_server, device => "tap1");
    $self->setup_tuntap($config, 'tap1');
}

sub test_flags {
    return {always_rollback => 1};
}

1;
