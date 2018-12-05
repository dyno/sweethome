// ## Ammonite Shell ##
// http://ammonite.io/#Ammonite-Shell
// https://git.io/vHaKQ
interp.load.ivy(
  "com.lihaoyi" %
    s"ammonite-shell_${scala.util.Properties.versionNumberString}" %
    ammonite.Constants.version)

@  // https://github.com/lihaoyi/Ammonite/issues/744

val shellSession = ammonite.shell.ShellSession()
import shellSession._
import ammonite.ops._
import ammonite.shell._
ammonite.shell.Configure(interp, repl, wd)

// ## Misc Setting ##
// Show compiler warnings
// interp.configureCompiler(_.settings.nowarnings.value = false)
// interp.compiler.settings.nowarnings.value = false
// interp.compiler.settings.feature.value = true

import $ivy.`com.typesafe:config:1.3.3`
import com.typesafe.config.ConfigFactory
// https://github.com/lihaoyi/Ammonite/issues/472
// Show compiler warnings
interp.configureCompiler(_.settings.nowarnings.value = false)

import $file.repositoriesLocal

// default imports
import $ivy.`com.google.guava:guava:26.0-jre`

// it's already default, check `repl.imports`
// import scala.collection.JavaConverters._

// ## Filesystem Walk ##
import $ivy.`org.scala-sbt:sbt:1.2.1` // file system traverse with sbt.io
// sbt has better file traversal
import sbt.io.PathFinder
import sbt.file

import sbt.io.FileFilter.globFilter // implicit f:String => FileFilter
/*
val finder = PathFinder(file(".")) / "build.sbt"
 */

// Files.walk in Java => os.walk in Python
// https://stackoverflow.com/questions/2637643/how-do-i-list-all-files-in-a-subdirectory-in-scala
import java.nio.file.{ FileSystems, Files }
/*
val cwd = FileSystems.getDefault.getPath(".")
Files.walk(pwd.toNIO).iterator().asScala.filter(Files.isRegularFile(_)).foreach(println)
 */

// ## File IO ##
// https://github.com/jsuereth/scala-arm
import $ivy.`com.jsuereth::scala-arm:2.0`
// import resource._

// ## File Parser ##
// CSV
import $ivy.`com.github.tototoshi::scala-csv:1.3.5`

// Json
import $ivy.`org.json4s::json4s-native:3.6.0`
// http://www.lihaoyi.com/post/uJsonfastflexibleandintuitiveJSONforScala.html
import $ivy.`com.lihaoyi::ujson:0.6.6`

// ## Lens ##
import $ivy.`com.github.julien-truffaut::monocle-core:1.5.0`
import $ivy.`com.github.julien-truffaut::monocle-macro:1.5.0`

// ## Macro ##
import $plugin.$ivy.`org.scalamacros:::paradise:2.1.1`

// ## Plot ##
val cibotechRepo = coursier.MavenRepository("https://dl.bintray.com/cibotech/public")
interp.repositories() ++= Seq(cibotechRepo)

interp.load.ivy("com.cibo" %% "evilplot-repl" % "0.4.1")

// ## REPL Prompt ##
repl.prompt.bind(wd.segments.toList.lastOption.getOrElse("") + "/ @ ")

// ## From Bash ##
/*
  cd ~  -- cd! Path.home

  vim ~/.ammonite/pred.sc --
  val predef = Path.home/ ".ammonite" / "predef.sc"
  %vim predef

  source x.sh -- interp.load.module("x.sc"), import $exec.x
  history  -- repl.history
 */

/**
 * https://github.com/lihaoyi/Ammonite/blob/master/shell/src/main/resources/ammonite/shell/example-predef.sc
 * https://github.com/lihaoyi/Ammonite/blob/master/internals-docs/predef.md
 * http://ammonite.io/#Configuration
 * http://www.lihaoyi.com/post/ScalaScriptingGettingto10.html
 */
