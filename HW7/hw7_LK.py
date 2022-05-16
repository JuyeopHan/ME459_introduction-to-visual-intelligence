# Libraries
import os
import numpy as np
import cv2 as cv
import matplotlib
import time

#1. LOAD VIDEO

    # example
cap = cv.VideoCapture("./pedestrian_walking.mp4")
    # result
#cap = cv.VideoCapture("./result.mp4")
# frame size
frame_size = [cap.get(cv.CAP_PROP_FRAME_HEIGHT), cap.get(cv.CAP_PROP_FRAME_WIDTH)]

#2. INITIALIZE OUTUT VIDEO

fourcc = cv.VideoWriter_fourcc(*'DIVX')
    # example
out = cv.VideoWriter('exmaple_lk.avi', fourcc, 10.0, (int(frame_size[1]), int(frame_size[0])))
    # result
#out = cv.VideoWriter('result_lk.avi', fourcc, 20.0, (int(frame_size[1]), int(frame_size[0])))

#3. PARAMETERS
num_corners = 150
    # Shi-Tomasi feature detection
feature_params = dict( maxCorners = num_corners,
                       qualityLevel = 0.05,
                       minDistance = 14,
                       blockSize = 9 )

    # LK algorithm
lk_params = dict( winSize  = (20, 20),
                  maxLevel = 5,
                  criteria = (cv.TERM_CRITERIA_EPS | cv.TERM_CRITERIA_COUNT, 10, 0.03))

#4. ADDITIONAL INITIALIZATIONS AND PRE-PROCESSING

    # colors for selected features
color = np.random.randint(0, 255, (num_corners, 3))

    # first frame and its features
ret, old_frame = cap.read()
old_gray = cv.cvtColor(old_frame, cv.COLOR_BGR2GRAY)
p0 = cv.goodFeaturesToTrack(old_gray, mask = None, **feature_params)

    # Create a mask image for drawing purposes
mask = np.zeros_like(old_frame)

while True:
    
    ret, frame = cap.read()
    if not ret:
        break
    frame_gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
    
    
    # calculate optical flow
    p1, st, err = cv.calcOpticalFlowPyrLK(old_gray, frame_gray, p0, None, **lk_params)
    
    # select good points
    if p1 is not None:
        good_new = p1[st==1]
        good_old = p0[st==1]
        
    # visualization of optical flow
    for i, (new, old) in enumerate(zip(good_new, good_old)):
        a, b = new.ravel()
        c, d = old.ravel()
        mask = cv.line(mask, (int(a), int(b)), (int(c), int(d)), color[i].tolist(), 2)
        frame = cv.arrowedLine(frame, (int(c), int(d)), (int(c) + 3*(int(a)-int(c)),int(d) + 3*(int(b)-int(d))), color[i].tolist(), 2)
    img = cv.add(frame, mask)
    
        
    cv.imshow('frame', img)
    out.write(img)
    
    #example
    k = cv.waitKey(100) & 0xff
    if k == 27:
        break
    
    #results
    #k = cv.waitKey(10) & 0xff
    #if k == 1:
    #    break
    
    # Now update the previous frame and previous points
    old_gray = frame_gray.copy()
    p0 = good_new.reshape(-1, 1, 2)
