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
#run minikube
minikube start
#check if running
RUNNING=$(kubectl get pods -o name | grep avlservice)
if [ -n "$RUNNING" ]; then
    kubectl delete svc avlservice1
    kubectl delete svc avlservice2
    kubectl set image deployment avlservice1 avlservice1=zvavltest/avlservice-repo:avlserviceimage1$SERVICE1_VERSION
    kubectl set image deployment avlservice2 avlservice2=zvavltest/avlservice-repo:avlserviceimage2$SERVICE2_VERSION
else
    kubectl apply -f deployment_service1.yaml
    kubectl apply -f deployment_service2.yaml
fi

#create services
kubectl expose deployment avlservice1 --name=avlservice1 --port=8080 --type=NodePort
kubectl expose deployment avlservice2 --name=avlservice2 --port=8080 --type=NodePort
#get url to access avlservice2
a=$(minikube service avlservice2 --url)
echo "Service 2 is accessible on $a"