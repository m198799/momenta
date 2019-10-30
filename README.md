# 目录说明
* 1、terraform 文件下 包含所有 terraform文件，可以给予aws us-west-2 区域创建 jenkins 主机以及umsl需要的node节点（ami只对应 us-west-2）
* 2、golang 文件下 包含Jenkins umsl-build 下使用 aws-s3 脚步，将build 文件同步至 aws s3。umsl-deploy 下使用 Groovy Script 获取之前build 版本信息（使用时间作为标记）
* 3、jenkins 文件下 包含 umsl Jenkinsfile

# jenkins
* 地址	http://100.20.161.37:8080
* umsl-build 负责单元测试 构建 已经构建产物上传至s3
* umsl-deploy 负责将构建产物交付至 umsl node节点

# umsl
* 地址 http://52.39.132.219:8081/services/UMSL

# 备注
* 1、所用信息已经删除使用到的aws key信息