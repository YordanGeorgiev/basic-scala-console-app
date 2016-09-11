// file: sfw/scala/basic-scala-console-app/build.sbt

// the owner org
organization := "Futurice Oy"

// the name of this proj
name := "basic-scala-console-app" 

// the version of this proj
version := "1.0.0"

//obvious 
scalaVersion := "2.11.7"


// obs - use comma space <<lib>> syntax for easier copy paste !!!
libraryDependencies ++= List ( 
	  "ch.qos.logback" %  "logback-classic" % "1.1.7"
	, "commons-lang" % "commons-lang" % "2.6"
)
//eof lib dependancies list 


// Purpose : 
// --------------------------------------------------------
// the sbt build filee for the nettilaskuri maintenance project

// --------------------------------------------------------
// eof file: sfw/scala/basic-scala-console-app/build.sbt
