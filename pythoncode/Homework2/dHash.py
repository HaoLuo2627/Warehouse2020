import os
import cv2
import numpy as np


def dHashFunc(picpath):
    img_src=cv2.imread(picpath)                 # 原图
    width = 9
    height = 8
    img_resized = cv2.resize(img_src, (width, height))    #调整到9x8，宽x高
    convertGray = np.array([0.11,0.59,0.3],dtype='float32')
    img_gray = np.inner(img_resized,convertGray) # 转灰度图
    img_diff = np.zeros((8,8),dtype=np.float32)
    # 计算差异值，左边的像素值减右边
    for idx in range(width-1):
        img_diff[:,idx] = img_gray[:,idx]-img_gray[:,idx+1]
    finger=np.zeros((8,8), dtype=np.int32)
    # 左边的像素比右边亮，记1
    finger[img_diff>0] = 1
    finger=finger.reshape(1,64)
    #得到信息指纹
    fingerHex=''
    for idx in range(0,64,4):
        temp = finger[0,idx:idx+4]
        shijinzhi = temp[0]*8+temp[1]*4+temp[2]*2+temp[3]*1
        shiliujinzhi = '{:x}'.format(shijinzhi)
        fingerHex = fingerHex+shiliujinzhi
    return fingerHex


#求文件夹中每一张图片的哈希值，追加结果进文件
def process(src):
    srcPicList = os.listdir(src)
    for pic in srcPicList:
        Hash = dHashFunc(src + pic)
        with open('result/dHash.txt', 'ab+') as f:
            toWrite = '{0}    {1}\n'.format(pic, Hash)
            f.write(toWrite.encode('gbk'))


if __name__ == '__main__':
    process('pictures/')
    process('newPictures/')