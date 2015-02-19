# ansible-qiime

Ansible role for setting up docker container with basic installation of QIIME 1.9.0.

## Usage
Create & tag image:
```
docker build -t nuada/qiime-1.9.0 .
docker tag nuada/qiime-1.9.0:latest nuada/qiime-1.9.0:$(date +%F)
```

Create container:
```
mkdir tmp
chmod 1777 tmp
docker run -it --name qiime \
	--volume=/data:/data \
	--volume=/rawdata:/rawdata \
	--volume=/resources:/resources \
	--volume=$(pwd)/tmp:/tmp \
	nuada/qiime-1.9.0
```
