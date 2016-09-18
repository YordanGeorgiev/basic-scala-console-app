package app.utils

import util.control.Breaks._

import ch.qos.logback.core._
import org.slf4j.LoggerFactory
import ch.qos.logback.core.util.StatusPrinter
import ch.qos.logback.classic.LoggerContext

import java.io.File
import com.typesafe.config.{ Config, ConfigFactory }


/**
 *
 * Encapsulates the app global configuration logic
 */
case class Configurator ( scalaProjKickOffDir: String) {
	
	val scalaProjDir: String = 			getScalaProjDir ( scalaProjKickOffDir )
	val product_version_dir: String = 	getProductVersionDir ( scalaProjDir )

	// src: https://www.mkyong.com/logging/logback-set-log-file-name-programmatically/
	System.setProperty("product_version_dir", product_version_dir);

	// src: http://alvinalexander.com/scala/how-to-use-java-style-logging-slf4j-scala
  	val objLogger = LoggerFactory.getLogger(classOf[Configurator])

	val confDir = scalaProjDir + "/conf" 
	val dataDir = product_version_dir + "/data/basic-scala-console-app" 
	val dbDataDir = dataDir + "/db" 
	val mySqlDataDir = dbDataDir + "/mysql" 
	doLogDirs

	val objGlobalAppConf = getGlobalAppConf
	objLogger.debug ( objGlobalAppConf.toString )
  

  /**
   * Resolve the scala project dir by utilizing the sfw/scala/proj_name naming convention
   * @param scalaProjKickOffDir 	the dir resolved via reflection from the Main class file
   */
	def getScalaProjDir ( scalaProjKickOffDir: String ) :String = {
		val regex = "(.*)(/sfw/scala/basic-scala-console-app)(.*)".r
		regex.replaceAllIn ( scalaProjKickOffDir , "$1$2")
	}
	//eof def getScalaProjDir


  /**
   * Resolve the product version dir hosting one or many scala projects by naming convention
   * @param scalaProjDir 	the dir resolved via reflection from the Main class file
   */
	def getProductVersionDir ( scalaProjDir: String ) :String = {
		val regex = "/sfw/scala/basic-scala-console-app".r
		regex.replaceAllIn ( scalaProjDir , "")
	}
	//eof def getScalaProductVersionDir
	

	// load the configuration object  - only if explicitly
	// objGlobalAppConf = ConfigFactory.load


  /**
  	* 
   */
	def getGlobalAppConf = {
		ConfigFactory.parseFile(new File(confDir + "/" + "application.conf"))
	}


  /**
   * @param file 	the file to get the custom config object for
   */
	def getCustomConfig ( file : String ) = {
		ConfigFactory.parseFile( new File ( file ) )
	}


  /**
  	* Just print the run-time resolved dir configuration
   */
	def doLogDirs = {

		var msg = " scalaProjDir: " + scalaProjDir
		objLogger.info ( msg ) 

		msg = " confDir: " + confDir
		objLogger.info ( msg ) 

		msg = " product_version_dir: " + product_version_dir
		objLogger.info ( msg ) 

		msg = " dataDir: " + dataDir
		objLogger.info ( msg ) 

		msg = " dbDataDir: " + dbDataDir
		objLogger.info ( msg ) 

	}
	//eof def doLogDirs


}
//eof class Configurator
