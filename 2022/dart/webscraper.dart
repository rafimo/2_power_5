// scrape through the 2^5 submissions site and print org names and their count!
// cerner_2tothe5th_2022
// run as:
//    dart run 2022/dart/webscraper.dart -s http://2tothe5th-site/
import 'package:web_scraper/web_scraper.dart';
import 'package:sprintf/sprintf.dart';
import 'package:args/args.dart';

void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('site', abbr: 's', help: "Site to parse");
  ArgResults argResults = parser.parse(args);
  print("Site to parse - ${argResults['site']}");

  final webScraper = WebScraper(argResults['site']);
  // wait for page to load
  if (await webScraper.loadWebPage('/')) {
    // fetch the table on the right and parse it
    List<Map<String, dynamic>> elements = webScraper
        .getElement('div.right > table > tbody > tr > td > a', ['href']);

    List<Map<String, dynamic>> rank = webScraper.getElement(
        "div.right > table > tbody > tr > td[class^='b']", ['href']);

    for (var i = 0; i < elements.length; i++) {
      print(sprintf('%20s %s',
          [elements[i]['attributes']['href'].split("/")[3], rank[i]['title']]));
    }
  }
}
