# mqldt-c
This repository contains the Containerized version of mqldt

It consists of a Dockerfile to create the docker image.

It contains an mqldt binary executable compiled in February 2020 on x64. Obviously this can be updated with one built from the mqldt repo [here](https://github.com/ibm-messaging/mqldt)

The image is available [here](http://dontyetknowwheretohost.theimage.com)

To run a set of MQLDT tests:
```
docker pull <image_name>
docker run -itd --env MQLDT_NUMFILES=64 --volume /var/dvm:/var/mqldt mqldt
```


The full set of supported docker environment variables are:

| Envvar                  | Description                                          | Default if not set |
|-------------------------|------------------------------------------------------|--------------------|
| MQLDT_DIRECTORY         | Directory to store test files                        | /var/mqldt         |
| MQLDT_NUMFILES          | Number of test files to use                          | 16                 |
| MQLDT_FILESIZE          | Size of each test file to write to                   | 67108864           |
| MQLDT_DURATION          | Duration of each test cycle                          | 60                 |
| MQLDT_CSVFILE           | Name of CSV file where results are logged (Results are also sent to stdout) | mqldt.csv |

