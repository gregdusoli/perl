#!/usr/local/bin/perl

use MIME::Base64;

$ARGC = @ARGV;

if ( $ARGC != 4 ) {
    printf "$0 <mailist> <sender> <subject> <template.htm>\n\n";
    exit(1);
}

$sendmail = "/usr/sbin/sendmail";
$sender   = $ARGV[1];
$subject  = $ARGV[2];
$efile    = $ARGV[0];
$emar     = $ARGV[0];

sub getIp {
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

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

open( FOO, $ARGV[3] );

@foo = <FOO>;

open( BANDFIT, "$emar" ) || die "Can't Open $emar";

$cont = 0;

$myip = getIp();

while (<BANDFIT>) {
    ( $ID, $options ) = split( /\|/, $_ );

    chop($options);

    foreach ($ID) {
        my @userid = split( ",", $ID, 2 );

        $r1 = int( rand(9) );
        $r2 = int( rand(99) );
        $r3 = int( rand(999) );
        $r4 = int( rand(9999) );
        $r5 = int( rand(99999) );
        $r6 = int( rand(999999) );
        $r7 = int( rand(9999999) );
        $r8 = int( rand(99999999) );
        $r9 = int( rand(999999999) );

        $recipient = $userid[0];
        $username  = trim( $userid[1] );

        $bodyx = join( "\n", @foo );
        $bodyx =~ s/%email%/$ID/g;
        $bodyx =~ s/%username%/$username/g;
        $bodyx =~ s/%ip%/$myip/g;
        $bodyx =~ s/%rand1%/$r1/g;
        $bodyx =~ s/%rand2%/$r2/g;
        $bodyx =~ s/%rand3%/$r3/g;
        $bodyx =~ s/%rand4%/$r4/g;
        $bodyx =~ s/%rand5%/$r5/g;
        $bodyx =~ s/%rand6%/$r6/g;
        $bodyx =~ s/%rand7%/$r7/g;
        $bodyx =~ s/%rand8%/$r8/g;
        $bodyx =~ s/%rand9%/$r9/g;
        $bodyx =~ s/%email%/$sendmail/g;
        $body = encode_base64($bodyx);

        $subject =~ s/%email%/$ID/g;
        $subject =~ s/%ip%/$myip/g;
        $subject =~ s/%rand1%/$r1/g;
        $subject =~ s/%rand2%/$r2/g;
        $subject =~ s/%rand3%/$r3/g;
        $subject =~ s/%rand4%/$r4/g;
        $subject =~ s/%rand5%/$r5/g;
        $subject =~ s/%rand6%/$r6/g;
        $subject =~ s/%rand7%/$r7/g;
        $subject =~ s/%rand8%/$r8/g;
        $subject =~ s/%rand9%/$r9/g;

        $sender =~ s/%rand4%/$r4/g;

        open( SENDMAIL, "| $sendmail -t" );
        print SENDMAIL "MIME-Version: 1.0\n";
        print SENDMAIL "Content-type:  text/html; charset=UTF-8\n";
        print SENDMAIL "Content-Transfer-Encoding: base64\n";

        #print SENDMAIL "$mailtype\n";
        print SENDMAIL "Subject: $subject: $myip\n";
        print SENDMAIL "From: $sender\n";
        print SENDMAIL "To: $recipient\n";
        print SENDMAIL "$body\n\n";
        close(SENDMAIL);

        $cont = $cont + 1;
        printf "$cont * Message sent to > $recipient\n";
    }
}

close(BANDFIT);
