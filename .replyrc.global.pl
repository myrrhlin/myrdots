# nonzip replyrc stuff here
use local::lib;
# use Data::Printer; # plugin loading this, and look at ~/.dataprinter
use Path::Tiny;

# This is extra awkward bc Data::Printer has no introspection of its config.
# These values need to mirror what's set above, or defaults.
my $ddp_show_private   = 0;
my $ddp_show_inherited = 0;

sub ddp_toggle_private {
  my $val = ($ddp_show_private ^= 1) ? 'all' : 'public';
  Data::Printer->import({class => {show_methods => $val}});
  $val;
}

sub ddp_toggle_inherited {
  my $val = ($ddp_show_inherited ^= 1) ? 'public' : 'none';
  Data::Printer->import({class => {inherited => $val}});
  $val;
}

1;
