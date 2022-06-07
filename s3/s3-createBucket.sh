#!/bin/bash
echo -n "생성할 버킷의 이름을 입력해 주세요 :: "
read bucket_name
echo -e "$bucket_name으로 버킷 생성을 시작합니다."

# 리전 지정 후 s3 만들기
echo "실행 결과 :: $(aws s3 mb --region ap-northeast-2 "s3://$bucket_name")"

# 퍼블릭 액세스 설정
aws s3api put-public-access-block \
    --bucket $bucket_name \
    --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

# 버켓 정책 설정
aws s3api put-bucket-policy --bucket $bucket_name --policy "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
        {
            \"Sid\": \"PublicReadGetObject\",
            \"Effect\": \"Allow\",
            \"Principal\": \"*\",
            \"Action\": \"s3:GetObject\",
            \"Resource\": \"arn:aws:s3:::$bucket_name/*\"
        }
    ]
}"

# 버켓 정적 호스팅 설정
aws s3 website "s3://$bucket_name" --index-document index.html --error-document index.html



