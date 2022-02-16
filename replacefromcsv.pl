use File::Copy;
use File::Basename;
use File::Find::Rule;
use File::Path;
use utf8;

my $main="";
if(-d $ARGV[0]){
   $main=$ARGV[0];
}
else{
  print "This is not a directory. Kindly check";
  exit;
}
@csvfiles=File::Find::Rule->file()->name('french_dictionary.csv')->in($main);
@txtfiles=File::Find::Rule->file()->name('t8.shakespeare.txt')->in($main);
#open (FR,">$main\\frequency.csv");
$count="";
open(HTM,$txtfiles[0]);
$txtcnt=do{local $/;<HTM>};
close HTM;

foreach $csvfile(@csvfiles)
{
  open(CSV,$csvfile);
  $csvcnt=do{local $/;<CSV>};
  close CSV;
  while ($csvcnt =~ s/(.*?),(.*?)\n//)
  {
     $fname= lc($1);
     $fname_fluc = ucfirst($fname);
     $fname_uc = uc($fname);
     $fname_lc = lc($fname);
     $sname= lc($2);
     utf8::decode($sname);
     $sname_fluc = ucfirst($sname);
     $sname_uc = uc($sname);
     $sname_lc = lc($sname);
       if ($fname ne $sname)
         {
         my $count1 = $txtcnt=~ s/$fname_fluc([ ,.;:'!?\/\n\r)])/$sname_fluc$1/g;
         my $count2 = $txtcnt=~ s/$fname_uc([ ,.;:'!?\/\n\r)])/$sname_uc$1/g;
         my $count3 = $txtcnt=~ s/$fname_lc([ ,.;:'!?\/\n\r)])/$sname_lc$1/g;
         $finalcount = $count1+$count2+$count3;
         $count.= "$fname,$sname,$finalcount\n";
         }
       else{
         $count.="$fname,$sname,0\n";
       }
     }
  }

  open (F2,">$main\\output.txt");
  print F2 ($txtcnt);
  close (F2);

  open (FR,">$main\\frequency.csv");
  print FR ($count);
  close (FR);

#}
