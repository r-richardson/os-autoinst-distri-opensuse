# SUSE's openQA tests
#
# Copyright 2018 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Package: wicked
# Summary: SIT tunnel - ifdown
# Maintainer: Anton Smorodskyi <asmorodskyi@suse.com>
#             Jose Lausuch <jalausuch@suse.com>
#             Clemens Famulla-Conrad <cfamullaconrad@suse.de>

use base 'wickedbase';
use strict;
use warnings;
use testapi;
use network_utils 'ifc_exists';

sub run {
    my ($self, $ctx) = @_;
    my $iface = '/etc/sysconfig/network/ifcfg-' . $ctx->iface();
    my $config = '/etc/sysconfig/network/ifcfg-sit1';
    $self->get_from_data('wicked/static_address/ifcfg-eth0', $iface);
    $self->get_from_data('wicked/ifcfg/sit1', $config);
    $self->setup_tunnel($config, 'sit1');
    if ($self->get_test_result('sit1', 'v6') ne 'FAILED') {
        $self->wicked_command('ifdown', 'sit1');
        die if (ifc_exists('sit1'));
    }
}

sub test_flags {
    return {always_rollback => 1};
}

1;
