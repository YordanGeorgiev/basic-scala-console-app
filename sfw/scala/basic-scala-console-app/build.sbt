// file: sfw/scala/basic-scala-console-app/build.sbt
// http://alvinalexander.com/bookmarks/scala/how-get-anorm-working-without-play-play-framework

// the owner org
organization := "Oranisation Ltd."

// the name of this proj
name := "basic-scala-console-app" 

// the version of this proj
version := "1.0.0"

//obvious 
scalaVersion := "2.11.7"

// ?!
//lazy val root = (project in file(".")).enablePlugins(PlayScala)

// src: http://www.scala-sbt.org/sbt-native-packager/gettingstarted.html
enablePlugins(JavaAppPackaging)



//src: http://stackoverflow.com/a/25534129/65706
resolvers ++= Seq(
  "Typesafe Releases" at "http://repo.typesafe.com/typesafe/releases/")

// obs - use comma space <<lib>> syntax for easier copy paste !!!
libraryDependencies ++= Seq ( 
	//logging libs
	  "ch.qos.logback" %  "logback-classic" % "1.1.7"
	, "commons-lang" % "commons-lang" % "2.6"
	//anorm orm related
	, "mysql" % "mysql-connector-java" % "5.1.24"
	//, "org.mariadb.jdbc" % "mariadb-java-client" % "1.1.8"
   , "com.typesafe.play" %% "anorm" % "2.5.0"
	// lib for the configuration handling src: https://github.com/typesafehub/config
	, "com.typesafe" % "config" % "1.2.1"
 	// lib for read and write to csv file files  
	, "com.github.tototoshi" %% "scala-csv" % "1.3.3"
)
//eof lib dependancies list 


// Purpose : 
// --------------------------------------------------------
// the sbt build filee for the nettilaskuri maintenance project

// --------------------------------------------------------
// eof file: sfw/scala/basic-scala-console-app/build.sbt
