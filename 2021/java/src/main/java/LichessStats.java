// invoke Lichess API - data is returned in ndjson format - do some exploratory data analysis
// identify how many I fare on lichess!!
// cerner_2tothe5th_2021
// Run with args <your-user-name> <number-of-games-to-analyze>
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.stream.Collectors;
import com.google.gson.Gson;

// response model
class Stats {
    public String status; String getStatus() { return status; } void setStatus(String status) { this.status = status; }
    public Opening opening; public Opening getOpening() { return opening; } void setOpening(Opening opening) { this.opening = opening;}
    public String winner; String getWinner() { return winner; } void setWinner(String winner) { this.winner = winner; }
    static class Opening { String name; String getName() { return name;} void setName(String name) { this.name = name;}}}

public class LichessStats {
  public static void main(String[] args) throws IOException {
      HttpURLConnection con = (HttpURLConnection)(new URL("https://lichess.org/api/games/user/" + args[0] + "?max=" + args[1] + "&opening=true&moves=false")).openConnection();
      con.setRequestProperty("Accept", "application/x-ndjson");
      List<Stats> statistics = new ArrayList<>();
      try(BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), StandardCharsets.UTF_8))) {
          String responseLine;
          while ((responseLine = br.readLine()) != null) {
              Stats stats = new Gson().fromJson(responseLine, Stats.class);
              statistics.add(stats);
              System.out.printf("%10s|%s%n", stats.status, stats.opening.name);}}

      // find out how many times I have started/faced a chess opening
      print("All Games", statistics.stream().collect(Collectors.groupingBy(stat -> stat.opening.name, Collectors.counting())));

      // find out how many games have had a decisive win over the board
      print("Wins By Opening", statistics.stream().filter(stat -> (new ArrayList<>(Arrays.asList("mate", "resign"))).contains(stat.status)).collect(Collectors.groupingBy(stats -> stats.opening.name, Collectors.counting())));

      // find out how many times which color won either by checkmate or resignation
      print("Wins By Color", statistics.stream().filter(stat -> (new ArrayList<>(Arrays.asList("mate", "resign"))).contains(stat.status)).collect(Collectors.groupingBy(stats -> stats.winner, Collectors.counting())));

      // stats by result
      print("Stats by outcome", statistics.stream().collect(Collectors.groupingBy(stats -> stats.status, Collectors.counting())));
  }

  static void print(String text, Map<String, Long> map) {
      System.out.printf("======================== %s ===================%n", text);
      map.entrySet().stream().sorted(Map.Entry.comparingByValue(Comparator.reverseOrder())).forEach(System.out::println);}}
