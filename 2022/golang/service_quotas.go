// Describe AWS Service Quotas for AWS EMR service
// Install below dependencies
// 		go get github.com/aws/aws-sdk-go-v2
// 		go get github.com/aws/aws-sdk-go-v2/config
// 		go get github.com/aws/aws-sdk-go-v2/service/servicequotas
//
// Run below in the project directory, once you have authenticated via AWS CLI
//      go run service_quotas.go
// cerner_2tothe5th_2022
package main

import (
  "context"
  "log"
  "github.com/aws/aws-sdk-go-v2/aws"
  "github.com/aws/aws-sdk-go-v2/config"
  "github.com/aws/aws-sdk-go-v2/service/servicequotas"
)

func main() {
  // Load the Shared AWS Configuration (~/.aws/config)
  config, err := config.LoadDefaultConfig(context.TODO())
  if err != nil {
    log.Fatal(err)
  }

  // Create an Amazon S3 service client
  client := servicequotas.NewFromConfig(config)

  // Get the first 50 results for ListServiceQuotasInput for the EMR service
  output, err := client.ListServiceQuotas(context.TODO(), &servicequotas.ListServiceQuotasInput{
    MaxResults: aws.Int32(50), ServiceCode: aws.String("elasticmapreduce"),
  })
  if err != nil {
    log.Fatal(err)
  }

  // loop through the first page and print out the quota key and its value
  for _, object := range output.Quotas {
    log.Printf("key=%s size=%f", aws.ToString(object.QuotaName), aws.ToFloat64(object.Value))
  }
}
