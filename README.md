## Description  

This is the final project for the DataTalks Club Data Engineering Zoomcamp 2024.

In this project we will display used car sales in the United States.

## Dataset  

We will use the Vehicles Sales dataset from Kaggle. The dataset can be found in the URL below:  

https://www.kaggle.com/datasets/syedanwarafridi/vehicle-sales-data  

as a zip file.

The file can also be found in the project **data** folder.

## First steps  

For the purposes of this project a Linux machine has been used.

Create a folder in your hard drive:  

mkdir project   

Change to the folder you just created:  

cd project  

Then clone this project by typing:  

```git clone https://github.com/dgkertsos/car-sales.git```

You can see instructions on how to install git on a Linux machine [here](https://github.com/git-guides/install-git)  

## Create a GCP bucket and a BigQuery Dataset with Terraform  

The GCP bucket will be used to store the data from the car-prices.zip file in a parquet format file. Then the data will be transferred to a BigQuery table which is stored in the created dataset. We will do the transfer with the help of Mage.

For this we will use terraform which must be installed on our computer. 

You can see instructions on how to install terraform on a Linux machine [here](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/install-cli)
 
Then we have to modify the main.tf file located in the terraform folder. We are going to make the following changes:

For the provider  
 1. Replace the project ID with your GCP project ID  
 2. Replace the region with your GCP region  
For the bucket  
 1. Replace bucket name with your bucket name  
 2. Replace the bucket location with your bucket location  
For the dataset  
 1. Replace dataset name with the dataset name  
 2. Replace the project ID with your GCP project ID  
 3. Replace the dataset location with your dataset location  

We also have to paste the contents of our service account json file to the keys/tf_service_account.json file. 

NOTE:
The service account can be created with the following roles:
    Storage Admin
    BigQuery Admin
    Compute Admin
    
Then from the terraform directory we execute:

 ```terraform init```  
 ```terraform plan```  
 ```terraform apply```  

Type yes and hit Enter.  

The bucket is created in our GCP storage and the dataset will be created in our bigquery datasets.  

## Create pipelines with Mage  

Before running Mage do the following changes to the files:  

  1. In mage/data_exporters/bl_upload_data_to_gcs.py replace bucket name with your bucket name.
  2. In mage/data_loaders/bl_load_data_from_gcs.py replace bucket name with your bucket name.
  3. Paste the contents of your service account json file to the keys/mage_service_account.json file. 
     
Then you run the following commands:  

cd mage  
cp dev.env .env  
rm dev.env  

And finally:  

docker-compose up  

NOTE  
You have to install docker first to make the last command run.  

Forward port 6789 on your local machine.  

Then you can access Mage by typing:  

http://localhost:6789  

in your browser.

Select the **csv_to_gcs** pipeline and execute each block one by one or else select the last block, click on **...** and then select **Execute with all upstream blocks**  

After the pipeline is executed a **car_sales.parquet** file is created in the **de_zoomcamp_car_sales** bucket.  

Select the **gcs_to_bq** pipeline and execute each block one by one or else select the last block, click on **...** and then select **Execute with all upstream blocks**  

After the pipeline is executed a partitioned table called **car_sales** is created in the **de_zoomcamp_car_sales** dataset and then all the data from the bucket are transfered to this table. There should be 558811 records in the table.  

## Create a model in dbt Cloud

In GitHub search for dgkertsos/car-sales, click on the result and then click on the Fork button. Review the settings and click on the Create Fork button.  

Go to Code and copy the SSH address starting with git@  

Sign up for a free account id dbt cloud  

Go to Account Settings, Projects and then click +New Project  

Enter a Project name, eg car-sales  and then click Continue  

In the Project subdirectory field type: dbt  

This is the folder name where the dbt project resides.  

Choose a connection, in our case BigQuery and click Next.

Click Upload a Service Account JSON file and select the JSON file you have downloaded from Google Cloud Platform.  

In the Location field you can type your preffered Google Cloud Platform location where you want your datasets to be created.  

In the Dataset field, type the name for the Dataset which will be crated by the dbt cloud platform, eg dbt_car_sales.  

Click on the Test Connection button. Dbt cloud will try to connect to your Google Cloud Platform. If everything is OK, Next button appears. Click on it to continue.  

Then we have to setup the repository which means where our dbt cloud project is stored. 

Select Git Clone and in the Git URL type the SSH address you have copied earlier, starting with git@  

Click the Import Button  

A new SSH-RSA key is created. Copy the created key. Then go to GitHub Settings, SSH and GPG Keys. 

Click the New SSH key button. 

Type a title, eg SSHKey and in the key field paste the key from the previous step.  

Click on the Add SSH key button.  

Back in dbt Cloud click the Next button and then on the Start Developing in the IDE link.  

Go to Deploy, Environments and click on the +Create Environment button.  

Name your environment, eg Production and in the deployment type select PROD. Finally in the Dataset field type a Dataset name, eg. dbt_car_sales.  

Click Save.  

Go to Deploy, Jobs and click on the +Create Job button. Select Deploy Job.

In the Job name field type a name. In the Environment field select Production and finally click the Save button.  

To run the new created job click the Run now button.  

We can see the job result by clicking on the job name.

If the job run without problems we will be able to see a dataset created in our BigQuery console with the stg_car_sales table inside.  

Now we are ready to visualize the data.  

## Visualize data

Go to https://lookerstudio.google.com/ and connect with you Google credentials, the ones you used to set up the Google Cloud Platform.  

Click on the Blank Report button and then click on the BigQuery button.  

Select your Project, Dataset and Table and then click on the Add button. Finally click on the Add to Report button.

The dataset is added to our blank report and now we are ready to start building.

You can see my report by clicking the link [here](https://lookerstudio.google.com/reporting/318a9f8e-f259-434d-aaf1-0756e7458719)
