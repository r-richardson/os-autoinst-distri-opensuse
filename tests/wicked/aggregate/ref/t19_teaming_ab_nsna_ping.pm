# SUSE's openQA tests
#
# Copyright 2019 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Package: iproute2
# Summary: Teaming, Active-Backup NSNA Ping
# Maintainer: Anton Smorodskyi <asmorodskyi@suse.com>
#             Jose Lausuch <jalausuch@suse.com>
#             Clemens Famulla-Conrad <cfamullaconrad@suse.de>

use Mojo::Base 'wickedbase';
use testapi;


sub run {
    my ($self, $ctx) = @_;
    record_info('INFO', 'Teaming, Active-Backup NSNA Ping');
    my $ip6 = $self->get_ip(type => 'host6', netmask => 1);
    assert_script_run('ip a a ' . $ip6 . ' dev ' . $ctx->iface());
}

1;
