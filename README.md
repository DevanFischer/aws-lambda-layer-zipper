# Python 3.9 Layer Generator for AWS Lambda

## Usage

```shell
docker run --rm -v $(pwd):/package devanfischer/aws-lambda-layer-zipper PACKAGE1 PACKAGE2 PACKAGE...
```

**Example:**

`docker run --rm -v $(pwd):/package devanfischer/aws-lambda-layer-zipper numpy pandas requests`

The result is `numpy_pandas_requests.zip` that can be added as a [Lambda Layer](https://aws.amazon.com/blogs/aws/new-for-aws-lambda-use-any-programming-language-and-share-common-components/) or extracted into your existing Lambda deployment package.

A report file `output_report.txt` is also generated summarizing successful and failed installs.

---

### Tested Python 3.9 libraries

This has been designed to work with all Python libraries but has only been tested in with the following Python 3.9 libraries using the [Dockerfile](Dockerfile) provided.

```shell
requests
tqdm
pandas
```

### This project consists of two key components

1. Docker environment mimicking AWS Lambda environment. If you are looking for an advanced Lambda environment replication, take a look at [lambci/docker-lambda](https://github.com/lambci/docker-lambda).
2. Packaging script to build AWS Lambda ready packages from Python 3.9 modules.

### Dockerfile

Pre-made Docker image can be found on Docker Hub https://cloud.docker.com/repository/docker/devanfischer/aws-lambda-layer-zipper

```Docker
FROM public.ecr.aws/lambda/python:3.9
RUN yum install -y gcc openssl-devel \
 bzip2-devel libffi-devel gzip \
 make git zip
RUN python3 -m pip install --upgrade pip \
 && python3 -m pip install boto3
ADD package.sh /
ENTRYPOINT ["/package.sh"]
```

#### Build your own Docker image

```bash
docker build -t aws_lambda_layer_zipper .
```
