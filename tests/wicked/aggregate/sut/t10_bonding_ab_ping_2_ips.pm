# SUSE's openQA tests
#
# Copyright 2019 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Package: wicked iproute2
# Summary: Bonding, Active-Backup Ping 2 IPs
# Maintainer: Anton Smorodskyi <asmorodskyi@suse.com>
#             Jose Lausuch <jalausuch@suse.com>
#             Clemens Famulla-Conrad <cfamullaconrad@suse.de>

use Mojo::Base 'wickedbase';
use testapi;


sub run {
    my ($self, $ctx) = @_;
    record_info('INFO', 'Bonding, Active-Backup Ping 2 IPs');
    $self->setup_bond('ab-arping-2ips', $ctx->iface(), $ctx->iface2());
    $self->validate_interfaces('bond0', $ctx->iface(), $ctx->iface2());
    $self->check_fail_over('bond0');
    $self->ping_with_timeout(type => 'host', interface => 'bond0', count_success => 30, timeout => 4);
}

sub test_flags {
    return {always_rollback => 1};
}

1;
