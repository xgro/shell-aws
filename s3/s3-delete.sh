#!/bin/bash
echo 삭제할 버킷 이름을 선택해주세요
select $() 
bucket_name="xgro"

aws s3 rb s3://$bucket_name