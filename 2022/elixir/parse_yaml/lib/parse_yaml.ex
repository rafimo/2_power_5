# parse an yaml file and print out all top level elements which contain the search string within them..
# given a file like below searching for roam-11-22 will print service1 and service2
# cerner_2tothe5th_2022
# hi/service-1:
#  roam:
#  - roam-XX-YY
#  - roam-11-22
# hi/service-2:
#  roam:  
#  - roam-11-22
#  - roam-33-44
defmodule ParseYaml do
  use Application

  def start(_type, _args) do 

    yaml_map = File.cwd!
                |> Path.join("lib/file_to_parse.yaml")
                |> YamlElixir.read_from_file
                |> elem(1)

    for {k, v} <- yaml_map do
      if Enum.member?(v["roam"], "roam-11-22") do
        IO.puts "found match - #{k}"
      end
    end
    
    # just to run this a script
    Task.start(fn -> :timer.sleep(1000); IO.puts("done sleeping") end)
  end
end
