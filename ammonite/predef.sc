
import ammonite.ops._
import ammonite.ops.ImplicitWd._

import coursier.core.Authentication
import coursier.MavenRepository

import $ivy.`com.typesafe:config:1.3.3`
import com.typesafe.config.ConfigFactory

// https://github.com/lihaoyi/Ammonite/issues/472
// Show compiler warnings
interp.configureCompiler(_.settings.nowarnings.value = false)

// default imports
import $ivy.`com.google.guava:guava:26.0-jre`

import $ivy.`org.scala-sbt:sbt:1.2.1` // file system traverse with sbt.io

import sbt.io.PathFinder
import sbt.file
import sbt.io.FileFilter.globFilter // implicit f:String => FileFilter
val finder = PathFinder(file(".")) / "build.sbt"

/**
  * https://github.com/lihaoyi/Ammonite/blob/master/shell/src/main/resources/ammonite/shell/example-predef.sc
  * https://github.com/lihaoyi/Ammonite/blob/master/internals-docs/predef.md
  * http://ammonite.io/#Configuration
  */
