package main

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
	"os"
	"time"
)


func main() {

	access_key := "xxxxxxxxxxxxxxxxxxxx" // aws access key
	secret_key := "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" // aws secret key
	end_point := "http://s3.amazonaws.com"

	sess, err := session.NewSession(&aws.Config{
		Credentials:      credentials.NewStaticCredentials(access_key, secret_key, ""),
		Endpoint:         aws.String(end_point),
		Region:           aws.String("us-east-1"),
		DisableSSL:       aws.Bool(true),
		S3ForcePathStyle: aws.Bool(false),
	})

	if err != nil {
		fmt.Printf("Failed to create session,", err)
		os.Exit(-1)
	}

	//if len(os.Args) < 3 {
	//	fmt.Printf("Bucket and file name required \n Usage: %s bucket_name filename",
	//		os.Args[0])
	//	os.Exit(-2)
	//}

	// 第一个参数传递 s3 bucket
	bucket := os.Args[1]
	//第二个参数传递要上传的文件
	filename := os.Args[2]
	// 第三个参数传递上传后文件名 （可选）
	var s3FileName string

	if len(os.Args) == 4 {
		s3FileName = os.Args[3]
	}else {
		s3FileName = filename
	}
	file, err := os.Open(filename)
	if err != nil {
		fmt.Printf("Unable to open file %q, %v", err)
		os.Exit(-3)
	}

	// timeVersion 使用时间标记上传文件版本号
	timeVersion := time.Now().Format("20060102150405")
	defer file.Close()

	uploader := s3manager.NewUploader(sess)

	_, err = uploader.Upload(&s3manager.UploadInput{
		Bucket: aws.String(bucket),
		Key: aws.String("UMSL/" + timeVersion + "/" + s3FileName),
		Body: file,
	})
	if err != nil {
		fmt.Printf("Unable to upload %q to %q, %v", filename, bucket, err)
		os.Exit(-4)
	}

	fmt.Printf("Successfully uploaded %q to %q\n", filename, bucket + "/UMSL/" + timeVersion + "/" + s3FileName)

}
