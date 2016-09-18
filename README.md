# basic-scala-console-app
a basic stub like scala console application to start (unit) coding on scala

It might help you configure your environment better as well as understand the scala related stack ...


     # go to a dir
     cd /opt
     # clone the repo
     git clone git@github.com:YordanGeorgiev/basic-scala-console-app.git

     # to the dev dir of the latest version
     cd /opt/basic-scala-console-app
     
     # run the sbt-clean-compile
     bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a sbt-clean-compile
     
     # run the sbt-compile
     bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a sbt-compile
     
     # run the sbt-run
     bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a sbt-run
     
	  # produced a standalone deployable jar
     bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a sbt-stage

	  # run the the standalone deployable jar
     bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a sbt-stage -a jar-run

	  # you could combile shells actions like this 
     bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a sbt-stage -a jar-run

	  # for more info on the usage of the commands:
	  bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh --usage
