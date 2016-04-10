FROM google/cloud-sdk
RUN apt-get update
RUN apt-get install -y duplicity 
RUN apt-get install -y python-pip
RUN pip install -U boto

ADD boto.cfg.tmpl /.boto
ADD backup.sh /

CMD /backup.sh

