# file: PerlCheatSheet.pl v.1.1.0 docs at the end 

use POSIX qw(strftime);
$now= strftime ("%Y-%m-%d %H:%M:%S", localtime);


# how-to install modules from the cpan
perl -MCPAN -e 'install HTML::Template' 
perl -MCPAN -e "install PAR::Packer"

perl -MCPAN -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit'

#or combine it with local::lib module for non-privileged users
perl -MCPAN -Mlocal::lib=~/perl5 -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit'


curl -L http://cpanmin.us | perl - --sudo App::cpanminus
cpanm Foo::Bar


# if this does not work 
##################################################
## START install perl modules by tar.gz
##################################################
# go to where you did download the modules tar
cd /path/to/module
tar -zxvf *.tar.gz

# create the make file 
perl Makefile.PL
# run make 
make
# optionally test 
make test 
# optionally create the make html 
make html 
# install 
make install
##################################################
## STOP install perl modules by tar.gz
##################################################

# how-to install modules on Windows
ppm install "HTML::Template"

# how-to install modules with cpan
# first run in your shell  ( bash , sh , cmd ) 
cpan
install Spreadsheet::XLSX
# check output - 99% of the cases no errors will be found and you are ok 


#READ ALL ROWS OF A FILE TO ALIST 
open (INPUT, "<$inputfile") || print "could not open the file!\n";  
@myfile = <INPUT>;
close INPUT;

#FOREACH LINE OF THE FILE DO SOMETHING
foreach my $line ( @lineArray  ) {
print "$line" ; 
} #eof foreach 
# END FOREACH LINE 


local( $/, *FILE ) ; 
open (FILE , $sessionFile ) or 
die "Cannot find $sessionFile !!! " ; 
$fileString = <FILE>; #slurp the whole file into one string !!! 
close FILE ; 


#GET A NICE TIME 
sub timestamp {
#
# Purpose: returns the time in yyyymmdd-format 
#
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
#---- change 'month'- and 'year'-values to correct format ---- 
$min = "0$min" if ($min < 10); 
$hour = "0$hour" if ($hour < 10);
$mon = $mon + 1;
$mon = "0$mon" if ($mon < 10); 
$year = $year + 1900;
$mday = "0$mday" if ($mday < 10); 
return "$year$mon$mday" . "_" . "$hour$min" . "_" . $sec; 
} #eof timestamp 


# GREP ALL ROWS CONTAINING 'MACHINE=' (TO A LIST)
@list = grep(/machine=/,@rows); 

# A NICE WAY TO CONCATENATE A STRING TO THE SAME STRING 
#--- Collect agents from yesterday ------------------------------
$sql = "select distinct(AgentName),LocationName from TransactionDetails td "; 
$sql .= "inner join Applications ap on td.ApplicationID = ap.ApplicationID ";
$sql .= "inner join Agents ag on td.AgentID = ag.AgentID ";
$sql .= "inner join Locations lo on td.LocationID = lo.LocationID ";
$sql .= "where ApplicationName like \'" . $APPLICATION . "\' and "; 
$sql .= "StartTime between \'" . $DAY2 . "\' and \'" . $DAY1 . "\' "; 
$sql .= "order by 1";
# THE EQUIVALENT OF THE SET COMMAND TROUGH THE COMMAND PROMT 
foreach $i (keys %ENV) 
{
print FH "$i : $ENV{$i} \n";
}
#accept a command line parameter 
our $CycleScriptRun_pid = $ARGV[0] ; 


#========================================================== 
#start a Windows process 
use Win32 ; 
use Win32::Process ; 

my $DayCycle_path= $varHolder->{'BASEDIR'} . " DayCycle.exe" ;
if( $varHolder->{VISIBLE_MODE} == 1)
{ Win32::Process::Create( $DayCycle_o, "$DayCycle_path", "" , 0, 
CREATE_NEW_CONSOLE ,$varHolder->{'BASEDIR'}); } 
else
{ Win32::Process::Create( $DayCycle_o, "$DayCycle_path", "" , 0,
CREATE_NO_WINDOW ,$varHolder->{'BASEDIR'}); } 

$DayCycle_pid = $DayCycle_o->GetProcessID() ; 

#==========================================================
#Purpose : to tie a file 
#============================= =============================
use Tie::File ; 
my @file_array = ();
my $file = 'C:/Temp/folder/settings.txt' ; 
tie @file_array , 'Tie::File', $file , memory => 100_000_000 or die "I cannot find the $file" ; 

foreach (@file_array) #foreach line of the file 
{ s/$setting=(\d+)/$setting=$value/; 
}
untie @file_array ; 
#==========================================================
#========================================================== 
# create a nameless hash
#========================================================== 
my $record = #one record for each cycle 
{
APP=> "$csAppName" , 
SCRIPT=> "$psCurrentScript" , 
STEP=> "$psCurrentStep" 
} ;
#========================================================== 
#========================================================== 
#simple  perl regex cheatsheet
#========================================================== 
Operators
m// 'Match' operator
s/// 'Substitute' operator 
tr/// 'Translate' operator 

# Special Characters
. Any single character escept newline n
b Between word and non-word chars, ie: /bcat/b/ matches "cat" but not "scat" 
B NOT between word and non-word chars 
w Word character 
W Non-word character
d Digit
D Non-digit
s White-space
S Non-white-space

# Assertions (Position Definers)
^ Start of the string
$ End of the string

# Quantifiers (Numbers Of Characters) 
n* Zero or more of 'n'
n+ One or more of 'n'
n? A possible 'n'

n{2} Exactly 2 of 'n'
n{2, } At least 2 (or more) of 'n' 
n{2,4} From 2 to 4 of 'n'

# Groupings
() Parenthesis to group expressions
(n/sitebuilder/regex/images/1/a) Either 'n' or 'a'
Character Classes
[1-6] A number between 1 and 6 
[c-h] A lower case character between c and h 
[D-M] An upper case character between D and M
[^a-z] Absence of lower case character between a and z
[_a-zA-Z] An underscore or any letter of the alphabet

Useful  Perl  Snippets
$mystring =~ s/^s*(.*?)s*$/$1/; Trim leading and trailing whitespace from $mystring 
$mystring =~ tr/A-Z/a-z/; Convert $mystring to all lower case
$mystring =~ tr/a-z/A-Z/; Convert $mystring to all upper case 
tr/a-zA-Z//s; Compress character runs, eg: bookkeeper -> bokeper
tr/a-zA-Z/ /cs; Convert non-alpha characters to a single space 


#=============================================================
#Install a perl module from behind a firewalll using ppm
#=============================================================
Example with Compress-Bzip2 

1. Download tar package from the nearest cpan mirror to C:\Temp\TEMP folder (could be other also ; ) 
2. Create Compress-Bzip2.ppd type of file , containging the following: 

<?xml version="1.0" encoding="UTF-8"?> 
<SOFTPKG NAME="Compress-Bzip2" VERSION="2,2,09"> 
<TITLE>Compress-Bzip2</TITLE>
<ABSTRACT>Blah</ABSTRACT>
<AUTHOR>Somebody</AUTHOR>
<IMPLEMENTATION> 
<CODEBASE HREF="file:///C|/Temp/TEMP/Compress-Bzip2-2.09.tar.gz "></CODEBASE>
<INSTALL></INSTALL>
<UNINSTALL></UNINSTALL>
</IMPLEMENTATION>
</SOFTPKG> 

Attention: . Name and codebase NOT C:\ BUT file:///C|

3. Open Dos prompt into the C:\Temp\TEMP (or whichever you prevered in the beginning) 
4. Run the command : 
ppm rep add downloadedTars C:\Temp\A_DOWNLOADS\downloaded _perlmodules 
In order to add the folder to the list of your current ppm repositories 

5. ppm install Compress-Bzip2
In order to install the module from the local folder 

6. ppm rep delete myNewRepository 
In order to remove the repository from the ppm 
#Add company's servers to thte local ppm's repository 
ppm rep add linox1 http://linox.company.com/mirror/cpan/
ppm rep add linox2  ftp://linux.company.com/mirror/cpan/


#sleep for less than second in Windows 
use Win32 ; 
Win32::sleep ($time_in_milliseconds);

#=================================================================== 
#throw proper errro messages while checking the file size 
use File::stat qw(:FIELDS);
#create the obj basic-scala-console-apper for getting the file attributes 
my $st =stat($file) or croak ( "No $stdout : $!"); #die will shut down the program !!!! 
# get the file size 
my $size = $st->size();
$stat_obj =stat($stdout) or die "No $stdout: $!";
#throw proper errro messages ^^^^
($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
$atime,$mtime,$ctime,$blksize,$blocks) 
= stat($filename);
#===================================================================

#================================================================

#get the computername of a computer 
$computername = $ENV{COMPUTERNAME} ; 
#get the username of the a Windows computer
$userName = $ENV{USERNAME} ; 
#get the name of the currrent executing script and ints pid 
print $0 , $$ ; 
#=========================================================== ======== 
#The textpad settings for jump to error for perl scripts File 1 Register 2
^.+at (.+) line ([0-9]+)[.,]?
exec *.pl *.pm *.cgi /s /b do  perl -wc 


#======== Exctract only the name of a file witout the long path 

$file=~m/^.*(\\|\/)(.*)/; # strip the remote path and keep the filename
my $name = $2; 

#PRINT TILL THE END OF A LABLE 

print <<END_HTML;

<html> <head> 
<title>thanks!</title> 
</head> 

<body> 
<p>thanks for uploading your photo!</p> 

<p>your photo:</p> 
<img src="/upload/$filename" border="0"> 

</body> </html> 

END_HTML
# IMPORTANT !!!! IF THERE ARE SPACES IN THE PREVIOUS LINE == SYNTAX ERROR 

#=================================================================== 

#check for file existance and other attributes 
$readfile="myfile.cgi";

if ( (-e $readfile) && (-r $readfile) ) { 
#proceed with your code
}

#================================================================= 
# how-to check my perl installed modules
# perldoc perllocal OR 
# ppm install ExtUtils::Installed save and run this one 
# source  http://www.cpan.org/misc/cpan-faq.html#How_installed_modules 

use ExtUtils::Installed;
my $instmod = ExtUtils::Installed->new();
foreach my $module ($instmod->modules()) 
{
my $version = $instmod->version($module) || "???"; 
print "$module -- $version\n"; 
}
#=================================================================

#How to check version of a module 
perl  -le "use CGI; print $CGI::VERSION"



use Encode ; 
my $fileByteStream = decode('windows-1251', $fileString );
my $UTFSream = encode('UTF-8', $fileByteStream);

print "Read the whole directory for specific types of files " ; 
$dh = DirHandle->new($path) or die "Can't open $path : $!\n";
@files = grep { /\.[ch]$/i } $dh->read();

# START FOREACH LINE 
#SET HERE THE PATH TO THE FILE 
my $inputfile='DD61_STG_OMDW.vwFactUserRegistration.txt' ; 

#READ ALL ROWS OF A FILE TO ALIST 
open (INPUT, "<$inputfile") || print "could not open the file!\n"; 
my @lineArray = <INPUT>;
close INPUT;


#how-to print key values in hashes 
while( my ($key, $value) = each %$refHash) {
print "\n key: $key, value: $value.\n";
}

#<<DOC_END;
The purpose of the script is ... 
DOC_END

use Time::Local ; 
# get a nicely formated time 
my $timestamp = strftime("%d/%m/%y %H:%M:%S", localtime());


# perl defined or operator
$IniFile //= "$ProductVersionDir/conf/$HostName/ini/run-$EnvironmentName.$HostName.ini";


sub urlencode {
my $s = shift;
$s =~ s/ /+/g;
$s =~ s/([^A-Za-z0-9\+-])/sprintf("%%%02X", ord($1))/seg;
return $s;
}

sub urldecode {
my $s = shift;
$s =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;
$s =~ s/\+/ /g;
return $s;
}

=item
This is a multiline doc - /* */ c equivalent
=cut 


my $StringToPrint = "\$sql: $sql" ; 
open(FILEOUTPUT, ">>/data/home/yordang/jpd_profit/data/pw")
|| cluck("could not open the file $! \n");
print FILEOUTPUT $StringToPrint;
close FILEOUTPUT ; 




#how-to slurp file
my $strFile = ();
{
local $/ = undef;
open FILE, "$FileToRead " or cluck("Couldn't open \$FileToRead $FileToRead : $!");
$strFile = <FILE>;
close FILE;
}


my $varToCheck = 0 ; 

# if snippet 
if ( $varToCheck == 0 ) {

} #eof if
else {

}
#eof else 

# the short form on one line 
doSomething() if ( $varToCheck == 0 ) ;    

# start == the difference between exists and defined and exists
my %hash = (
key1 => 'value',
key2 => undef,
);
foreach my $key (qw(key1 key2 key3)) {
print "\$hash{$key} exists: " . (exists $hash{$key} ? "yes" : "no") . "\n";
print "\$hash{$key} is defined: " . (defined $hash{$key} ? "yes" : "no") . "\n";
}
# stop == the difference between exists and defined and exists

{ 'hashes', 'are', 'curly', 'ones' }

[ 'arrays', 'are', 'square' ]

( 'lists are round' )

echo 'https://www.youtube.com/watch?v=vfblUSCaAQk' | perl -MWWW::Mechanize -e '$_ = "https://www.youtube.com/watch?v=vfblUSCaAQk"; s#http://|www\.|youtube\.com/|watch\?|v=|##g; $m = WWW::Mechanize->new; ($t = $m->get("http://www.youtube.com/v/$_")->request->uri) =~ s/.*&t=(.+)/$1/; $m->get("http://www.youtube.com/get_video?video_id=$_&t=$t", ":content_file" => "$_.flv")'
# Purpose
# the pur
# VersionHistory: 
# 1.2.1 --- 2012-11-09 08:11:23 --- ysg --- Module installation instructions refactoring 
# 1.2.0 --- 2012-08-20 16:28:54 --- ysg --- Added urlncode 
# 1.1.0 --- 2012-07-19 19:33:45 --- ysg --- Added module installation instructions 
# 1.0.0 --- 2012-06-18 09:01:29 --- ysg --- Initial version 




#eof: file:PerlCheatSheet.pl