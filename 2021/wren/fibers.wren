// cerner_2tothe5th_2021 https://wren.io/try/
// simple program to check palindromes in a set of words
// Fibers are for concurrency - so an attempt to understand those!
var counter = 0
var increment = Fiber.new {
  counter = counter + 1
  System.print(counter)
}

var palindrome = Fiber.new { |words|
  for (word in words) {
    System.print("palindrome:")
    System.print(word[-1..0] == word)
    if (!increment.isDone) {
      increment.call()
    }
  }
  Fiber.yield()
}

var words = [ "aaaa", "adsfdf", "malayalam" ]
var result = palindrome.call(words)
