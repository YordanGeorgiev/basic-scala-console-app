import ch.qos.logback.core._
import org.slf4j.LoggerFactory
import ch.qos.logback.core.util.StatusPrinter
import ch.qos.logback.classic.LoggerContext


// src: 	http://alvinalexander.com/scala/how-to-use-java-style-logging-slf4j-scala
class Pizza {

	val objLogger = LoggerFactory.getLogger(classOf[Pizza])
	objLogger.info("Hello from the Pizza class")
}
//eof class Pizza


// this is the main entry of the program
object Main extends App {

	// println ( "START --- App " ) 
  	val objLogger = LoggerFactory.getLogger(classOf[App])
	
	// var vs. val -> chk: http://stackoverflow.com/a/33066906/65706
	var msg = " START -- basic scala console App"
	objLogger.info ( msg )

	val infoMsg = "this is an info msg " 
	val debugMsg = "this is a debug msg" 
	val warnMsg = "this is a warn msg" 
	val errorMsg = "this is an error msg" 

	val p = new Pizza
	objLogger.warn ( warnMsg ) 
	objLogger.info ( infoMsg ) 
	objLogger.debug ( debugMsg ) 
	objLogger.error ( errorMsg ) 
	
	msg = " STOP  -- basic scala console App"
	// println ( msg ) 
	objLogger.info ( msg )

}
//eof obj Main
