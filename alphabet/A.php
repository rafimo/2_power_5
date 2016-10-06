<?php
// cerner_2^5_2016
// invoke methods that don't exist and beat the test!
class Driver {
    function __call($name, $arg) {
        $letter = $arg[0];       
        $next = $letter;  
        if ($letter != "Z") {
            (new Driver)->test(++$next);                      
        }
        echo($letter);
    }
}  
(new Driver)->drunk(basename(__FILE__, '.php'));
echo("\n");
?>