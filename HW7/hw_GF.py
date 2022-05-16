# Libraries
import os
import numpy as np
import cv2 as cv
import matplotlib
import time

#1. LOAD VIDEO

    # example
#cap = cv.VideoCapture("./pedestrian_walking.mp4")
    # result
cap = cv.VideoCapture("./result.mp4")
# frame size
frame_size = [cap.get(cv.CAP_PROP_FRAME_HEIGHT), cap.get(cv.CAP_PROP_FRAME_WIDTH)]
step = 16
idx_y, idx_x = np.mgrid[step/2:frame_size[0]:step, step/2:frame_size[1]:step].astype(np.int)
indices = np.stack((idx_x, idx_y), axis = -1).reshape(-1,2)

#2. INITIALIZE OUTUT VIDEO

fourcc = cv.VideoWriter_fourcc(*'DIVX')
    # example
#out = cv.VideoWriter('exmaple_gf.avi', fourcc, 10.0, (int(frame_size[1]), int(frame_size[0])))
    # result
out = cv.VideoWriter('result_gf.avi', fourcc, 20.0, (int(frame_size[1]), int(frame_size[0])))

#3. PARAMETERS
    # Gunnar-Farnback
gf_params = dict( pyr_scale  = 0.5, # ratio for pyramids
                  levels = 3, # number of pyramids
                  winsize = 15, # size of windows
                  iterations = 3, # number of iterations at each pyramid level
                  poly_n = 5, # length of neighboring for polynomial expansions
                  poly_sigma = 1.1, # gaussian std for low pass filter?
                  flags = cv.OPTFLOW_FARNEBACK_GAUSSIAN)

#4. ADDITIONAL INITIALIZATIONS AND PRE-PROCESSING
# first frame and its features
ret, old_frame = cap.read()
old_gray = cv.cvtColor(old_frame, cv.COLOR_BGR2GRAY)

while True:
    ret, frame = cap.read()
    if not ret:
        break
    frame_gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
    
    # calculate optical flow
    flow = cv.calcOpticalFlowFarneback(old_gray, frame_gray, flow=None, **gf_params)

    # visualization of optical flow
    for x, y in indices:
        frame = cv.circle(frame, (x,y), 1, (0, 0, 255), -1)
        dx, dy = flow[y, x].astype(np.int)
        cv.line(frame, (x,y), (x+3*dx, y+3*dy), (0, 0, 255), 2, cv.LINE_AA)
        
    cv.imshow('frame', frame)
    out.write(frame)
    
    #example
    #k = cv.waitKey(100) & 0xff
    #if k == 27:
    #    break
    
    #results
    k = cv.waitKey(10) & 0xff
    if k == 1:
        break
    
    old_gray = frame_gray.copy()
