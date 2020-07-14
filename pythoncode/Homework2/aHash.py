import os
import cv2
import numpy as np


def aHashFunc(picpath):
    img_src=cv2.imread(picpath)                 # 原图
    img_resized = cv2.resize(img_src, (8,8))    #调整到8x8
    convertGray = np.array([0.11,0.59,0.3],dtype='float32')
    img_gray = np.inner(img_resized,convertGray) # 转化成灰度图
    avg = np.mean(img_gray)         # 计算平均值
    finger=np.zeros((8,8), dtype=np.int32)
    finger[img_gray>avg] = 1        #比较图像灰度值
    finger=finger.reshape(1,64)
    fingerHex=''
    # 得到信息指纹
    for idx in range(0,64,4):
        #取四个比特，从最高位到最低位
        temp = finger[0,idx:idx+4]
        #转化成十进制整数
        shijinzhi = temp[0]*8+temp[1]*4+temp[2]*2+temp[3]*1
        #将整数转化成十六进制数，字符串格式
        shiliujinzhi = '{:x}'.format(shijinzhi)
        #追加到指纹字符串后面
        fingerHex = fingerHex+shiliujinzhi
    # 返回十六进制哈希值字符串
    return fingerHex


#求文件夹中每一张图片的哈希值，追加结果进文件
def process(src):
    srcPicList = os.listdir(src)
    for pic in srcPicList:
        Hash = aHashFunc(src + pic)
        with open('result/aHash.txt', 'ab+') as f:
            toWrite = '{0}    {1}\n'.format(pic, Hash)
            f.write(toWrite.encode('gbk'))


if __name__ == '__main__':
    process('pictures/')
    process('newPictures/')
