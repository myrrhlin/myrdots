# pretty logs
$ENV{ZR_LOG_FORMAT} = 'plain';
$ENV{ZR_LOG_LEVEL}  = 'INFO';

# example resultset shortcut
# > my $user = rs(-User)->search({foo=>42})->one_row
sub rs {
  require ZR::Service::DBIC;
  ZR::Service::DBIC->connect('starterview')
    ->schema
    ->resultset($_[0] =~ s/^-//r);
}

1;
