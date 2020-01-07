/**
 * ## Ammonite Shell ##
 *
 * http://ammonite.io/#Ammonite-Shell
 * https://git.io/vHaKQ
 */

interp.load.ivy(
  "com.lihaoyi" %
    s"ammonite-shell_${scala.util.Properties.versionNumberString}" %
    ammonite.Constants.version)

@  // multistage scripts. http://ammonite.io/#Multi-stageScripts
import ammonite.ops._

// -----------------------------------------------------------------------------
// repos.sc - to access repos
// sparkjars.sc - for AmmoniteSparkSession
val modules = List("repos.sc", "repoRealNexus.sc", "sparkjars.sc")
modules map { pwd / _ } filter { os.exists } foreach { interp.load.module }

// -----------------------------------------------------------------------------
val shellSession = ammonite.shell.ShellSession()
import shellSession._
ammonite.shell.Configure(interp, repl, wd)

interp.configureCompiler(_.settings.nowarn.value = false)
