# SynapseUtilities
A collection of utilities for Azure Synapse Analytics

## Synapse_TPC-DS_DataGen
Code used for generating TPC-DS or TPC-H Datasets as parquet and loading into Synapse Dedicated Pools

### Steps to Run
1. Add package /Spark/spark-sql-perf_2.12-0.5.1-SNAPSHOT.jar to your Spark Pool
1. Import /Spark/SynapseSpark_TPC_DataGen.ipynb
1. Run SynapseSpark_TPC_DataGen Notebook attached to the Spark Pool in step 1
1. (Optional) Run 
