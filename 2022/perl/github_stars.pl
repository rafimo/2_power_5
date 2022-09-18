# Print top 10 repos from a given Github org sorted by stars
# cerner_2tothe5th_2022

# use CPAN to install below
use feature 'say';
use Net::GitHub;
use Data::Dumper;

my $usage = "Usage: $0 <Github API Token> <Org>";
die "$usage\n" if not defined $ARGV[0] or not defined $ARGV[1];

# Pass in your Public Github token as first argument - for this API anonymous access also works.
my $github = Net::GitHub->new(token => $ARGV[0]);

# Get all repos under given org
%data = ();
while (my $repo = $github->org->next_repos($ARGV[1])) {
    $data{$repo->{name}} = { (  "stars" => $repo->{stargazers_count}, 
                                "lang" => $repo->{language}, 
                                "forks" =>  $repo->{forks}, 
                                "open_issues" => $repo->{open_issues} ) };
}

say ('-' x 90); 
printf "| %-40s | %-20s | %5s | %5s | %6s |\n", "Repository", "Language", "Stars", "Forks", "Issues";
say ('-' x 90); 

# fetch top 10 repos sorted by most stars on Github
foreach my $repo ((sort { $data{$b}{stars} <=> $data{$a}{stars} } keys %data)[0..10]) {
    printf "| %-40s | %-20s | %5d | %5d | %6d |\n", $repo, $data{$repo}{lang}, $data{$repo}{stars}, $data{$repo}{forks}, $data{$repo}{open_issues};
}

# output below .. for cerner org
# ------------------------------------------------------------------------------------------
# | Repository                               | Language             | Stars | Forks | Issues |
# ------------------------------------------------------------------------------------------
# | clara-rules                              | Clojure              |  1097 |   107 |     81 |
# | terra-core                               | JavaScript           |   173 |   133 |     56 |
# | kaiju                                    | Ruby                 |   150 |    24 |     48 |
# | smart-on-fhir-tutorial                   | JavaScript           |   134 |  3572 |     15 |
# | fhir.cerner.com                          | Ruby                 |   114 |    91 |     37 |
# | bunsen                                   | Java                 |   106 |    44 |     25 |
# | clara-examples                           | Clojure              |    84 |    30 |      8 |
# | terra-clinical                           | JavaScript           |    63 |    40 |      9 |
# | terra-framework                          | JavaScript           |    59 |    51 |     23 |
# | canadarm                                 | JavaScript           |    50 |    14 |      7 |
# | ascvd-risk-calculator                    | JavaScript           |    47 |    36 |     18 |
