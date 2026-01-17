# RAG-DEPLOYMENT-EKS-FARGATE-INFRA-S3

Retrieval-augmented generation (RAG) is a way for AI to retrieve data from external sources and provide relevant information to the user based on that data. 

We have developed an AI RAG chatbot system that is capable of analyzing documents and answering all kinds of questions about the document to the end user. Do you have a large document that needs to be reviewed, but don't have the time to do so? Or do you want a quick summary of something? Ask our AI RAG system and you will get the answer you need, saving you time. This Repository will explain how you can apply RAG in an AWS environment

At the end of this instruction, you will have the following that you can use:

- A frontend with a chatbot to analyze your documents,
- upload your own documents for analysis,
- An AI chatbot that can answer all questions about your document,
- LLM (Large Language Model) checks in place to not answer on inappropriate/illegal questions,
- Ask questions in different languages Like Dutch or English,

## prerequisite for deployment RAG on AWS

In order to successfully apply RAG within your AWS environment, its application has been divided into the stages below. Each stage must be completed in order for the RAG Chatbot to become functional. Make sure you have the following before you start applying RAG, otherwise you will not be able to follow the steps in these instructions. 

- [ ] [AWS CLI installed](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and loged in with you AWS profile,
- [ ] [Terraform installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and configured, 
- [ ] Installed kubectl to interact with the Kubernetes cluster,
- [ ] [Helm installed](https://helm.sh/docs/intro/install/) to install Kubernetes packages,

For more information how to setup the above, please use the hyperlinks provide.

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
                ├───ingress
                ├───namespaces
                ├───secrets
                └───services
```
2. Navigate to the “stage-1-vpc-creation” folder and run Terraform Init to prepare Terraform for automation.
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

If you have not received any errors, you can proceed with the next steps. If you now go to the “AWS Management Console,” “rag-vpc” should appear.  

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
5. Peform Terraform Init and Apply just like you did in [chapter 1](#chapter-1-stage-1-infrastructure-creation) by step 2 & 3.

After this you should get a response back from Terraform that the cluster has being created like the example below: 
```hcl
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
```
6. Check if the cluster actually exist. In AWS Management Console navigate to **"EKS>Clusters"** you must see the cluster **"rag_eks_fargate_cluster"** just as the example below .
   <img width="1558" height="237" alt="image" src="https://github.com/user-attachments/assets/bab2bdd9-affa-4230-9021-085336fa4fe9" />

  Next open the cluster and go **"Compute"** after this scroll down to **"Compute"** you must see 2 namespaces: **"default"** and **"rag-namespaces"**. 
<img width="1583" height="240" alt="image" src="https://github.com/user-attachments/assets/9be989cf-27d3-4bf3-8597-7863c0bc1bfb" />

> [!CAUTION]
> Do not continue the until the Fargate Profiles are ready. Without the Profiles RAG cannot be deployed!!!

7. After the cluster creation you do not have enough permisson to see what resources EKS is using. To alllow you to view the resources of the cluster IAM permissions on the cluster side must be configured.

Please go to **"Access"** tab in the cluster and click on the Create button.     

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

8. Now Terraform has created the cluster and IAM permission are configured correctly. Now it is time to test if you can connect to the cluster.

To do so make sure that in your ternimal session you are logged in with your AWS account and performing the following command to connect to the cluster

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
kubernetes   ClusterIP   10.100.0.1   <none>        443/TCP   44m
```
> [!NOTE]
> If the command above fails, make sure that that you are logged in with your AWS account and that Kubectl is installed on your machine. 

9. Next the Load-Balencer-controller must be installed on the cluster it self.

The Load-Balencer-controller will act like a proxy for the front-end to securly expose the chatbot to the internet. This way Fargate pods can stay in private subnets for security isolation. To install the Load-Balencer-controller the Kubernets package manger **"helm"**
must be used. But first use the command below to add the EKS github repository to your system. 

> [!IMPORTANT]
> Also make sure that helm in installed on your system! Without this you can not install the Load-Balencer-Controller 

```bash
helm repo add eks https://aws.github.io/eks-charts
```

After this update the repo with the folling command.
```bash
helm repo update 
```

Now install the Load-Balencer-controller. 
```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=rag_eks_fargate_cluster --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller --set vpcId=your-vpc-id 
```

> [!NOTE]
> "place the VPC id in the "vpcId parameter". The VPC ID can be found in the AWS Managemnt console by **"VPC>YOUR VPCs"**.

After the  Load-Balencer-Controller is successfully installed you will get the output below.

```bash
NAME: aws-load-balancer-controller
LAST DEPLOYED: Sat Jan 17 17:37:32 2026
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None
NOTES:
AWS Load Balancer controller installed!
```





















   

   



   
        





   




















  
