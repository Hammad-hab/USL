from collections import Dict
from python import PythonObject

alias TYPE_UNDERTERMINED = 'tp_undeter'

@value
struct Tracker:
    """
        Abtraction over a dict which functions primarily to track function and variable
        declarations during parsing.
    """    
    var trackers: List[String]
    var dtypes: List[String]
    var tracker_types: List[String]

    fn __init__(inout self):
        self.trackers = List[String]()
        self.dtypes = List[String]()
        self.tracker_types = List[String]()
    
    fn addTracker(inout self, ttype: String, name: String, dtype: String) raises:
        if ttype != 'FUNCTION' and ttype != 'VARIABLE':
            raise Error('Unknown Tracker type "' + ttype + '". Supported tracker types are: "Function" and "Variable"!')
        self.trackers.append(name)
        self.dtypes.append(dtype)
        self.tracker_types.append(ttype)

    fn removeTracker(inout self, target: String):
        var i = 0
        for tracker in self.trackers:
            var tracker_deref = tracker[]
            if tracker_deref == target:
                break
            i += 1
        _ = self.trackers.pop(i);
        _ = self.tracker_types.pop(i);
        _ = self.dtypes.pop(i);

    fn hasTracker(inout self, tracked_name: PythonObject) raises -> Bool:
        for trkr in self.trackers:
            if trkr[] == str(tracked_name):
                # Tracker Found!
                # Return true!
                return True
        # Loop peacefully exits without terminating the function via returns,
        # tracker not found, return False
        return False

    fn copyTo(inout self, owned targetTracker: Tracker) raises -> Tracker:
        var i = 0
        for tracker in self.trackers:
            var ttype = self.tracker_types[i]
            var dtype = self.tracker_types[i]
            var tracker_deref = tracker[]
            targetTracker.addTracker(ttype, tracker_deref, dtype)
            i += 1
        return targetTracker
        ...
    fn getTrackerType(inout self, tracked_name: PythonObject) raises -> String:
        var i = 0
        for trkr in self.trackers:
            if trkr[] == str(tracked_name):
                break
            i += 1
        var dtype = self.dtypes[i]
        return dtype


    fn repr(inout self) -> String:
        var repr: String = "Tracker {\n"
        var i = 0
        for tracker in self.trackers:
            var ttype = self.tracker_types[i]
            var dtype = self.tracker_types[i]
            var tracker_deref = tracker[]
            repr += "\t" + tracker_deref +"(" + ttype + "): " + dtype + "\n" 
            i += 1
        repr += '\n}'
        return repr 
        ...

@value
struct Shader():
    ...