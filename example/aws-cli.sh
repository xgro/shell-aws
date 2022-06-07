# aws-cli.sh

#!/bin/bash
source ./var.sh

# git clone 해와서 디펜던시 설치 후 빌드 진행
git clone https://github.com/glen15/sprint-practice-deploy.git
cd sprint-practice-deploy
cd client
npm install
npm run build

# 리전 지정 후 s3 만들기
aws s3 mb --region ap-northeast-2 "s3://$bucket_name" 

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

# html 페이지 설정, index.html
aws s3 website "s3://$bucket_name" --index-document index.html --error-document index.html

# 웹사이트 파일 업로드
aws s3 sync $website_directory "s3://$bucket_name/" 