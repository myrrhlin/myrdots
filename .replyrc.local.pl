use StarterView::Bootstrap;
require ZR::Log::Init;
use ZR::Service::DBIC;
$ZR::Log::allow_zr_log_reinit = 1;
sub log_init_plain { ZR::Log::Init->import(-default) }
sub log_init_json  { ZR::Log::Init->import(-dumpjson) }
sub rs { zr_dbic('starterview')->resultset($_[0] =~ s/^-//r) }

1;

