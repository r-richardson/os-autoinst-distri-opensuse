# SUSE's openQA tests
#
# Copyright 2018-2019 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Package: wicked wicked-service
# Summary: Set up static routes from wicked XML files
# Maintainer: Anton Smorodskyi <asmorodskyi@suse.com>
#             Jose Lausuch <jalausuch@suse.com>
#             Clemens Famulla-Conrad <cfamullaconrad@suse.de>


use base 'wickedbase';
use strict;
use warnings;
use testapi;
use utils 'file_content_replace';

sub run {
    my ($self, $ctx) = @_;
    my $config = '/data/static_address/static-addresses-and-routes.xml';
    record_info('Info', 'Set up static routes from wicked XML files');
    $self->get_from_data('wicked/static_address/static-addresses-and-routes.xml', $config);
    file_content_replace($config, '--sed-modifier' => 'g', xxx => $ctx->iface());
    $self->wicked_command('ifup --ifconfig /data/static_address/static-addresses-and-routes.xml', $ctx->iface());
    $self->assert_wicked_state(ping_ip => $self->get_remote_ip(type => 'host'), iface => $ctx->iface());
}

sub test_flags {
    return {always_rollback => 1};
}

1;
