set -x

APP_NAME=$1
ENV=$2

echo "Finding and replacing app-name wherever necessary"
find ./ -name ".DS_Store" -type f -delete
find ./ -type f -exec sed -i '' -e 's/app-name/'${APP_NAME}'/g' {} +
mv ./charts/app-name ./charts/${APP_NAME}

echo  "Moving chart to the root folder"
mv ./charts ../../

cd ../../

echo "Merging application values.yaml with base values.yaml"
if [ -z ${ENV} ]; then
    yq m -i values.yaml charts/${APP_NAME}/values.yaml
else
    yq m -i values-${ENV}.yaml charts/${APP_NAME}/values.yaml
    mv values-${ENV}.yaml values.yaml
fi

echo "Setting app name in values.yaml"
sed -i -e "s/appName: .*/appName: ${APP_NAME}/g" values.yaml


echo "Checking for internal services"
if grep "type: internal" values.yaml
then
    echo "Internal service exists"
else
    echo "Internal service does not exist"
    rm ./charts/${APP_NAME}/templates/ingress-internal.yaml
    rm ./charts/${APP_NAME}/templates/service-internal.yaml
fi

echo "Checking for VPN services"
if grep "type: vpn" values.yaml
then
    echo "VPN service exists"
else
    echo "VPN service does not exist"
    rm ./charts/${APP_NAME}/templates/ingress-vpn.yaml
    rm ./charts/${APP_NAME}/templates/service-vpn.yaml
fi


if grep "type: external" values.yaml
then
    echo "External service exists"
else
    echo "External service does not exist"
    rm ./charts/${APP_NAME}/templates/ingress-external.yaml
    rm ./charts/${APP_NAME}/templates/service-external.yaml
fi

if grep "type: loadbalancer" values.yaml
then
    echo "loadbalancer service exists"
else
    echo "loadbalancer service does not exist"
    rm ./charts/${APP_NAME}/templates/service-loadbalancer.yaml
fi

echo "Values.yaml:\n"
cat values.yaml

echo "Moving values.yaml inside the charts folder"
mv values.yaml ./charts/${APP_NAME}/values.yaml
