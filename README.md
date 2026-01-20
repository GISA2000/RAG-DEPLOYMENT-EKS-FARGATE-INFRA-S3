©️ Giovanni Sanders

# RAG-DEPLOYMENT-EKS-FARGATE-INFRA-S3

Retrieval-augmented generation (RAG) is a way for AI to retrieve data from external sources and provide relevant information to the user based on that data. 

We have developed an AI RAG chatbot system that is capable of analyzing documents and answering all kinds of questions about the document to the end user. Do you have a large document that needs to be reviewed, but don't have the time to do so? Or do you want a quick summary of something? Ask our AI RAG system and you will get the answer you need, saving you time. This Repository will explain how you can apply RAG in an AWS environment.

At the end of this instruction, you will have the following that you can use:

- A frontend with a chatbot to analyze your documents,
- upload your own documents for analysis,
- An AI chatbot that can answer all questions about your document,
- LLM (Large Language Model) checks in place to not answer on inappropriate/illegal questions,
- Ask questions in different languages Like Dutch or English,

## prerequisite for deployment RAG on AWS

In order to successfully apply RAG within your AWS environment, its application has been divided into the 3 stages below. Each stage must be completed in order for the RAG Chatbot to become functional. Make sure you have the following before you start applying RAG, otherwise you will not be able to follow the steps in these instructions. 

- [ ] [AWS CLI installed](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and logged in with you AWS profile,
- [ ] [Terraform installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and configured, 
- [ ] Installed kubectl to interact with the Kubernetes cluster,
- [ ] OpenSSL installed to generate Self-Signed HTTPS Certificates 🔏


For more information how to setup the above, please use the hyperlinks provided.

##  Chapter 1: Stage 1 Infrastructure creation 
> [!WARNING]
> The following chapters show how you can apply RAG to your AWS environment. When applying RAG, various network components and parts will be created in your environment. This may incur AWS costs.Please apply Cost Management in your environment to prevent costs from escalating. Hosting RAG and the associated costs are your own responsibility.

Stage 1 is responsible for creating the necessary infrastructure on AWS so that RAG can be hosted. When Stage 1 is complete, you will automatically have created the following via Terraform. 

✅ VPC (Virtual Private Cloud) <br>
✅Private and Public subnets in diffrent AZ (availability zones) <br>
✅And more network components to make RAG work

1. Open de Ternimal in je favorite IDE and first download the folder structure of this repository with the following command:

```
git clone https://github.com/GISA2000/RAG-DEPLOYMENT-EKS-FARGATE-INFRA-S3
```

After executing the above command, the repo should consist of the following folder structure. 
```
RAG-DEPLOYMENT-EKS-FARGATE-INFRA-S3
    └───Terraform
        ├───stage-1-vpc-creation
        ├───stage-2-cluster-creation
        └───stage-3-cluster-config
            └───k8s
                ├───deployments
                
                ├───namespaces
                ├───secrets
                └───services
```
2. Navigate to the **“stage-1-vpc-creation”** folder and run Terraform Init to prepare Terraform for automation.
```
terraform init
```
You should get the output below. If not, make sure Terraform is installed correctly. 

```
Terraform has been successfully initialized!
```
3. Now apply Terraform Apply to create the necessary infrastructure for RAG on your AWS environment.
```
terraform apply
```
When Asked if you want to peform the actions, type yes and click on enter

<img width="504" height="119" alt="image" src="https://github.com/user-attachments/assets/e608ac72-12cc-4b43-9c0a-38a83cf3edd4" />

> [!IMPORTANT]
> If Terraform Apply fails, make sure that [AWS CLI is configured](https://docs.aws.amazon.com/signin/latest/userguide/command-line-sign-in.html) and that you are logged in.
> 

If you have not received any errors, you can proceed with the next steps. If you now go to the “AWS Management Console,” **“rag-vpc”** should appear.  

<img width="1665" height="247" alt="image" src="https://github.com/user-attachments/assets/c7c03e57-4e56-46f4-b5bf-b8d3c1721c90" />

Now after this you are ready to proceed to **Stage 2 cluster creation**

## Chapter 2: Stage 2 Cluster Creation

Thanks to Stage 1, the necessary infrastructure has been implemented in AWS. The next step is to create the EKS Kubernetes cluster. To achieve this, Terraform will perform the following actions in stage 2.

 - [x] Create aws-load-balancer-controller-policy,
 - [x] Create AmazonEKSLoadBalancerControllerRole,
 - [x] Connect the Policy aws-load-balancer-controller-policy to the role above.
 - [x] Creates a oidc Provider for the ALB (Application-Load-Balancer) to connect to the EKS Cluster,
 - [x] Create the Cluster it self,
 - [x] Configured Fargate Profiles to run the RAG pods,

4. Navigate to the **"stage-2-cluster-creation"** folder
```
cd ..
cd .\stage-2-cluster-creation\
```

### Create the EKS Kubernetes cluster 
5. Peform Terraform Init and Apply just like you did in [chapter 1](#chapter-1-stage-1-infrastructure-creation) by step 2 & 3.

After this you should get a response back from Terraform that the cluster has being created like the example below: 
```hcl
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
```
6. Check if the cluster actually exist. In AWS Management Console navigate to **"EKS>Clusters"** you must see the cluster **"rag_eks_fargate_cluster"** just as the example below .
   <img width="1558" height="237" alt="image" src="https://github.com/user-attachments/assets/bab2bdd9-affa-4230-9021-085336fa4fe9" />

  Next open the cluster and go **"Compute>Fargate Profiles"** you must see 2 namespaces: **"default"** and **"rag-namespaces"**. 
<img width="1583" height="240" alt="image" src="https://github.com/user-attachments/assets/9be989cf-27d3-4bf3-8597-7863c0bc1bfb" />

> [!CAUTION]
> Do not continue the until the Fargate Profiles are ready. Without the Profiles RAG cannot be deployed!!!

### Configure IAM Permissions

7. After the cluster creation you do not have enough permisson to see what resources EKS is using. To alllow you to view the resources of the cluster, IAM permissions on the cluster side must be configured.

Please go to **"Access"** tab in the cluster and click on the **Create button**.     

<img width="1533" height="331" alt="image" src="https://github.com/user-attachments/assets/e1106def-db4a-4025-bcd9-1d5490dfc84e" />

Please select your AWS IAM principal username.

<img width="1495" height="355" alt="image" src="https://github.com/user-attachments/assets/e18e5796-d20f-48c4-b04f-efbf333de96a" />

Go to the next page and make sure that you have select the following policy: **"AmazonEKSClusterPolicy"**. This policy will give you full acces the cluster assuming you are the owner of the cluster. 

<img width="1492" height="660" alt="image" src="https://github.com/user-attachments/assets/f611177c-1484-4cd8-af02-1eccb6427da1" />

Now go back to  **"Access"** tab and verify that the policy is attached to your AWS account. 



<img width="1498" height="607" alt="image" src="https://github.com/user-attachments/assets/3498ca31-7156-4a3e-bce1-b536529dae01" />


Now this is configured, you have the necessary rights to view kubernetes objects in the cluster like: Namespaces, Deployments, Services and Ingress.

> [!WARNING]
> To secure the cluster and to comply with the **Least Privileges Principal** only creates IAM access if necessary, and give accounts only the minimal permissions to prevent unauthorized access.

8. Now Terraform has created the cluster and the IAM permission are configured correctly. Now it is time to test if you can connect to the cluster.

### Connect to the EKS Kubernetes cluster using the CLI 

To do so make sure that in your ternimal session you are logged in with your AWS account and perform the following command to connect to the cluster

```bash
aws eks update-kubeconfig --region eu-central-1 --name rag_eks_fargate_cluster 
```
You should now be connected to the cluster, to varify please use the command below. 

```bash
kubectl get svc
```
After the command: you must get a output like this: 

```bash
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   your cluster ip   <none>        443/TCP   44m
```
> [!NOTE]
> If the command above fails, make sure that that you are logged in with your AWS account and that Kubectl is installed on your machine.

## Chapter 3 Cluster configuration

  ### Import Kubernetes Secret to the cluster. 

10. To prevent hardcoding Kubernetes secrets is used to deploy RAG so that sensitive information cannot be exposed in the Kubernetes deployment files. 
The **"rag-secrets.yaml"** file must be configured with the right secrets so that it can be imported into the Cluster. The Cluster will later use the secrets to provide the RAG pods the data it needs to let all the RAG microservices talk to each other.

First go the cohere webiste and [request a API key](https://dashboard.cohere.com/). 

Next navigate to the [**"rag-secrets.yaml"**](Terraform/stage-3-cluster-config/k8s/secrets/rag-secrets.yaml) and open the file so you can edit it. Make sure that you edit the following based on the table below. 

| Secret                | Value                                                  |
|-----------------------|--------------------------------------------------------|
| WEAVIATE_URL          | http://rag-weaviate.rag-workers.svc.cluster.local:8080 |
| WORKER_URL            | http://rag-worker.rag-workers.svc.cluster.local:8001   |
| S3_ENDPOINT_URL       | http://rag-minio.rag-workers.svc.cluster.local:9000    |
| AWS_ACCESS_KEY_ID     | CREATE STRONG ID YOURSELF                              |
| AWS_SECRET_ACCESS_KEY | CREATE STRONG KEY YOURSELF                             |
| COHERE_API_KEY        | PUT YOU REQUESTED API KEY HERE                           |
| API_URL               | http://rag-api.rag-api.svc.cluster.local:8000          |
| MINIO_ROOT_USER       | PUT HERE YOUR AWS_ACCESS_KEY_ID                     |
| MINIO_ROOT_PASSWORD   | PUT HERE YOUR AWS_SECRET_ACCESS_KEY                        |

> [!CAUTION]
> NEVER USE HTTP FOR PRODUCUTION!!! ANYONE WITH A NETWORK SNIFFER WILL ABLE TO LISTEN TO POD TRAFFIC IF SOMEONE GET ACCESS TO THE KUBERNETES CLUSTER.
> THE HTTP ENPOINTS ABOVE YOU ARE ONLY FOR TESTING PURPUSES

### Importing the above secrets and namespaces to the EKS cluster.

Before anything can be deployed, Namespaces and Secrets must be present on the cluster before RAG can be deployed. 

11. First navigate to **"stage-3-cluster-config"** 

```bash
cd ..
cd .\stage-3-cluster-config\  
```
First import alle namespaces. 

```bash
kubectl apply -f .\k8s\namespaces\namespaces.yaml
```
After this, import all secrets to the cluster. 

```bash
kubectl apply -f .\k8s\secrets\rag-secrets.yaml -n rag-api

kubectl apply -f .\k8s\secrets\rag-secrets.yaml -n rag-workers

kubectl apply -f .\k8s\secrets\rag-secrets.yaml -n rag-frontend

kubectl apply -f .\k8s\secrets\rag-secrets.yaml -n rag-monitoring
```
If the import worked, then you must get the ouput below for each secret that you are importing.

```hcl
secret/weaviate-url created
secret/s3-endpoint-url created
secret/worker-url created
secret/aws-access-key-id created
secret/aws-secret-access-key created
secret/cohere-api-key created
secret/api-url created
secret/minio-root-user created
secret/minio-root-password created
```

Now go back to the cluster. Click on the **"Resources"** tab thereafter click on **"Cluster>Namespaces"**. All namespaces are now present on the cluster. 

<img width="1506" height="710" alt="image" src="https://github.com/user-attachments/assets/1b9f9ea0-3d56-4f1c-bdc8-a1b909703343" />

### Making RAG Ready for HTTPS 🔏 ✅
Since you can upload any document to our RAG system, there may also be documents containing sensitive data. These documents must not be leaked to the outside world, as the front end is exposed on the internet. HTTPS support has been added to encrypt traffic between a client and the RAG server.

The ELB (Elastic Load Balancer) will use the certificate to provide the front end with HTTPS. A self-signed certificate will be used, which means that your web browser will not trust the certificate, but the traffic will be encrypted. To apply HTTPS, follow the steps below 

> [!CAUTION]
> Please do not continue without completing the HTTPS steps, RAG will not work over HTTP ❌

> [!IMPORTANT]
> Please make sure that you have installed OpenSSL on your system.

#### Creating configuration certficate file

First there must be configuration file created that contains configurations of what for data need to be present in the certificate. 

Please navigate to the `certificate` folder inside `stage-3-cluster-config` : 

```bash
cd .\certificate\
```
Next, create a file named ``rag-cert.conf`` paste the following inside the file: 

```bash
[ req ]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn
x509_extensions    = v3_req

[ dn ]
C  = NL
ST = Noord-Brabant
L  = Eindhoven
O  = Fontys
OU = rag
CN = rag.local.nl

[ v3_req ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = rag.local.nl
``` 

The above data will be saved inside the HTTPS certificate once you generates the certificate. Now you can move to the next step wich is generating the certificate.

#### Generate the certificate and the private key

First generate the private key for the certificate using the command below 

```bash
openssl genrsa -out rag.local.nl.key 2048
```
> [!IMPORTANT]
> Never share the private key with the outside world, the private key must stay secret!!!

Thereafter generate the certificate itself using the private key you just made. 

```bash
openssl req -x509 -new -key rag.local.nl.key -out rag.local.nl.pem -days 365 -config rag-cert.conf
```
Now you should have a private key and a pem file containing the content of the HTTPS certificate.
To verify use the ``ls`` command in your ternimal, you should see the private key and the .pem file as a result. 

```bash
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         19-1-2026     18:20           1704 rag.local.nl.key
-a----         19-1-2026     18:22           1375 rag.local.nl.pem
```

Now navigate back to the root folder of ``stage-3-cluster-config`` with the command below:
```bash
cd ..
```

Now you have generates a HTTPS certificate that the ELB will use to expose the front end via HTTPS. 
Terraform will take care of the rest and configure the ELB with HTTPS for you. 

### Configured the remaining configuration of the cluster with Terraform.

The most manual work has now being done 👏🏽 now it is up to Terraform to automaticly apply the final cluster configuration. Terraform will configure the following in Stage 3:

✅ Apply all Service, and Deployments YALM files,<br>
✅ Install CoreDNS for Kubernets so pods can talk to services,<br> 
✅ Create a Kubernetes service account (Least-Priveleges) so it can create a ALB for the front-end,
✅ Configure the ELB to use HTTPS

12. To begin the deployment apply the following command: 

```hcl
terraform init
terraform apply
```
> [!NOTE]
> Make sure that you enter the above commands in the [stage-3-cluster-config folder](Terraform/stage-3-cluster-config).

After Terrraform is done, you will get the following output.
```hcl 
Apply complete! Resources: 11 added, 0 changed, 0 destroyed.
```
Cluster is now done with configuring. 

13. verifying if all the pods are deployed.

 If you go to Deployments in the cluster secton of your cluster you should see that all pods are deployed. You should have the following pods like on the screenshot below.

<img width="1324" height="660" alt="image" src="https://github.com/user-attachments/assets/8dcf1dc2-21ce-4c33-a1fb-73498c2a8332" />

### Check if the ALB has being created.

14. Please go to **"EC2>Load balancers"**  you must see at least one ALB that the ingress file has created for the front end.  

<img width="1912" height="821" alt="image" src="https://github.com/user-attachments/assets/bf40362e-8c57-4f94-97ac-64705d8f1605" />

>[!IMPORTANT]
> The Load-Balancer state must be **"Ready"** if the state is **"Provisioning"** just wait for 5 minutes.
> The frontend is only available after the state is set to **"Ready"**

The ALB als made a **"Target group"** that allow the ALB only to send traffic the **"rag-frontend pod"**. 

### Navigate to the front end

15. All components are installed, in order to navigate to the frontend we need to have the URL that AWS has auto created. To get this URL, go back to the cluster and navigate to the **"Service and networking>Ingresses>rag-frontend-ingress"** the ingress section has a **"Load balancer URLs"** copy the URL and paste in your webbrowser. 

<img width="1798" height="335" alt="image" src="https://github.com/user-attachments/assets/b9de2aeb-21a2-4906-97dc-e467b4381416" />

You have know reached the front-end. congratulations 🎉 you have successfully installed RAG on your own AWS enviroment. Have fun 🥳

<img width="1911" height="917" alt="image" src="https://github.com/user-attachments/assets/1799c866-0ec9-4fae-9ca8-133205898fcb" />

## Stage 4: Destroy the AWS Infrastructure when you don't need RAG anymore
There will come a time when you no longer use RAG and simply no longer need it. Hosting RAG on AWS without using it will only drive up your costs. That is why it is recommended to destroy the entire RAG environment to save costs. During the creation of the RAG environment, many components were created by Terraform. It is not realistic to remove each component one by one as this takes a lot of time. Fortunately, the removal process can be automated using Terraform.

With the help of 3 commands, the entire RAG environment can be removed with Terraform. This chapter will show you what you need to do to remove the environment.

It is not possible to delete the whole infrastructure with one commmand. Therefor you need to apply Terraform Destroy 3 times.

16. Destroy the cluster configuration

``
 stage-3-cluster-config
``

```
terraform destroy
```
18. Destroy the cluster itself
     
``
 stage-2-cluster-creation
``

```
terraform destroy
```

20. Destroy the AWS infrastructure

``
 stage-1-vpc-creating
``

```
terraform destroy
```




































































   

   



   
        





   




















  
