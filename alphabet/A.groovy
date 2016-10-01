// cerner_2^5_2016
class Driver {
    def methodMissing(String name, def args) {
        def letter = args[0]
        if (letter != "Z") {
            talkBackwards(letter.toCharacter().next().toString());
        }
        print letter
    }
}

new Driver().drunk('A')