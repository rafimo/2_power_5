## Concurrency in Elixir cerner_2tothe5th_2021
## create async tasks which sleep - trigger them and wait 

[1,3,1,2,3]
|> Task.async_stream(fn(item) ->  IO.puts("starting #{item}") 
	:timer.sleep(item * 1000) 
	IO.puts("finishing #{item}")
	end)
|> Enum.to_list()

IO.puts "done"
