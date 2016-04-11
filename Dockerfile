FROM google/cloud-sdk
RUN apt-get update
RUN apt-get install -y duplicity 
RUN apt-get install -y python-pip
RUN apt-get install -y inotify-tools
RUN pip install -U boto

ADD boto.cfg.tmpl /.boto
ADD backup.sh /

CMD /backup.sh

