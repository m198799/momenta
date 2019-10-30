package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"os"
	"strings"
	"time"
)


func main() {

	access_key := "xxxxxxxx" // aws access key
	secret_key := "xxxxxxxxxxxxxxxxxxxx" // aws secret key
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


	// 第一个参数传递 s3 bucket
	bucket := os.Args[1]
	// 第二个参数 bucket 下目录
	filename := os.Args[2]

	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(30)*time.Second)
	defer cancel()

	service := s3.New(sess)
	out, err := service.ListObjectsWithContext(ctx, &s3.ListObjectsInput{
		Bucket: aws.String(bucket),
		Prefix: aws.String(filename +"/"),
	})

	for _, content := range out.Contents  {
		keyNmae := strings.Split(aws.StringValue(content.Key), "/")
		fmt.Println(keyNmae[1])
		fmt.Println(",")
	}
}
