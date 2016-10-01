import scala.language.dynamics

// call undeclared methods!
// cerner_2^5_2016
class Alphabet extends Dynamic {
  def applyDynamic(name: String)(char: Char) {
    print(char)
    if (char == 'Z') {
      return
    }
    this.sayNext( (char + 1).toChar)
  }
}

object Main {
  def main(args: Array[String]) {
    new Alphabet().sayA('A')
  }
}