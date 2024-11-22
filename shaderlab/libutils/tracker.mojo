from collections import Dict
from python import PythonObject

@value
struct Tracker:
    """
        Abtraction over a dict which functions primarily to track function and variable
        declarations during parsing.
    """    
    var trackers: List[String]
    var dtypes: List[String]

    fn __init__(inout self):
        self.trackers = List[String]()
        self.dtypes = List[String]()
    
    fn addTracker(inout self, ttype: String, name: String, dtype: String) raises:
        if ttype != 'FUNCTION' and ttype != 'VARIABLE':
            raise Error('Unknown Tracker type "' + ttype + '". Supported tracker types are: "Function" and "Variable"!')
        self.trackers.append(name)
        self.dtypes.append(dtype)
     

    fn hasTracker(inout self, tracked_name: PythonObject) raises -> Bool:
        for trkr in self.trackers:
            if trkr[] == str(tracked_name):
                # Tracker Found!
                # Return true!
                return True
        # Loop peacefully exits without terminating the function via returns,
        # tracker not found, return False
        return False

    fn getTrackerType(inout self, tracked_name: PythonObject) raises -> String:
        var i = 0
        for trkr in self.trackers:
            if trkr[] == str(tracked_name):
                break
            i += 1
        var dtype = self.dtypes[i]
        return dtype