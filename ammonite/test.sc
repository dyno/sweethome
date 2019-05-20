import $ivy.`com.github.tototoshi::scala-csv:1.3.5`
import $ivy.`com.signifyd:functional:CI-NP-206`

import com.github.tototoshi.csv._
import java.io.File

val reader = CSVReader.open(new File("sample.csv"))
println(reader.all())
reader.close()

