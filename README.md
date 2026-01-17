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
5. Peform Terraform Init and Apply just like you did in [chapter 1](##Chapter1:Stage1Infrastructurecreation).

6. 

   
        





   




















  
