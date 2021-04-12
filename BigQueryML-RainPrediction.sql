/* The below code is written for a blog post related to Google BigQuery ML. The blog post can be found at http://thedigitalskye.com/2021/04/13/how-to-train-a-classification-model-to-predict-next-day-rain-with-google-bigquery-ml/ */

/* Step 1: Split the dataset into training and test sets */


/* Step 1a: Create a fake unique ID column and correct data types for numerical values */

#standardSQL
CREATE OR REPLACE TABLE
  `australiarain.rainprediction.weather_data` AS (
  SELECT
    # Create a fake unique ID column to facilitate random splitting
    GENERATE_UUID() AS UUID,
    
    # Correct datatype of numerical values from string to float64 or int64 type
    CAST(MinTemp AS float64) AS MinTemp,
    CAST(MaxTemp AS float64) AS MaxTemp,
    CAST(Rainfall AS float64) AS Rainfall,
    CAST(Evaporation AS float64) AS Evaporation,
    CAST(Sunshine AS float64) AS Sunshine,
    CAST(WindGustSpeed AS float64) AS WindGustSpeed,
    CAST(WindSpeed9am AS float64) AS WindSpeed9am,
    CAST(WindSpeed3pm AS float64) AS WindSpeed3pm,
    CAST(Humidity9am AS float64) AS Humidity9am,
    CAST(Humidity3pm AS float64) AS Humidity3pm,
    CAST(Pressure9am AS float64) AS Pressure9am,
    CAST(Pressure3pm AS float64) AS Pressure3pm,
    CAST(Temp9am AS float64) AS Temp9am,
    CAST(Temp3pm AS float64) AS Temp3pm,
    CAST(Cloud9am AS int64) AS Cloud9am,
    CAST(Cloud3pm AS int64) AS CLoud3pm,
    
    # Include the remaining non-numerical values
    Date,
    Location,
    WindGustDir,
    WindDir9am,
    WindDir3pm,
    RainToday,
    RainTomorrow
  FROM
    `australiarain.rainprediction.weatherAUS`);


/* Step 1b:  Split the dataset based on the fake unique ID column (UUID) */

#standardSQL
  # Create the test set
CREATE OR REPLACE TABLE
  `australiarain.rainprediction.test_data`AS
SELECT
  *
FROM
  `australiarain.rainprediction.weather_data`
WHERE
  MOD(ABS(FARM_FINGERPRINT(UUID)), 5) = 0;
  
  # Create the training set
CREATE OR REPLACE TABLE
  `australiarain.rainprediction.train_data` AS
SELECT
  *
FROM
  `australiarain.rainprediction.weather_data`
WHERE
  NOT UUID IN (
  SELECT
    DISTINCT UUID
  FROM
    `australiarain.rainprediction.test_data`);



/* Step 2: Train a simple logistic regression model */

#standardSQL
CREATE OR REPLACE MODEL
  `rainprediction.logreg` OPTIONS (MODEL_TYPE = 'LOGISTIC_REG',
    INPUT_LABEL_COLS = ['RainTomorrow']) AS
SELECT
  * EXCEPT(UUID)
FROM
  `australiarain.rainprediction.train_data`
WHERE
  RainTomorrow IS NOT NULL;



/* Step 3: Customise a logistic regression model */

#standardSQL
CREATE OR REPLACE MODEL
  `rainprediction.logreg2` OPTIONS (MODEL_TYPE = 'LOGISTIC_REG',
    INPUT_LABEL_COLS = ['RainTomorrow'],
    
    # Correct the imbalanced training dataset
    AUTO_CLASS_WEIGHTS = TRUE,
    
    # Assign 20% of training data for evaluation
    DATA_SPLIT_METHOD = 'RANDOM',
    DATA_SPLIT_EVAL_FRACTION = 0.2,
    
    # Apply L2 regularization 
    L2_REG = 0.1) AS
    
SELECT
  * EXCEPT(UUID)
FROM
  `australiarain.rainprediction.train_data`
WHERE
  RainTomorrow IS NOT NULL;



/* Step 4: Evaluate classification models with ML.EVALUATE */

#standardSQL
SELECT
  *
FROM
  ML.EVALUATE(MODEL `rainprediction.logreg`,
    (
    SELECT
      * EXCEPT(UUID)
    FROM
      `australiarain.rainprediction.test_data`));



/* Step 5: Predict next-day rain with the classification model */
#standardSQL
SELECT
  predicted_RainTomorrow, predicted_RainTomorrow_probs, Date, Location
FROM
  ML.PREDICT(MODEL `rainprediction.logreg`,
    (
    SELECT
      * EXCEPT (RainToday),
      CAST(RainToday AS STRING) AS RainToday
    FROM
      `australiarain.rainprediction.apr10_predict`), STRUCT(0.6 AS threshold));