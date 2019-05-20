/**
 * ## Local Repositories ##
 *
 * https://github.com/lihaoyi/Ammonite/pull/612, Resolution of local Maven artifacts does not work
 */

import coursier.MavenRepository

val mavenRepoLocal = MavenRepository("file://" + java.lang.System.getProperties.get("user.home") + "/.m2/repository/")
interp.repositories() ++= Seq(mavenRepoLocal)
