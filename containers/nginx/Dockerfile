FROM nginx:1.25.3
# RUN rm -f /etc/nginx/conf.d/*
RUN apt -y update && apt -y upgrade
RUN apt install -y init iproute2 procps vim net-tools
# RUN apt install -y certbot && certbot --nginx
# COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
