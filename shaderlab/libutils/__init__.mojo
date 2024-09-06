from .Typing import *
from .utils_methods import *

fn pprint[T:PPrintable](owned targetString: T):
    print(targetString.repr())
    