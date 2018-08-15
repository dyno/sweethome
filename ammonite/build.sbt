name := "ammonite"
version := "0.1"
scalaVersion := "2.12.6"

lazy val debugMsg = taskKey[Unit]("show debugMsg")
lazy val root = (project in file("."))
  .settings(debugMsg := {
    val out = streams.value
    val log = out.log
    log.info("Happy Debugging!")
  })

libraryDependencies ++= Seq(
  "com.lihaoyi" %% "ammonite-ops" % "1.1.2",
  "com.lihaoyi" % "ammonite" % "1.1.2" cross CrossVersion.full,
  "com.typesafe" % "config" % "1.3.3",
  "io.get-coursier" %% "coursier" % "1.0.3",
  "io.get-coursier" %% "coursier-cache" % "1.0.3",
  "org.scala-sbt" % "sbt" % "1.2.1"
)
