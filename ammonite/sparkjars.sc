/**
 * ## Load jars ##
 */
import ammonite.ops._

// e.g. /opt/.ivy2/local/sh.almond/ammonite-spark_2.12/0.8.0+16-fc59944f-SNAPSHOT/jars/ammonite-spark_2.12.jar => ammonite-spark
val toPackageName = (jarPath: Path) => jarPath.baseName.split("-").dropRight(1).mkString("-")
//  { "[0-9]$".r findFirstIn _._2.baseName isEmpty }
val jarFilter = (jarPath:Path) => jarPath.ext == "jar" && !List("-tests", "-javadoc", "-sources", "jre7", "empty-to-avoid-conflict-with-guava").exists(jarPath.baseName.endsWith)

// ## ${SPARK_DIST_CLASSPATH} ##
// i.e. os.proc("hadoop", "classpath").call().out.trim
val libs = sys.env("SPARK_DIST_CLASSPATH").split(":")
val jars = libs filter { _.endsWith("jar") } map { Path(_) }
val paths = libs filter { !_.endsWith("jar") } map { _.replace("*", "") }  map { Path(_) } toSet
val jarsInPaths = paths map { p => ls ! p |? {_.ext == "jar"} } flatMap identity
val hadoopJarToPath = jars ++ jarsInPaths filter jarFilter map { case p => (toPackageName(p), p) } toMap

// ## ${SPARK_HOME}/jars ##
val sparkHomeJars = ls! Path(sys.env("SPARK_HOME")) / 'jars |? {_.ext == "jar"}
val sparkJarToPath = jars ++ sparkHomeJars filter jarFilter map { case p => (toPackageName(p), p) } toMap

// XXX: if jar exists in both, use spark one.
val allJars = (hadoopJarToPath ++ sparkJarToPath).values
(paths ++ allJars) foreach { interp.load.cp }

// what is currently in the classpath?
//  repl.sess.frames(0).classpath
