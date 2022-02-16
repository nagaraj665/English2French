use File::Copy;
use File::Basename;
use File::Find::Rule;
use File::Path;
use utf8;
opendir(DIR,"$ARGV[0]");
$main=dirname($ARGV[0]);


@csvfiles=File::Find::Rule->file()->name('french_dictionary.csv')->in($main);
@txtfiles=File::Find::Rule->file()->name('t8.shakespeare_new.txt')->in($main);
foreach $txtfile(@txtfiles)
{
  open(HTM,$txtfile);
  $txtcnt=do{local $/;<HTM>};
  close HTM;

foreach $csvfile(@csvfiles)
{
  open(CSV,$csvfile);
  $csvcnt=do{local $/;<CSV>};
  close CSV;
  while ($csvcnt =~ s/(.*?),(.*?)\n//)
   {
     $fname=$1;
     $fname_fluc = ucfirst($fname);
     $fname_uc = uc($fname);
     $fname_lc = lc($fname);
     $sname=$2;
     $sname_fluc = ucfirst($sname);
     $sname_uc = uc($sname);
     $sname_lc = lc($sname);
     utf8::decode($sname);
       if ($fname ne $sname)
         {
         $txtcnt=~ s/$fname_fluc([ ,.;:'!?\/)])/$sname_fluc$1/g;
         $txtcnt=~ s/$fname_uc([ ,.;:'!?\/)])/$sname_uc$1/g;
         $txtcnt=~ s/$fname_lc([ ,.;:'!?\/)])/$sname_lc$1/g;
         $txtcnt=~ s/$fname_fluc([ ,.;:'!?\/)])\n/$sname_fluc$1\n/g;
         $txtcnt=~ s/$fname_uc([ ,.;:'!?\/)])\n/$sname_uc$1\n/g;
         $txtcnt=~ s/$fname_lc([ ,.;:'!?\/)])\n/$sname_lc$1\n/g;
         $txtcnt=~ s/$fname_fluc\n/$sname_fluc\n/g;
         $txtcnt=~ s/$fname_uc\n/$sname_uc\n/g;
         $txtcnt=~ s/$fname_lc\n/$sname_lc\n/g;
         }
     }
     open (F2,">>$main\\output.txt");
     print F2 ($txtcnt);
     close (F2);
  }
}
