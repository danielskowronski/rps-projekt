use Data::Dumper;
use strict;

my $filename = 'log_phase8';
open(my $fh, $filename) or die "Could not open file '$filename' $!";

while (my $row = <$fh>) {
  my @matches = ($row =~ m/([A-Z][a-z]{2}\ \d\d\ \d\d:\d\d:\d\d)\ s1\ krb5kdc\(info\):\ (AS_REQ|TGS_REQ)\ (\(\d\ etypes\ \{(\d|\d |\d\d|\d\d )*\}\))\ (ip\d*):\ ISSUE:\ authtime\ (\d{10}),\ etypes\ \{rep=\d\d\ tkt=\d\ ses=\d\},\ ((user|test)\d*)/g);
#      print Dumper \@matches;
  print $matches[0].','.$matches[2].','.$matches[4].','.$matches[5].','.$matches[6]."\n";
}


