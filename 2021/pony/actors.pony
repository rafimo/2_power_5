// actor models in pony - behaviours run asynchronously
// cerner_2tothe5th_2021
actor Main
  new create(env: Env) =>
    let str = "This is a string"
    let count = Count(str)
    Lower("UPPER CASE").lower(env)
    count.count(env)
    Count(str).counter(env)
    
actor Count
  let line: String 
  var _count: USize = 0
  new create(line': String) =>
    line = line'
  
  be count(env: Env) =>
   _count = _count + 1
    env.out.print(line.size().string())
    
  be counter(env: Env) =>
    env.out.print("printing counter " + _count.string())
    
actor Lower
  let line: String 
  new create(line': String) =>
    line = line'
  
  be lower(env: Env) =>
    env.out.print(line.lower()) 
    Count(line).count(env)
