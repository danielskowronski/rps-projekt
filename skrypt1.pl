use Data::Dumper;
use Time::Piece;

my $filename = 'log_phase8';
open(my $fh, $filename) or die "Could not open file '$filename' $!";

print "date,etypes,ip,authtime,user\n";

while (my $row = <$fh>) {
  my @matches = ($row =~ m/([A-Z][a-z]{2}\ \d\d\ \d\d:\d\d:\d\d)\ s1\ krb5kdc\(info\):\ (AS_REQ|TGS_REQ)\ (\(\d\ etypes\ \{(\d|\d |\d\d|\d\d )*\}\))\ (ip\d*):\ ISSUE:\ authtime\ (\d{10}),\ etypes\ \{rep=\d\d\ tkt=\d\ ses=\d\},\ ((user|test)\d*)/g);
 
  my $year=(localtime($matches[5])->strftime('%Y'))+1;
  my $t = Time::Piece->strptime($year." ".$matches[0], "%Y %b %d %H:%M:%S");
  
  #case z logowaniem na przełomie lat
  if ($matches[5]-$t->epoch < 0){
  	$t = Time::Piece->strptime(($year-1)." ".$matches[0], "%Y %b %d %H:%M:%S");
  }
  $t -= $t->localtime->tzoffset;

  print $t->epoch.','.$matches[2].','.$matches[4].','.$matches[5].','.$matches[6]."\n";
}


