import org.apache.spark.sql._

/**
 * Create a SparkSession
 *
 * https://github.com/alexarchambault/ammonite-spark
 * https://almond.sh/docs/next/usage-spark
 */

import org.apache.log4j.{Level, Logger}
Logger.getLogger("org").setLevel(Level.OFF)

import $ivy.`sh.almond::ammonite-spark:0.8.0`
import org.apache.spark.sql.AmmoniteSparkSession
val spark = {
  AmmoniteSparkSession.builder()
    .master("local[*]")
    .config("spark.home", sys.env("SPARK_HOME"))
    .config("spark.logConf", "true")
    .getOrCreate()
}


/**
 * Simple Scala UDF Example
 *
 * https://docs.databricks.com/spark/latest/spark-sql/udf-scala.html
 */

import org.apache.spark.sql.functions.{col, udf}

val squared = (i:Long) => i * i
val squaredUdf = udf(squared)
spark.udf.register("square", squaredUdf)

val df = spark.range(1, 20)
val df1 = df.select(squaredUdf(col("id")).alias("id_squred"))

// Spark SQL
df.createOrReplaceTempView("test")
val df2 = spark.sql("SELECT square(id) as id_squared from test")
