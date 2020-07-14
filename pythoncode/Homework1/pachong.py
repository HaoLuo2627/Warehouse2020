import os
import time
import re
import sys
def requestHTML(url):
    b=os.popen('curl -sL -w "%{http_code}" -o tmp/abc.txt '+url, 'r')
    shuchu = b.read()
    b.close()
    return shuchu


def main(argv):
	if os.path.exists('tmp') is False:
		os.mkdir('tmp')
	b = 5
	url = 'https://win.bupt.edu.cn/program.do?id=[x]'
	begin=(b-3)*150+1
	# 断点续采
	if len(argv) > 1:
		if argv[1].isdigit():
			begin = int(argv[1])
		else:
			sys.exit('Illegal Breakpoint.')
	end = (b-2)*150+63
	if os.path.exists('tmp/html') is False:
		os.mkdir('tmp/html')
	for x in range(begin, end+1):
		toRequest = url.replace('[x]','%d'%x)
		# 页面访问异常，打印页面id，退出程序
		if requestHTML(toRequest) != '200':
			sys.exit("Error accessing web page id={}！\n".format(x))
		os.system('curl '+toRequest+' -o tmp/html/%d.txt 2> tmp/temp.log'%x)
		
		with open('tmp/html/%d.txt' % x, 'r', encoding='UTF-8') as f:
			wenben = f.read()
		print('Extracting web page id:{} ...'.format(x))
		reg_title = r'<h2 style="display:inline">\s*(.*?)\s*</h2>'
		reg_college = r'<h3 style="display:inline;">\s*&nbsp;(.*?)\s*</h3>'
		reg_en_title = r'<div style="margin-top:-7px;overflow: hidden;white-space: nowrap;text-overflow: ellipsis;">\s*(.*?)\s*</div>'
		reg_info = r'<div style="font-size:17px;line-height:25px;">([\S\s]*?)</div>'
		reg_source = r'var eval_score\s*=\s*\[\{"score":"\d+(\.\d+)?","type":"\d","time":".*?","name":"(.*?)"}'
		title_group = re.search(reg_title, wenben)
		if title_group is not None:
			title = title_group.group(1)
			title = re.sub(r'[\r\n]', ' ', title).replace('&nbsp;',' ').strip()
		else:
			title = ''
			# 没有项目的页面处理
			print('Page id:{} has no project information, ready to collect the next page\n'.format(x))
			print('sleep 3 seconds...\n')
			time.sleep(3)
			continue
		college_group = re.search(reg_college, wenben)
		if college_group is not None:
			college = college_group.group(1)
			college = re.sub(r'[\r\n]', ' ', college).replace('&nbsp;',' ').strip()
		else:
			college = ''
		en_title_group = re.search(reg_en_title, wenben)
		if en_title_group is not None:
			en_title = en_title_group.group(1)
			en_title = re.sub(r'[\r\n]', ' ', en_title).replace('&nbsp;',' ').strip()
		else:
			en_title = ''
		pattern = re.compile(reg_info)
		infos = pattern.findall(wenben)
		if len(infos) != 0:
			info = infos[1]
			#特殊字符处理
			info = re.sub(r'''[^\w,./\'"!?:;，；：<>《》。！？‘’“”()（）\[\]、【】{}&%@$#+=~—*\^-]+''', ' ', info)
			info = re.sub(r'\s+', ' ', info).replace('&nbsp;',' ').strip()
		else:
			info = ''
		source_group = re.search(reg_source, wenben)
		if source_group is not None:
			source = source_group.group(2)
			# 内容是unicode码的字符串转换成对应的内容、编码是utf-8的字符串
			source = source.encode('latin-1').decode('unicode_escape')
			source = re.sub(r'\s+', ' ', source).replace('&nbsp;',' ').strip()
		else:
			source = ''
		id = '%d' % x
		with open('2017210017.txt', 'ab+') as g:
			if x != end:
				toWrite = 'id:{0}\ntitle:{1}\nen_title:{2}\ncollege:{3}\ninfo:{4}\nsource:{5}\n'.format(id, title, en_title,college, info, source)
				# 字符串转换为gbk编码，忽略gbk编码中不存在的字符
				g.write(toWrite.encode('gbk','ignore'))
			else:
				toWrite = 'id:{0}\ntitle:{1}\nen_title:{2}\ncollege:{3}\ninfo:{4}\nsource:{5}'.format(id, title,en_title,college, info,source)
				g.write(toWrite.encode('gbk', 'ignore'))
		print('Page id:{} collection successful！\n'.format(id))
		if x != end:
			print('sleep 3 seconds...\n')
			time.sleep(3)

	Delete('tmp')
	print('Collection finish')

def Delete(folder):
	# 递归删除非空文件夹
	filelist = os.listdir(folder)
	for li in filelist:
		lipath = os.path.join(folder,li)
		if os.path.isdir(lipath):
			Delete(lipath)
		else:
			os.remove(lipath)
	os.rmdir(folder)


if __name__ == '__main__':
	try:
		main(sys.argv)
	except SystemExit as msg:
		print(msg)
