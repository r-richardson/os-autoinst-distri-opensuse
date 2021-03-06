# SUSE's openQA tests
#
# Copyright 2018-2019 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Package: wicked iproute2
# Summary: Standalone card - ifdown, ifreload
# Maintainer: Anton Smorodskyi <asmorodskyi@suse.com>
#             Jose Lausuch <jalausuch@suse.com>
#             Clemens Famulla-Conrad <cfamullaconrad@suse.de>

use base 'wickedbase';
use strict;
use warnings;
use testapi;

sub run {
    my ($self, $ctx) = @_;
    my $config = '/etc/sysconfig/network/ifcfg-' . $ctx->iface();
    my $res;
    record_info('Info', 'Standalone card - ifdown, ifreload');
    $self->get_from_data('wicked/dynamic_address/ifcfg-eth0', $config);
    $self->wicked_command('ifdown', $ctx->iface());
    $self->wicked_command('ifreload', $ctx->iface());
    my $static_ip = $self->get_ip(type => 'host');
    my $dhcp_ip = $self->get_current_ip($ctx->iface());
    if (defined($dhcp_ip) && $static_ip ne $dhcp_ip) {
        $res = $self->get_test_result('host');
    } else {
        record_info('DHCP failed', 'current ip: ' . ($dhcp_ip || 'none'), result => 'fail');
        $res = 'FAILED';
    }
    die if ($res eq 'FAILED');
}

sub test_flags {
    return {always_rollback => 1};
}

1;
