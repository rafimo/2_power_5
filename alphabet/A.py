# cerner_2^5_2016
# invoke methods that don't exist and beat the test!
import sys
from os.path import basename, splitext
import inspect

class Driver(object):
    def __getattr__(self, method_name):
        def _unknown(arg):
            if arg != 'Z':
                self.take_test(chr(ord(arg) + 1))
            sys.stdout.write(arg)
        return _unknown

Driver().drunk(splitext(inspect.stack()[0][1])[0])
print