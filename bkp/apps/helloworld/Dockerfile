FROM busybox
ADD index.html /www/index.html
EXPOSE 8008
CMD httpd -p 8008 -h /www; tail -f /dev/null