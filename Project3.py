# ST590 Project 3
# Josh Baber and Joshua Cooper

############################################################################################################

                      # Setup for Creating Files (Submit to Python Console)

############################################################################################################


# Import necessary modules
import pandas as pd
import numpy as np
import time
from pyspark.sql.types import StructType

# Read in the full accelerometer data set
accelFull = pd.read_csv("Data/all_accelerometer_data_pids_13.csv")

# Create a data frame that is subset to only contain observations for pid SA0297
SA0297DF = accelFull[(accelFull["pid"] == "SA0297")]
# Create a data frame that is subset to only contain observations for pid PC6771
PC6771DF = accelFull[(accelFull["pid"] == "PC6771")]

# Write a for loop to write csv files 500 entries at a time, up to 20 files each for each pid
# DON'T SUBMIT THIS LOOP TO CONSOLE YET
for i in range(0, 20):
    # Grab ith 500 rows from SA0927 data frame and name it tempSA
    tempSA = SA0297DF.iloc[(i*500):((500*i)+500)]
    # Write the temporary SA data frame to a csv based on the iteration number it is on
    tempSA.to_csv("Data/SA0297/SAData" + str(i) + ".csv", index = False, header = False)
    # Grab ith 500 rows from PC6771 data frame and name it tempPC
    tempPC = PC6771DF.iloc[(i*500):((500*i)+500)]
    # Write the temporary PC data frame to a csv based on the iteration number it is on
    tempPC.to_csv("Data/PC6771/PCData" + str(i) + ".csv", index = False, header = False)
    # Wait 20 seconds before doing the next iteration
    time.sleep(20)

############################################################################################################

                          # Set Up Schemas for Reading Streams (Submit to Pyspark)

############################################################################################################

# Create schemas for SA0927 and PC6771
from pyspark.sql.types import StructType
# Add time, pid, x, y, and z to the spark data frame schemas with appropriate variable types
schemaSA = StructType().add("time", "double").add("pid", "string").add("x", "double").add("y", "double").add("z", "double")
schemaPC = StructType().add("time", "double").add("pid", "string").add("x", "double").add("y", "double").add("z", "double")

# Tell pyspark where to read the streams using the schemas
dfSA = spark.readStream.schema(schemaSA).csv("C:/Users/squas/OneDrive/Desktop/ST 590/Code/Data/SA0297")
dfPC = spark.readStream.schema(schemaPC).csv("C:/Users/squas/OneDrive/Desktop/ST 590/Code/Data/PC6771")

############################################################################################################

                    # Set Up Magnitude Transformation Using spark.sql (Submit to Pyspark)

############################################################################################################

# Take the data frames and use the .withColumn method to create a "mag" column which calculates the magnitude of x, y, and z
from pyspark.sql.functions import col, sqrt
aggSA = dfSA.withColumn("mag", sqrt(col("x")**2 + col("y")**2 + col("z")**2)).select(["time", "pid", "mag"])
aggPC = dfPC.withColumn("mag", sqrt(col("x")**2 + col("y")**2 + col("z")**2)).select(["time", "pid", "mag"])

############################################################################################################

                               # Begin Writing Streams (Submit to PySpark)

############################################################################################################

# Begin the query for the SA0297 folder using csv format, append output mode, and path to output to
querySA = aggSA.writeStream.outputMode("append").format("csv").option("path", "C:/Users/squas/OneDrive/Desktop/ST 590/Code/Data/SA0297Output").option("checkpointlocation", "C:/Users/squas/OneDrive/Desktop/ST 590/Code/Data/SA0297Output").start()
# Begin the query for the PC6771 folder using csv format, append output mode, and path to output to
queryPC = aggPC.writeStream.outputMode("append").format("csv").option("path", "C:/Users/squas/OneDrive/Desktop/ST 590/Code/Data/PC6771Output").option("checkpointlocation", "C:/Users/squas/OneDrive/Desktop/ST 590/Code/Data/PC6771Output").start()

# Now we can go to the python console and submit the code from above to populate the folders, let it run for about 5 minutes

############################################################################################################

            # Combine the Partial Files into One Big File for Each PID (Submit to PySpark)

############################################################################################################

# Use PySpark to read in all SA0927 "part" files
allSAFiles = spark.read.option("header", "false").csv("C:/Users/squas/OneDrive/Desktop/ST 590/Code/Data/SA0297Output")
# Output as a single csv file
allSAFiles.coalesce(1).write.format("csv").option("header", "false").save("C:/Users/squas/OneDrive/Desktop/ST 590/Code/Data/FinalSA0297")
# Use PySpark to read in all PC6771 "part" files
allPCFiles = spark.read.option("header", "false").csv("C:/Users/squas/OneDrive/Desktop/ST 590/Code/Data/PC6771Output")
# Output as a single csv file
allPCFiles.coalesce(1).write.format("csv").option("header", "false").save("C:/Users/squas/OneDrive/Desktop/ST 590/Code/Data/FinalPC6771")