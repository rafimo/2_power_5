// cerner_2tothe5th_2022 https://wren.io/try/
// simple program to convert text to Morse code
// converting upper case to morse code
var charToMorse = {
    "A": ".-",      "B": "-...",     "C": "-.-.",    "D": "-..",
    "E": ".",       "F": "..-.",     "G": "--.",     "H": "....", 
    "I": "..",      "J": ".---",     "K": "-.-",     "L": ".-..", 
    "M": "--",      "N": "-.",       "O": "---",     "P": ".--.",
    "Q": "--.-",    "R": ".-.",      "S": "...",     "T": "-",
    "U": "..-",     "V": "...-",     "W": ".--",     "X": "-..-",
    "Y": "-.--",    "Z": "--.."
}

// define a wren function
var textToMorse = Fn.new { |text|
    var output = ""
    for (char in text) {
        if (char == " ") {
            output = output + (" " * 7)
        } else {
            var morse = charToMorse[char]
            if (morse) { 
                output = output + morse.join(" ") + "   "
            }
        }
    }
    return output.trimEnd()
}

var morse = textToMorse.call("ORACLE CERNER")
System.print(morse) // print to terminal
