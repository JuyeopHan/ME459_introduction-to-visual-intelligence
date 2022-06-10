#Libraries
#from configparser import Interpolation
from cv2 import INTER_LINEAR
import numpy as np
import cv2 as cv
import matplotlib.pyplot as plt
import copy as copy
import math
import os


""" RIGHT FEATURE FIND FUNCTION """
def findRightFeatures(keyPoints1, keyPoints2, descriptors1, descriptors2):
    
    matcher = cv.DescriptorMatcher_create(cv.DescriptorMatcher_FLANNBASED)
    
    descriptors1 = np.float32(descriptors1)
    descriptors2 = np.float32(descriptors2)
    
    raw_matches = matcher.knnMatch(descriptors1, descriptors2, k=2)
    
    matches = []
    for m in raw_matches:
        if len(m) == 2 and m[0].distance < m[1].distance * 0.55:
            matches.append((m[0].trainIdx, m[0].queryIdx))
    
    if len(matches) > 4:
        
        keyPoints1 = np.float32([keyPoints1[i] for (_, i) in matches])
        keyPoints2 = np.float32([keyPoints2[i] for (i, _) in matches])
        
    else:
        
        keyPoints1 = None
        keyPoints2 = None
        print("The number of right features is not enough.")
        
    return keyPoints1, keyPoints2, matches

"""FUNCTIONS REQUIRED FOR CALCULATING ROTATION ANGLES"""

def homoPixel2Camera(key_pts, K_inv):
    
    dim = len(key_pts)
    key_pts_pixel_homo = np.ones((3, dim))
    key_pts_pixel_homo[0:2,:] = np.transpose(key_pts)
    key_pts_camera_homo = np.matmul(K_inv, key_pts_pixel_homo)
    
    return np.transpose(key_pts_camera_homo[0:2,:])


def transformHomo2Cylinder(key_pts):
    key_pts_cylinder = []
    for i in range(len(key_pts)):
        radius = math.sqrt(1 + key_pts[i,0]*key_pts[i,0])
        theta = math.atan(key_pts[i,0])
        z = key_pts[i,1]/radius
        key_pts_cylinder.append([theta, z])
        
    key_pts_cylinder = np.array(key_pts_cylinder)
    
    return key_pts_cylinder

def cylindricalWarp(img, K):
    """This function returns the cylindrical warp for a given image and intrinsics matrix K"""
    h_,w_ = img.shape[0:2]
    # pixel coordinates
    
    y_i, x_i = np.indices((h_,w_))
    X = np.stack([x_i,y_i,np.ones_like(x_i)],axis=-1).reshape(h_*w_,3) # to homog
    Kinv = np.linalg.inv(K) 
    X = Kinv.dot(X.T).T # normalized coords
    
    # calculate cylindrical coords (sin\theta, h, cos\theta)
    A = np.stack([np.sin(X[:,0]), X[:,1], np.cos(X[:,0])],axis=-1).reshape(w_*h_,3)
    B = K.dot(A.T).T # project back to image-pixels plane
    # back from homog coords
    B = B[:,:-1] / B[:,[-1]]
    # make sure warp coords only within image bounds
    B[(B[:,0] < 0) | (B[:,0] >= w_) | (B[:,1] < 0) | (B[:,1] >= h_)] = -1
    B = B.reshape(h_,w_,-1)
    #B = cv.resize(B, (1100, h_), interpolation = cv.INTER_LINEAR)
    
    img = cv.cvtColor(img,cv.COLOR_BGR2BGRA) # for transparent borders...
    cyl = cv.remap(img, B[:,:,0].astype(np.float32), B[:,:,1].astype(np.float32), cv.INTER_AREA, borderMode=cv.BORDER_TRANSPARENT)
    # warp the image according to cylindrical coords
    return cyl

def cylindricalWarp_disp(img, K):
    """This function returns the cylindrical warp for a given image and intrinsics matrix K"""
    h_,w_ = img.shape[0:2]
    # pixel coordinates
    
    y_i, x_i = np.indices((h_,w_))
    X = np.stack([x_i,y_i,np.ones_like(x_i)],axis=-1).reshape(h_*w_,3) # to homog
    Kinv = np.linalg.inv(K) 
    X = Kinv.dot(X.T).T # normalized coords
    
    # calculate cylindrical coords (sin\theta, h, cos\theta)
    A = np.stack([np.sin(X[:,0]), X[:,1], np.cos(X[:,0])],axis=-1).reshape(w_*h_,3)
    B = K.dot(A.T).T # project back to image-pixels plane
    # back from homog coords
    B = B[:,:-1] / B[:,[-1]]
    # make sure warp coords only within image bounds
    B[(B[:,0] < 0) | (B[:,0] >= w_) | (B[:,1] < 0) | (B[:,1] >= h_)] = -1
    B = B.reshape(h_,w_,-1)
    #B = cv.resize(B, (1100, h_), interpolation = cv.INTER_LINEAR)
    
    #img = cv.cvtColor(img,cv.COLOR_BGR2BGRA) # for transparent borders...
    cyl = cv.remap(img, B[:,:,0].astype(np.float32), B[:,:,1].astype(np.float32), cv.INTER_AREA, borderMode=cv.BORDER_TRANSPARENT)
    # warp the image according to cylindrical coords
    return cyl

def findImgWidthDim(Img):
    min_idx_width = 10000
    max_idx_width = 0
    
    h_,width = Img.shape[:2]

    threshold = 120

    for idx in range(width):
        if Img[350, idx]< threshold:
            min_idx_width = idx + 1
        else:
            break
        
    for idx in range(width):
        if Img[350, width - idx - 1]< threshold:
            max_idx_width = width - idx - 2
        else:
            break
    return min_idx_width, max_idx_width

  
if __name__ == '__main__':
    img = cv.imread("./StereoImages/00007_ref.png")
    h, w = img.shape[:2]
    K = np.array([[2.240664122271071506e+02, 0.000000000000000000e+00, 3.200000000000000000e+02],
                [0.000000000000000000e+00, 2.240664122271071506e+02, 3.200000000000000000e+02],
                [0.000000000000000000e+00, 0.000000000000000000e+00, 1.000000000000000000e+00]])
    mask = 255 * np.uint8(np.ones((640, 640)))
    img_cyl = cylindricalWarp(img, K)
    mask = cylindricalWarp(mask, K)
    mask = cv.cvtColor(mask, cv.COLOR_BGR2GRAY)
    ret, mask = cv.threshold(mask, 254, 255, cv.THRESH_BINARY)
    min_idx_width, max_idx_width = findImgWidthDim(mask)
    img_cyl = cv.copyTo(img_cyl, mask)
    img_cyl = img_cyl[:,:,0:3]
    #new_img = np.uint8(np.zeros((h, max_idx_width - min_idx_width + 1, 3)))
    img_cyl = img_cyl[:, min_idx_width:max_idx_width+1]
    cv.imwrite("image_cyl.png", img_cyl)
    cv.imwrite("mask.png", mask)