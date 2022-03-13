# dynhost-ovh

A simple cronjob to update DynHost on OVH hosting.

> forked from [yjajkiew/dynhost-ovh](https://github.com/yjajkiew/dynhost-ovh)

## Introduction

This repo provides a script to retrieve the public ip of an host and set a dynhost on OVH accordingly.

A docker image and a Chart is also provided for deployment on kubernetes.

> You may also just use `cron` to run the script.


## How it works

1. The command `dig` is used to retrieve the IP address of your domain name.
2. The command `curl` (with the website `ifconfig.co`) is used to retrieve the current public IP address of your machine.
3. The two IPs are compared and if necessary a `curl` command to OVH is used to update your DynHost with your current public IP address.

## Prerequisites

### If running on the host

* `curl` - HTTP calls
* `dig` - DNS lookup

> On ubuntu `dig` is provided by the `dnsutils` package

### If using the Chart

* Kubernetes `1.21`
* helm `3.6.3`

> Other versions might work but were not tested.

## Installing as an hourly CRON

1. Download the `dynhost.sh` script and put it in the folder `/etc/cron.hourly` (to check every hour)
2. Add execution permissions to file : `chmod +x dynhost.sh`
3. Rename `dynhost.sh` to `dynhost` (because `.` at the end of the file name is not allowed in cron)
4. Modify the script with variables : `HOST`, `LOGIN`, `PASSWORD`

## Script parameters

The script uses environment variable as parameters.

| Name       | Description                                    | Value |
| ---------- | ---------------------------------------------- | ----- |
| `HOST`     | **Mandatory** - The dynhost DNS name to update | `""`  |
| `LOGIN`    | **Mandatory** - The dynhost identifier         | `""`  |
| `PASSWORD` | **Mandatory** - The dynhost password           | `""`  |

## Installing the Chart

To install the chart:

```sh
git clone [REPO_CLONE_URL] && cd dynhost-ovh
helm install [RELEASE] chart \
  --set dynhost.host=[DYNHOST_HOST] \
  --set dynhost.login=[DYNHOST_USERNAME] \
  --set dynhost.password=[DYNHOST_PASSWORD]
```

> Make sure to replace the `[...]` accordingly.

> You may also use a `values.yaml` file using `helm install -f [FILE] ...`

## Uninstalling the Chart

```sh
helm uninstall [RELEASE]
```

## Chart parameters

### Common parameters

| Name                         | Description                                                                            | Value                    |
| -----------------------------| -------------------------------------------------------------------------------------- | ------------------------ |
| `dynhost.host`**\***         | The dynhost DNS name to update                                                         | `""`                       |
| `dynhost.login`**\***        | The dynhost identifier                                                                 | `""`                       |
| `dynhost.password`**\***     | The dynhost password                                                                   | `""`                       |
| `dynhost.externalSecretName` | The name of a secret containing the script's parameters to use instead of creating one | `""`                       |
| `suspend`                    | Wether to suspend the cron or not                                                      | `no`                     |
| `schedule`                   | The schedule of the cronjob. Use cron syntax                                           | `0 * * * *` (every hour) |
| `image.repository`           | The docker image repository                                                            | `nox404/dynhost-ovh`     |
| `image.tag`                  | The docker image tag                                                                   | `1.0.0`                  |

> **\*** `dynhost.host`, `dynhost.login`, `dynhost.password` are **Mandatory** unless you provide an external secret with `dynhost.externalSecretName`.

### Extended parameters

| Name                         | Description                                                                            | Value           |
| -----------------------------| -------------------------------------------------------------------------------------- | --------------- |
| `cronjobApiVersion`          | Use this if the cronjob api has a different version in your cluster                    | `batch/v1beta1` |
| `failedJobsHistoryLimit`     | The number of failed jobs to keep                                                      | `1`             |
| `successfulJobsHistoryLimit` | The number of successful jobs to keep                                                  | `1`             |
| `backoffLimit`               | The number of retries to attempt when the job fails                                    | `0`             |
| `image.pullPolicy`           | Image pull policy                                                                      | `IfNotPresent`  |
| `imagePullSecrets`           | Specify image pull secrets                                                             | `[]`            |
| `serviceAccount.create`      | Wether to create a service account                                                     | `true`          |
| `serviceAccount.name`        | Name of the service account to create and/or use                                       | `""`            |
| `podAnnotations`             | Extra pod annotations                                                                  | `{}`            |
| `podSecurityContext`         | The pod security context                                                               | `{}`            |
| `securityContext`            | The container security context                                                         | `{}`            |
| `resources`                  | Specify container resources                                                            | `{}`            |
| `nodeSelector`               | Constrain the pod to specific nodes                                                    | `{}`            |
| `tolerations`                | Pod tolerations                                                                        | `[]`            |
| `affinity`                   | Pod affinities                                                                         | `{}`            |

## Building and publishing the Docker image

```sh
git clone [REPO_CLONE_URL] && cd dynhost-ovh
docker build -f docker/Dockerfile -t [REPOSITORY]:[TAG] .
docker push [REPOSITORY]:[TAG]
```
