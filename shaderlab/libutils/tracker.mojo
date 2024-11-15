from collections import Dict
from python import PythonObject


struct Tracker:
    """
        Abtraction over a dict which functions primarily to track function and variable
        declarations during parsing.
    """    
    var trackers: List[String]

    fn __init__(inout self):
        self.trackers = List[String]()
    
    fn addTracker(inout self, ttype: String, name: String) raises:
        if ttype != 'FUNCTION' and ttype != 'VARIABLE':
            raise Error('Unknown Tracker type "' + ttype + '". Supported tracker types are: "Function" and "Variable"!')
        self.trackers.append(name)
     

    fn hasTracker(inout self, tracked_name: PythonObject) raises -> Bool:
        for trkr in self.trackers:
            if trkr[] == str(tracked_name):
                # Tracker Found!
                # Return true!
                return True
        # Loop peacefully exits without terminating the function via returns,
        # tracker not found, return False
        return False