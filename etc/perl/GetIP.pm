package GetIP;

use Exporter qw(import);

our @ISA    = qw(Exporter);
our @EXPORT_OK = qw(get);

sub get {
    system("wget -q http://ipchicken.com");
    my $file = "index.html";
    open( FILE, "<$file" ) || die("Could not open file!");

    my @raw_data = <FILE>;
    my @ip       = "";

    foreach (@raw_data) {
        if (/((\d{1,3})(\.)){3}\d{1,3}/) {
            s/[^0-9.]*//g;
            $ip = $_;
            unlink glob $file;

            return $ip;
        }
    }
}
