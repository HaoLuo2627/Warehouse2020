# -*- coding: utf-8 -*-
"""
Created on Wed Nov  4 18:45:06 2020

@author: Beau Ding, Hao Luo
"""

import numpy as np
import cv2

_BINARY_ = False                   # 是否运行弹出窗口指定二值化阈值
_HOUGH_CIRCLE_ = True             # 是否运行霍夫变换检测圆
_CONTOUR_ = False                 # 是否运行轮廓检测


def nothing(x):
    pass

# read image into numpy array
img=cv2.imread('1.jpg',0)

if _BINARY_:
    cv2.namedWindow('res')
    cv2.createTrackbar('min','res',0,25,nothing)
    cv2.createTrackbar('max','res',0,25,nothing)
    while(1):
        if cv2.waitKey(1)&0xFF==27:
            cv2.imwrite('canny' + '_' + str(minVal)+'_' + str(maxVal) + '.jpg',canny)
            break
        maxVal = cv2.getTrackbarPos('max','res')
        minVal = cv2.getTrackbarPos('min','res')
        canny = cv2.Canny(img,10*minVal,10*maxVal)
        cv2.imshow('res',canny)

    cv2.destroyAllWindows()
else:
    canny = cv2.Canny(img, 100, 130)

output = img.copy()
shape = img.shape
if _HOUGH_CIRCLE_:
    _H_DEBUG_ = True                  # 是否使用窗口调整霍夫变换minR和maxR参数
    maxCircleRadius = min(shape[0],shape[1])//2
    if _H_DEBUG_:
        cv2.namedWindow('res')
        cv2.createTrackbar('minR', 'res', 0, maxCircleRadius//2, nothing)
        cv2.createTrackbar('maxR', 'res', maxCircleRadius//2, maxCircleRadius, nothing)
        while (1):
            if cv2.waitKey(1) & 0xFF == 27:
                break
            maxR = cv2.getTrackbarPos('maxR', 'res')
            minR = cv2.getTrackbarPos('minR', 'res')
            circles = cv2.HoughCircles(canny, cv2.HOUGH_GRADIENT, dp=1.5, minDist=1,
                                       # param1=15, param2=4,
                                       minRadius=minR, maxRadius=maxR
                                       )
            if circles is not None:
                circles = np.round(circles[0, :]).astype("int")

                for (x, y, r) in circles:
                    cv2.circle(output, (x, y), r, (0, 255, 0), 4)
                    cv2.rectangle(output, (x - 5, y - 5), (x + 5, y + 5), (0, 128, 255), -1)
            cv2.imshow("res", output)
            output = img.copy()

        cv2.destroyAllWindows()
    else:
        circles = cv2.HoughCircles(canny, cv2.HOUGH_GRADIENT, dp=1.5, minDist=1,
                                   #param1=15, param2=4,
                                   minRadius=min(shape[0],shape[1])//20, maxRadius=min(shape[0],shape[1])//2
                                    )
        if circles is not None:
            circles = np.round(circles[0, :]).astype("int")

            for (x, y, r) in circles:
                cv2.circle(output, (x, y), r, (0,255,0), 4)
                cv2.rectangle(output, (x-5,y-5), (x+5,y+5), (0,128,255), -1)

    cv2.imshow("result", np.hstack([img, canny, output]))
    cv2.waitKey(0)

if _CONTOUR_:
    output, contours, hierarchy = cv2.findContours(canny,cv2.RETR_CCOMP,cv2.CHAIN_APPROX_SIMPLE)
    # cv2.drawContours(output,contours,-1,(0,0,255),3)
    for i in range(hierarchy.shape[1]):
        color = np.random.randint(256, size=(1,3))
        cv2.drawContours(output,
                         contours,
                         i,
                         tuple(color.tolist()[0]),
                         thickness=3,
                         hierarchy=hierarchy
                         )
    cv2.imshow("contours", np.hstack([img, output]))
    cv2.waitKey(0)


cv2.destroyAllWindows()
