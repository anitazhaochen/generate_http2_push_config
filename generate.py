#!/usr/bin/python env
# coding:utf8
import os
import re
import configparser


def generate(directory):
    html_files = os.popen("find %s -iname '*.html'"%(directory))
    jspattern = re.compile("/js/src/.+\.js", re.I)
    csspattern = re.compile("/.+?\.css")
    imgpattern = re.compile("(/images/.+?\.(jpg|png|jpeg|svg|gif|tif))")
    for html in html_files:
        html = html.rstrip('\n')
        with open(html) as f:

            context = f.read()
            js = list(set(jspattern.findall(context)))
            css = list(set(csspattern.findall(context)))
            img = list(set([i[0] for i in imgpattern.findall(context)]))
    result = js + css + img
    return result

def generate_main_config(files):
    string = ['location /index.html {']
    for line in files:
        string.append('http2_push %s'%(line))
    string.append('}')

    with open('nginx_http2_push.config', 'w') as f:
        for line in string:
            f.write(line+'\n')






result = generate('/Users/zhaochen/Desktop/studylua/')
generate_main_config(result)
