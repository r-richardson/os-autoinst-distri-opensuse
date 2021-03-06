# SUSE's openQA tests
#
# Copyright 2018-2019 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Package: wicked
# Summary: VLAN - ifup all, ifdown one card
# Maintainer: Anton Smorodskyi <asmorodskyi@suse.com>
#             Jose Lausuch <jalausuch@suse.com>
#             Clemens Famulla-Conrad <cfamullaconrad@suse.de>

use base 'wickedbase';
use strict;
use warnings;
use testapi;
use network_utils 'ifc_exists';
use utils 'file_content_replace';

sub run {
    my ($self, $ctx) = @_;
    my $config = '/etc/sysconfig/network/ifcfg-' . $ctx->iface() . '.42';
    $self->get_from_data('wicked/ifcfg/eth0.42', $config);
    file_content_replace($config, interface => $ctx->iface(), ip_address => $self->get_ip(type => 'vlan_changed', netmask => 1));
    $self->wicked_command('ifup', 'all');
    $self->wicked_command('ifdown', $ctx->iface() . '.42');
    $self->wicked_command('ifreload', 'all');
    die('VLAN interface does not exists') unless ifc_exists($ctx->iface() . '.42');
    $self->ping_with_timeout(type => 'vlan_changed', timeout => '50');
    $self->wicked_command('ifdown', "all");
    die('VLAN interface exists') if (ifc_exists($ctx->iface() . '.42'));
}

sub test_flags {
    return {always_rollback => 1};
}

1;
