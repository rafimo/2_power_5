## cerner_2tothe5th_2021
## Crystal - like Ruby but not!
def caps
  print Random.new.rand(65..90).chr
end

def lower
  print Random.new.rand(97..123).chr
end

def digit
  print Random.new.rand(48..57).chr
end

def special
  print Random.new.rand(33..47).chr
end

length = 16

## randomly invoke method via spawn which launches fibers  
## which are concurrently executed
length.times do
  char = case(Random.new.rand(0..3))
    when 0 then spawn caps
    when 1 then spawn lower
    when 2 then spawn digit
    when 3 then spawn special
  end
end

## run other fibers        
Fiber.yield
