/**
 * ## Nexus Repositories ##
 */

import java.util.Base64
import ammonite.ops.{ Path, home }
import coursierapi._

import $ivy.`com.typesafe:config:1.3.3`
import com.typesafe.config.ConfigFactory

val gradleProperties = home / ".gradle" / "gradle.properties"
val gradleConfig = ConfigFactory.parseFile(gradleProperties.toIO)
val nexusUsername = gradleConfig.getString("nexusUsername")
val nexusPassword = if (gradleConfig.hasPath("nexusEncPassword")) {
  val nexusEncPassword = gradleConfig.getString("nexusEncPassword")
  Base64.getDecoder.decode(nexusEncPassword).map(_.toChar).mkString.trim
} else {
  gradleConfig.getString("nexusPassword")
}

val nexusRepoUrlList = List[String]()
interp.repositories() ++= nexusRepoUrlList.map(url => MavenRepository.of(url).withCredentials(Credentials.of(nexusUsername, nexusPassword)))

/**
 * ## Local Repositories ##
 *
 * https://github.com/lihaoyi/Ammonite/pull/612, Resolution of local Maven artifacts does not work
 */

val mavenRepoLocal = MavenRepository.of("file://" + java.lang.System.getProperties.get("user.home") + "/.m2/repository/")
interp.repositories() ++= Seq(mavenRepoLocal)
