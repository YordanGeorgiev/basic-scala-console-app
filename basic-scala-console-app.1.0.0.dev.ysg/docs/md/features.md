#  FEATURES
This document presents the existing features of this tool

## 1. Deployability
The basic-scala-console-app app is deployable via a single one liner.

### 1.1. Full package creation
You can create full packages of your product by issuing the following call:
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-full-package

Note the files to be included in the full package creation are stored as relative
file paths in the <<product_version_dir>>/meta/components/basic-scala-console-app/.include file


if you have configured a network_backup_dir in your configuration files
the full deploymment package will be copied there as well ...


Later on if you want to start developing on a different host you could simply

unzip -o <<produced_package>> -d <<destination_base_dir>>
cd <<new_product_version_dir>>
vim -o `find . -name .include`

#### 1.1.1. Full package creation of contained app
You can create a full package based on the file paths specified in an include file of an app, which is "contained" in the current app - that is it has its own include file by issuing the following command:
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-full-package -i <<contained-app-include-file>>

### 1.2. Deployment package creation
You can create deployment packages of your product by issuing the following call:
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-deployment-package

Note the files to be included in the deployment package creation are stored as relative
file paths in the <<product_version_dir>>/meta/components/basic-scala-console-app/.deploy file

Later on if you want to start developing on a different host you could simply

unzip -o <<produced_package>> -d <<destination_base_dir>>
cd <<new_product_version_dir>>
vim -o `find . -name .include`

### 1.3. Relative package creation
You can create a relative package based on the file paths specified in an include file by issuing the following command:
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-relative-package

You can override the default meta/.include-basic-scala-console-app file with another relative paths by using the -i argument
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-relative-package -i <<path-to-another-include-file>>

#### 1.3.1. Relative package creation
You can create a relative package based on the file paths specified in an include file of an app, which is "contained" in the current app - that is it has its own include file by issuing the following command:
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-relative-package -i <<contained-app-include-file>>

#### 1.3.2. Package files removal 
Once an app is deployed you could remove all its files by issuing the following command:
$0 -a remove-package-files

#### 1.3.3. Package  removal 
Once an app is deployed you could remove it by issuing the following command:
$0 -a remove-package

### 1.4. Application Mutability
You can clone or morph or mutate the basic-scala-console-app app into different version , environments and even different app.

#### 1.4.1. Clone to version
you can clone the current version of the your app into ANY version of the type <<major>>.<<minor>>.<<revision>> ( for example  1.0.0 , 1.2.3 etc. ) by issuing the following call:


bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-ver=0.1.8

#### 1.4.2. clone to environments
you can clone the following environments: dev tst qas prd
dev stands for development
tst stands for testing
qas stands for quality assurance
prd stands for production



bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-dev
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-tst
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-qas
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-prd


you can check now the created environments by:
find ../ -type d -maxdepth 1 | sort -nr

this WILL DELETE all the files you had in the previous

#### 1.4.3. clone to another app
You can clone or morph or mutate the basic-scala-console-app app into different version , environments and even different app.

## 2. DOCUMENTATION
This document presents the existing features of this tool

### 2.1. Display Usage
you can display the basic usage of the script by running the following call:

bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -u
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -usage
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh --usage

### 2.2. Display Help
you can display the help by isssueing the following shell call:

bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -h
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -help
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh --help

## 3. DEVELOPMENT
This document presents the existing features of this tool

### 3.1. Display Usage
you can display the basic usage of the script by running the following call:

bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -u
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -usage
bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh --usage


