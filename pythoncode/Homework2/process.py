import cv2
import os
src = 'pictures/'
dst = 'newPictures/'
filelist = os.listdir(src)
for file in filelist:
    pic = src+file
    picname = file[:-4]
    img = cv2.imread(pic)
    # imwrite想把图片改成什么格式就把文件扩展名设成什么
    cv2.imwrite(dst+picname+'SrcToPNG.png',img)
    height, width = img.shape[:2]
    # 调整图片大小，第二个参数
    resize1 = cv2.resize(img, (int(width/3.5), int(height/3.5)))
    cv2.imwrite(dst+picname+'Zoom.jpg',resize1)
    cv2.imwrite(dst+picname+'ZoomPNG.png',resize1)
    resize2 = cv2.resize(img, (int(width*2), height))
    cv2.imwrite(dst+picname+'Tensile.jpg',resize2)
    cv2.imwrite(dst+picname+'TensilePNG.png',resize2)
    text = 'WEBSearch'
    pos = (width - 1600, height - 300)
    fontType = cv2.FONT_HERSHEY_COMPLEX
    fontSize = 8
    color = (255, 255, 255)
    bold = 2
    lineType = cv2.LINE_AA
    # 原始图片，水印文本，位置（相对于图片左上角的坐标），字体，文字大小，颜色，文字粗细（直径是多少像素），线型
    # 加中文水印要用到PIL库，看教程 https://blog.csdn.net/qq_37385726/article/details/81975253
    img_watermark = cv2.putText(img, text, pos, fontType, fontSize, color, bold, lineType)
    cv2.imwrite(dst+picname+'Watermark.jpg',img_watermark)
    resize3 = cv2.resize(img_watermark, (int(width/3.5), int(height/3.5)))
    cv2.imwrite(dst+picname+'WatermarkZoomPNG.png',resize3)
    resize4 = cv2.resize(img_watermark, (int(width*2), height))
    cv2.imwrite(dst+picname+'WatermarkTensilePNG.png', resize4)