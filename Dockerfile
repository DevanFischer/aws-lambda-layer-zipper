FROM public.ecr.aws/lambda/python:3.9
RUN yum install -y gcc openssl-devel \
    bzip2-devel libffi-devel gzip \
    make git zip
RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install boto3
ADD package.sh /
ENTRYPOINT ["/package.sh"]