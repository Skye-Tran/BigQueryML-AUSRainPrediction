# BigQueryML - How to Train a Model to Predict Next-Day Rain in Australia

## Problem Statement
Given today’s observations about Wind Direction, Rainfall, Minimum Temperature, Maximum Temperature, Cloud Cover and so on, can we predict whether it will rain tomorrow?

## Motivation
Learning how to predict next-day rain is a simple and practical way to explore Machine Learning with Google BigQuery. Additionally, this project aims to explore how BigQuery ML could offer an easy way to build a baseline model with 3 main benefits. 
- You don’t need to spend a ridiculous amount of time trying to figure out how to export data from your BigQuery data warehouse with a myriad of new tools
- You don’t have to seek heaps of approvals if there are legal restrictions or compliance requirements that strictly govern how exporting data and moving it around for analysis and machine learning should happen (But of course, compliance with access control policies and common sense still applies here.)
- You don’t need to drive yourself nuts to create an ML solution using Python/ Java or join the long waitlist for a chance to trouble someone else (or even an entire team) to help you out.

From a business viewpoint, this approach means a simpler and faster way to leverage Machine Learning to predict what might happen in the future and how the business should respond to effectively seize the opportunities or mitigate the risks.

## Installation & Instructions
No installation is required since all codes and ML models are executed on Google Cloud Platform. However, a GCP account is required and the following setup has to be completed. 
1. Create a project on Google Cloud Platform
2. Create a dataset on BigQuery
3. Download the 2 CSV files (weatherAUS.csv and apr10_predict.csv) from my GitHub and upload them to Google Cloud Storage

Detailed instructions on how to run the entire project can be found on [my blog](http://thedigitalskye.com/2021/04/13/how-to-train-a-classification-model-to-predict-next-day-rain-with-google-bigquery-ml/) 
