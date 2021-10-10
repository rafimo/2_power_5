use feature 'say';

# ascii art for squid logo
# cerner_2tothe5th_2021
my $height = 15;

say (' ' x ($height-1) . 'v'); 
say (' ' x ($height-2) . 'v' x (3)); 
foreach my $i (0 .. $height-1) { 
    say (' ' x ($height-$i-1) . 'v' x (2*$i+1)); 
}
say ' ';
foreach my $i (0 .. $height-1) { 
    say ('v' x ((2*$height)-1) ) ; 
}
say (' ' x ($height-2) . 'v' x (3)); 
say (' ' x ($height-1) . 'v'); 
