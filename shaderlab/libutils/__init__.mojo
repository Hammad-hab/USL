from .typing import *
from .utils import *
from .program_source import ProgramSource
from .tracker import *

fn pprint[T:PPrintable](owned targetString: T):
    print(targetString.repr())

alias LOG_MODE_INFO = '\x1b[32mINFO\x1b[0m'
alias LOG_MODE_TRACKER = '\x1b[36m[TRACKER]\x1b[0m'
alias LOG_MODE_DELETION = '\x1b[31m[DELETION]\x1b[0m'

fn log(owned targetString: String, mode:String):
   targetString = targetString.replace('"', '\x1b[32m"')
   targetString = targetString.replace('fragment', '\x1b[35mfragment\x1b[0m')
   targetString = targetString.replace('vertex', '\x1b[35mvertex\x1b[0m')
   print(mode + ": " + targetString)
