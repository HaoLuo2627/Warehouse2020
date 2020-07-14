import os
import cv2
import numpy as np
'''实现DCT变换，参考资料：
https://blog.csdn.net/James_Ray_Murphy/article/details/79173388?depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-2'''
def myDCT(img):
    m,n=img.shape
    X=np.zeros(img.shape)
    dst=np.zeros(img.shape)
    X[0,:]=np.sqrt(1/n)
    for i in range(1,m):
        for j in range(n):
            X[i,j]=np.cos(i*(2*j+1)*np.pi/(2*n))*np.sqrt(2/n)
    dst = np.dot(X, img)
    dst = np.dot(dst,X.T)
    return dst


def pHashFunc(picpath):
    img_src=cv2.imread(picpath)                 # 原图
    img_resized = cv2.resize(img_src, (32,32))    #调整到32x32
    convertGray = np.array([0.11,0.59,0.3],dtype='float32')
    img_gray = np.inner(img_resized,convertGray) # 转灰度图
    #img_dct=cv2.dct(img_gray)
    img_dct = myDCT(img_gray)             #计算DCT，我使用的是自己定义的方法
    img_dct_resized = img_dct[0:8,0:8]      #缩小DCT
    avg = np.mean(img_dct_resized)          #计算平均值
    #进一步减小DCT，二值化
    finger=np.zeros((8,8), dtype=np.int32)
    finger[img_dct_resized>avg] = 1
    finger=finger.reshape(1,64)
    #得到信息指纹
    fingerHex=''
    for idx in range(0,64,4):
        temp = finger[0,idx:idx+4]
        shijinzhi = temp[0]*8+temp[1]*4+temp[2]*2+temp[3]*1
        shiliujinzhi = '{:x}'.format(shijinzhi)
        fingerHex = fingerHex+shiliujinzhi
    #返回十六进制哈希值字符串
    return fingerHex


#求文件夹中每一张图片的哈希值，追加结果进文件
def process(src):
    srcPicList = os.listdir(src)
    for pic in srcPicList:
        Hash = pHashFunc(src + pic)
        with open('result/pHash.txt', 'ab+') as f:
            toWrite = '{0}    {1}\n'.format(pic, Hash)
            f.write(toWrite.encode('gbk'))


if __name__ == '__main__':
    process('pictures/')
    process('newPictures/')