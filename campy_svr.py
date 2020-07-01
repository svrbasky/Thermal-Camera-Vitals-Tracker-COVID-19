import numpy as np
import cv2
from pylepton import Lepton
import time
import datetime

class thermalFrame:

    newFrame = []       # New Frame captured from FLIR camera. Frame is a 2D list
    FrameId = ""        # Frame ID is the frame number used as suffix for image names
    TimeList = []       # List of TimeStamps
    TempList = []       # List of average Temperature per Frame

    def __init__(self):
        self.newFrame = [] # Contains current frame (Single frame (2D array) at a time)
        self.TimeList = [] # Full Arrays (useful after full execution)
        self.TempList = [] # Full Arrays (useful after full execution)
        self.FrameId = 0   #  Contains current frame ID (Single)

    def captureFrame(self):
        a,_ = Lepton().capture()
        cv2.normalize(a, a, 0, 65535, cv2.NORM_MINMAX) # extend contrast
        np.right_shift(a, 8, a) # fit data into 8 bits
        cv2.imwrite("capture"+str(self.FrameId)+".jpg", np.uint8(a)) # write it!
        self.FrameId = self.FrameId+1
        self.newFrame = a

    def processData(self):
        if(len(self.newFrame) != 0):
            self.TempList.append(np.mean(self.newFrame))
            ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S:%f")[:-3] # selects the milli seconds and drops the microseconds from time.
            self.TimeList.append(ts)
            self.newFrame = []

def main():

    l = thermalFrame()

    for i in range(1,301):
        l.captureFrame()
        l.processData()
        time.sleep(0.1) # Delay

    print(l.TimeList) # Print entire timelist to check the frame rate
    print(l.FrameId) # Print entire frame IDs to debug

if __name__== "__main__":
  main()
