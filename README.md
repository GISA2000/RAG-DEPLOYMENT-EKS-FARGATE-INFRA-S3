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

- [ ] AWS CLI installed and loged in with you AWS profile,
- [ ] Terraform installed and configured,
- [ ] Installed kubectl to interact with the Kubernetes cluster,
- [ ] Helm installed to install Kubernetes packages,


  
