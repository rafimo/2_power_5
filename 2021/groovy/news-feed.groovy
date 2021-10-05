// cli to pull latest 5 stories from Google News RSS Feed and print their titles
// cerner_2tothe5th_2021
def feed = new XmlParser().parse("https://news.google.com/rss?hl=en-US&gl=US&ceid=US:en")

(0..5).each { println feed.channel.item.get(it).title.text() }
