region="$1"
product="$2"
imageowner="$3"

[[ "$1" == "" ]] && region="cn-hongkong"
[[ "$2" == "" ]] && product="FortiGate.*BYOL.*7.2.4"
[[ "$3" == "" ]] && imageowner="marketplace"

echo get image id from $region for $product
for i in {1..20};

do
        imageid=`aliyun ecs DescribeImages --ImageOwnerAlias=$imageowner --region=$region --RegionId=$region --PageNumber=$i --PageSize=100  | jq '.Images.Image[] | .ImageName +" " +.ImageId + " "+.ProductCode' | grep --ignore-case -e $product ` ;
        [[ -n  "$imageid" ]] && echo $region = "\"$imageid\""
done
