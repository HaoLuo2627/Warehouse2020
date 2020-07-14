from dHash import dHashFunc
import os
import numpy as np
import copy

def HexStringToArray(HexString):
    # 十六进制HASH字符串转二进制numpy数组
    HexToBinary={'0':[0,0,0,0],'1':[0,0,0,1],'2':[0,0,1,0],'3':[0,0,1,1],\
                 '4':[0,1,0,0],'5':[0,1,0,1],'6':[0,1,1,0],'7':[0,1,1,1],\
                 '8':[1,0,0,0],'9':[1,0,0,1],'a':[1,0,1,0],'b':[1,0,1,1],\
                 'c':[1,1,0,0],'d':[1,1,0,1],'e':[1,1,1,0],'f':[1,1,1,1]}
    Hashnum=[]
    for s in HexString:
        Hashnum.append(HexToBinary[s])
    HashArray = np.asarray(Hashnum)
    HashArray = HashArray.reshape(1,64)
    return HashArray[0]

def takeHammingDis(elem):
    return elem[2]


src = 'pictures/'
# 存储原图
sourcePics = os.listdir(src)
for i in range(len(sourcePics)):
    sourcePics[i] = src+sourcePics[i]
newPic = 'newPictures/'
# 存储新生成图片
newPicList = os.listdir(newPic)
for i in range(len(newPicList)):
    newPicList[i]=newPic+newPicList[i]
# 存储所有的图片
newPicList.extend(sourcePics)
# 计算每张图片的哈希值
for i in range(len(newPicList)):
    pic = newPicList[i]
    picHash = dHashFunc(pic)
    newPicList[i] = [pic, picHash]
# 每张原始图片都找最相似的10张
for sourcepic in sourcePics:
    newList = copy.deepcopy(newPicList)
    # 计算原图hash
    sourceHash = dHashFunc(sourcepic)
    with open('dHashResult.txt', 'a+') as f:
        toWrite = '原图：{0}        哈希值:{1}\n'.format(sourcepic, sourceHash)
        f.write(toWrite)
    # 从列表中移除原图
    newList.remove([sourcepic,sourceHash])
    # 原图片字符串指纹转换成二进制指纹数组
    sourceFinger = HexStringToArray(sourceHash)
    # 将其他的指纹字符串也转化成数组，计算汉明距离（模二和）
    for item in newList:
        picHashNum = HexStringToArray(item[1])
        HammingDis = np.sum((sourceFinger + picHashNum) % 2)
        item.append(HammingDis)
    # 按照距离大小升序排序
    newList.sort(key=takeHammingDis)
    with open('dHashResult.txt','a+') as g:
        g.write('10张最近的图：\n')
        for i in range(10):
            g.write('图片名：{0}    哈希值：{1}    与原图的汉明距离：{2}\n'.format(newList[i][0],\
                                                                  newList[i][1],newList[i][2]))