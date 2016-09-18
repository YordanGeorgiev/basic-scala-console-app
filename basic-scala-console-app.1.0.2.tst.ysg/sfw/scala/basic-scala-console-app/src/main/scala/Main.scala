package app 

import ch.qos.logback.core._
import org.slf4j.LoggerFactory
import ch.qos.logback.core.util.StatusPrinter
import ch.qos.logback.classic.LoggerContext
import scala.collection.mutable.Map

import java.io.File

import app.utils.Configurator

/**
* Purpose: the main entry of the console app
*/
object Main extends App {

	// check: any better way of resolving the main class path ?!
	val scalaProjKickOffDir = 
		getClass().getProtectionDomain().getCodeSource().getLocation().toURI().getPath().toString()
	
	// doc: START :: foreach db 
	val objConfigurator = new Configurator ( scalaProjKickOffDir ) 
	
	// src: http://alvinalexander.com/scala/how-to-use-java-style-logging-slf4j-scala
  	val objLogger = LoggerFactory.getLogger(classOf[App])
	var msg = " START: basic-scala-console-app App"
	objLogger.info ( msg )

	msg = "  STOP: basic-scala-console-app App"
	objLogger.info ( msg )

}
//eof obj Main
