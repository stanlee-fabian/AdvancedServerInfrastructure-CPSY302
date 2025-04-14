#!C:\perl\bin\perl.exe -w
use strict;
use CGI;

my $query = new CGI;


print $query->header( "text/html" );

print <<END_HERE;
<html>
  <head>
    <title>PUBLIC website</title>
  </head>
  <body bgcolor="#FFFFCC">
    <h1>This is a pretty lame Web page</h1>
    <p>But you had to install perl module and figure out the default document, so YAY you!</p>
  </body>
</html>
END_HERE
# must have a line after "END_HERE" or Perl won't recognize
# the token
