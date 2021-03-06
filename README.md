**THIS REPOSITORY HAS BEEN MOVED AND IS NO LONGER MAINTAINED**

Please checkout the new location at https://gitlab.com/naturalis/bii/linnaeus/docker-linnaeusng, you can update your local checkout code by using this command:

```
git remote set-url origin git@gitlab.com:naturalis/bii/linnaeus/docker-linnaeus.git
```

docker-linnaeusng
====================

Docker compose file and docker file for running linnaeus

Persistent volumes
 - `/data/linnaeus/www:/var/www/html`  
   Filled from repository https://github.com/naturalis/linnaeus when empty. 
 - `/data/linnaeus/apachelog:/var/log/apache2`
   apache access and error logs
 - `/data/linnaeus/initdb:/docker-entrypoint-initdb.d`
   initdb 
 - `/data/linnaeus/db:/var/lib/mysql`
   persistent mysql volume

webserver runs on port 80

Contents
-------------
Dockerfile creates the naturalis/linnaeusng container



Instruction building image
-------------
No special instructions

```
docker build -t naturalis/linnaeusng:0.0.1 .
```

Instruction running docker-compose.yml
-------------

#### preparation
- Copy env.template to .env and adjust variables. 
- Copy initdb directory to /data/linnaeus/initdb
- Edit /data/linnaeus/initdb/1_init.sql and adjust PASSWORD to correct password set in .env
- Copy mysql_config_template to  /data/linnaeus/mysqlconf/custom_config.cfg


````
docker-compose up -d
````


Setting up the development environment
-------------

- Install Docker or [Docker for Mac](https://docs.docker.com/docker-for-mac/)
- Copy env.template to .env and adjust variables. 
- Create a `./linnaeus` directory
- Copy initdb directory to `./linnaeus/initdb`
- Edit `/data/linnaeus/initdb/1_init.sql` and adjust PASSWORD to correct password set in .env
- Clone the code of linneaus `git clone git@github.com:naturalis/linnaeus_ng.git ./linnaeus/www`
- Start `docker-compose up` first without the 'd' to monitor what is happening
- Connect to the database using your favorite database view (for instance Sequel Pro) using 
the variables in the  .env file and port 3307
- Upload a recent linnaeus database
- Follow the instruction of the linneaus install to create the necessary composer projects and javascript/css files
- Test the linneaus installation in your browser

Persistent volumes
 - `"./linnaeus/www:/var/www/html"`  
   Filled from repository https://github.com/naturalis/linnaeus when empty. 
 - `"./linnaeus/apachelog:/var/log/apache2"`
   apache access and error logs
 - `"./linnaeus/initdb:/docker-entrypoint-initdb.d"`
   initdb 
 - `"./linnaeus/db:/var/lib/mysql"`
   persistent mysql volume

webserver runs on port 80
databaseserver runs on port 3307
mailhog runs on 1025 
and its webinterface on 8025

##Mailhog

To configure mailhog with your linnaeus project. You should set the following general settings.

```
UPDATE `module_settings` SET `default_value` = '{\"host\":\"mailhog\",\"smtp_auth\":0,\"username\":\"\",\"password\":\"\",\"encryption\":\"\",\"port\":1025, \"sender_mail\" : \"noreply@naturalis.nl\", \"sender_name\" : \"Linnaeus NG\" }' WHERE `id` = '97';
```

or use this json

```
{"host":"mailhog","smtp_auth":0,"username":"","password":"","encryption":"","port":1025, "sender_mail" : "noreply@naturalis.nl", "sender_name" : "Linnaeus NG" }
```

