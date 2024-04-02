**Description**  

This is the final project for the DataTalks Club Data Engineering Zoomcamp 2024.

In this project we will display used car sales in the United States.

**Dataset**  

We will use the Vehicles Sales dataset from Kaggle. The dataset can be found in the URL below:  

https://www.kaggle.com/datasets/syedanwarafridi/vehicle-sales-data  

as a zip file.

The file can also be found in the data folder.

**First steps**  

Create a folder in your hard drive:  

mkdir project   

Change to the folder you just created:  

cd project  

Then clone this project by typing:

git clone https://github.com/dgkertsos/car-sales.git

**Create a GCP bucket and a BigQuery Dataset**  

The GCP bucket will be used to store the data from the car-prices.zip file in a partitioned parquet format. Then the data will be transferred to a BigQuery table which is stored in the created dataset. We will do the transfer with the help of Mage.

 For this we will use terraform which must be installed on our computer. Then we have to modify the main.tf file located in the terraform folder. We are going to make the following changes:

    1. For the provider
        a. Replace the project ID with your GCP project ID
        b. Replace the region with your GCP region
    2. For the bucket
        a. Replace bucket name with your bucket name
        b. Replace the bucket location with your bucket location
    3. For the dataset
        a. Replace dataset name with the dataset name
        b. Replace the project ID with your GCP project ID
        c. Replace the dataset location with your dataset location

We also have to paste the contents of our service account json file to the keys/tf_service_account.json file. 

NOTE:
The service account can be created with the following roles:
    Storage Admin
    BigQuery Admin
    Compute Admin
    
Then from the terraform directory we execute:

    terraform init
    terraform plan
    terraform apply

    Type yes and hit Enter.

The bucket is created in our GCP storage and the dataset will be created in our bigquery datasets.

**Run Mage**  

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

**Create a model in dbt Cloud**

Sign up for a free account id dbt cloud  

Go to Account Settings, Projects and then click +New Project  

Enter a Project name, eg car-sales  and then click Continue  

Choose a connection, in our case BigQuery and click Next.

Click Upload a Service Account JSON file and select the JSON file you have downloaded from Google Cloud Platform.  

In the Location field you can type your preffered Google Cloud Platform location where you want your datasets to be created.  

In the Dataset field, type the name for the Dataset which will be crated by the dbt cloud platform, eg dbt_car_sales.  

Click on the Test Connection button. Dbt cloud will try to connect to your Google Cloud Platform. If everything is OK, Next button appears. Click on it to continue.  

