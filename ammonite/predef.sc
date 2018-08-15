// https://github.com/lihaoyi/Ammonite/blob/master/shell/src/main/resources/ammonite/shell/example-predef.sc

import $ivy.`com.typesafe:config:1.3.3`
import ammonite.ops._
import ImplicitWd._
import com.typesafe.config.{Config, ConfigFactory}

import coursier.core.Authentication
import coursier.MavenRepository

// https://github.com/lihaoyi/Ammonite/issues/472
// Show compiler warnings
interp.configureCompiler(_.settings.nowarnings.value = false)

// default imports
import $ivy.`com.google.guava:guava:26.0-jre`

// file system traverse
import $ivy.`org.scala-sbt:sbt:1.2.1`

import sbt.io.PathFinder
import sbt.io.FileFilter.globFilter
import sbt.file
