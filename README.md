# SynapseUtilities
A collection of utilities for Azure Synapse Analytics

## Synapse_TPC-DS_DataGen
Code used for generating TPC-DS or TPC-H Datasets as parquet and loading into Synapse Dedicated Pools.

Kuddos to @npoggi (https://github.com/databricks/spark-sql-perf/blob/master/src/main/notebooks/TPC-multi_datagen.scala#L14), I mostly just updated the scala script to work on Synapse Spark.

### Steps to Run
1. Add package /Spark/spark-sql-perf_2.12-0.5.1-SNAPSHOT.jar to your Spark Pool
1. Import /Spark/SynapseSpark_TPC_DataGen.ipynb
1. Run SynapseSpark_TPC_DataGen Notebook attached to the Spark Pool in step 1
1. (Optional) Run 
