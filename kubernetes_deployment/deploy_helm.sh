#inputs
while [ $# -gt 0 ]; do
  case "$1" in
    --version_service1=*)
      SERVICE1_VERSION="${1#*=}"
      ;;
    --version_service2=*)
      SERVICE2_VERSION="${1#*=}"
      ;;
    *)
      printf "* Error: "$1" Invalid argument.*\n"
      exit 1
  esac
  shift
done

if [ -z "$SERVICE1_VERSION" ]; then
    SERVICE1_VERSION="v1.0"
fi

if [ -z "$SERVICE2_VERSION" ]; then
    SERVICE2_VERSION="v1.0"
fi
#check if any charts are running
RUNNING=$(helm ls --filter 'avls[0-9]' -q)
if [ -n "$RUNNING" ]; then
    #if running then update app version and image
    helm upgrade avls1 ./service1chart --set=image.tag=avlserviceimage1$SERVICE1_VERSION
    helm upgrade avls2 ./service2chart --set=image.tag=avlserviceimage2$SERVICE2_VERSION
    #else install
else    
    helm install avls1 --set image.tag=avlserviceimage1$SERVICE1_VERSION ./service1chart
    helm install avls2 --set image.tag=avlserviceimage2$SERVICE2_VERSION ./service2chart
fi
#get service2 url
a=$(minikube service avlservice2 --url)
echo "Service 2 is accessible on $a"