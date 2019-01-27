# HTTP/2 Server Push 

[NGINX 1.13.9](http://nginx.org/en/download.html), released on February 20, 2018, includes support for HTTP/2 server push. For NGINX Plus users, HTTP/2 server push support will be included in the upcoming NGINX Plus R15 release, scheduled for April 2018.



Base on Nginx

# Configuring HTTP/2 Server Push

```nginx
server {
    # Ensure that HTTP/2 is enabled for the server        
    listen 443 ssl http2;

    ssl_certificate ssl/certificate.pem;
    ssl_certificate_key ssl/key.pem;

    root /var/www/html;

    # whenever a client requests demo.html, also push
    # /style.css, /image1.jpg and /image2.jpg
    location = /demo.html {
        http2_push /style.css;
        http2_push /image1.jpg;
        http2_push /image2.jpg;
    }
}
```

[Nginx offical about http2_push ](https://www.nginx.com/blog/nginx-1-13-9-http2-server-push/)





## 体验以及实践

基于 [OpenResty](https://openresty.org/cn/)，编写了 lua 脚本简单的实现对静态网站如 hexo 的自动 http2_push 支持。

[OpenResty](https://openresty.org/cn/) 是什么？ 

[OpenResty](https://openresty.org/cn/) 是可以通过 lua 语言进行 nginx 扩展的 nginx 。

[OpenResty](https://openresty.org/cn/)



## 环境

Nginx 对于 http2 push 有两种方法：

## Automatically Pushing Resources to Clients

In many situations, it’s inconvenient – or even impossible – to list the resources you wish to push in the NGINX configuration file. For this reason, NGINX also supports the convention of intercepting [`Link` preload headers](https://w3c.github.io/preload/#server-push-http-2), then pushing the resources identified in these headers. To enable preload, include the `http2_push_preload`directive in the configuration:

```nginx
server {
    # Ensure that HTTP/2 is enabled for the server        
    listen 443 ssl http2;

    ssl_certificate ssl/certificate.pem;
    ssl_certificate_key ssl/key.pem;

    root /var/www/html;

    # Intercept Link header and initiate requested Pushes
    location = /myapp {
        proxy_pass http://upstream;
        http2_push_preload on;
    }
}
```

For example, when NGINX is operating as a proxy (for HTTP, FastCGI, or other traffic types), the upstream server can add a `Link` header like this to its response:

```
Link: </style.css>; as=style; rel=preload
```



## Configuring HTTP/2 Server Push

To push resources along with a page load, use the `http2_push` directive as follows:

```nginx
server {
    # Ensure that HTTP/2 is enabled for the server        
    listen 443 ssl http2;

    ssl_certificate ssl/certificate.pem;
    ssl_certificate_key ssl/key.pem;

    root /var/www/html;

    # whenever a client requests demo.html, also push
    # /style.css, /image1.jpg and /image2.jpg
    location = /demo.html {
        http2_push /style.css;
        http2_push /image1.jpg;
        http2_push /image2.jpg;
    }
}
```



## 我的博客做实验

因为基于 hexo。

源文件备份 github master 分支。

dev 分支存放生成的静态文件。

为了访问速度快一点，部署一份到阿里云上面，通过 OpenResty 来做静态文件服务器。

但是，由于 OpenResty 的最新版本，并不支持 http2 push 。

所以，将最新的 Nginx 编译进去 OpenResty 的一些常用库，然后再用 lua 进行开发。

此项目，只是简单的一个实验，通过正则表达式，Nginx 处理的某个阶段，手动为其添加 

Link 头，然后再开启 Nginx 的 http2_push_preload on; 进行主页的一个简单的推送。



## 发现的问题

http2 定义了10种不同的帧。

如果同一次推送的文件数量超过 10 个，速度不仅不会提升还会下降。

并且，推送的同时，那些没有经过推送的文件，加载速度明显变长了。（不知道是不是服务器带宽的问题）

