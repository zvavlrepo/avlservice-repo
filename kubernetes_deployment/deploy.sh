#run minikube
minikube start
#deploy from yaml files
kubectl apply -f deployment_service1.yaml
kubectl apply -f deployment_service2.yaml
#create services
kubectl expose deployment avlservice1 --name=avlservice1 --port=8080 --type=NodePort
kubectl expose deployment avlservice2 --name=avlservice2 --port=8080 --type=NodePort
#get url to access avlservice2
a=$(minikube service avlservice2 --url)
echo "Service 2 is accessible on $a"