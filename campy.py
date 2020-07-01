import numpy as np
import cv2
from pylepton import Lepton
import time
import datetime

for i in range(1,301):
    # Image capture and Normalisation
    with Lepton() as l:
        a,_ = l.capture()
    cv2.normalize(a, a, 0, 65535, cv2.NORM_MINMAX) # extend contrast
    np.right_shift(a, 8, a) # fit data into 8 bits

    # Add Date and Timestamp to Image
    timestamp = time.time()
    stamp = datetime.datetime.fromtimestamp(timestamp).strftime('%d-%m-%Y_%H-%M-%S')

    filename = "capture" + str(i) + stamp + ".jpg"
    cv2.imwrite(filename, np.uint8(a)) # write it!

    # time.sleep(0.1) # Delay

