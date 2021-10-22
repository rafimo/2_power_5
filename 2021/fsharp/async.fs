// async code in F#
// cerner_2tothe5th_2021
open System

let seq = [1; 2; 3; 4]

let sleep ms =
    async{
       printfn "Starting sleep %O" ms
       do! Async.Sleep ms
       printfn "Finished sleep %O" ms
    }

seq
|> List.map sleep          // make a list of async tasks
|> Async.Parallel          // set up the tasks to run in parallel
|> Async.RunSynchronously  // run them
