# mqldt-c
This repository contains the Containerized version of mqldt.

It consists of a Dockerfile to create the docker image, mqldt binary executable and scripts to run a set of MQLDT tests.

The mqldt binary executable included was compiled in February 2020 on x64. Obviously this can be updated with one built from the mqldt repo [here](https://github.com/ibm-messaging/mqldt).

This repo is built automatically and the image is available [here](https://hub.docker.com/r/stmassey/mqldt).

To build your own image, simply clone this repository and run:
```
docker build -t mqldt .
```

To pull the hosted image simply use:
```
docker pull stmassey/mqldt
```

To run a set of MQLDT tests, provide a directory on the volume you wish to test as a parameter to `docker run` and mount it at /var/mqldt:
```
docker run -itd --volume /var/dvm:/var/mqldt mqldt
```

The command above mounts /var/dvm from the host into the container at mount point /var/mqldt and will result in the creation of 1GB of test files, so ensure you have enough storage available in the provided directory/fs.

To run against a larger set of files, set the envvar `MQLDT_NUMFILES`; the following runs with a 4GB set of test files:
```
docker run -itd --env MQLDT_NUMFILES=64 --volume /var/dvm:/var/mqldt mqldt
```

The full set of supported docker environment variables are:

| Envvar                  | Description                                          | Default if not set |
|-------------------------|------------------------------------------------------|--------------------|
| MQLDT_DIRECTORY         | Directory to store test files                        | /var/mqldt         |
| MQLDT_NUMFILES          | Number of test files to use                          | 16                 |
| MQLDT_FILESIZE          | Size of each test file to write to (bytes)           | 67108864           |
| MQLDT_DURATION          | Duration of each test cycle (sec)                    | 60                 |
| MQLDT_CSVFILE           | Name of CSV file where results are logged (Results are also sent to stdout) | mqldt.csv |
| MQLDT_QM		  | Number of Queue Managers to simulate		 | 1                  |

If you run a simulation with more than one Queue Manager, a 128K block size will be selected and results will be measured for each queue manager up to the stated number. A maximum of 10 queue managers is currently supported. Additional directories mqldt1, mqldt2 etc. will be created within the provided MQLDT_DIRECTORY. Ensure the permissions of the provided directory support this creation and that there is sufficient space available.

