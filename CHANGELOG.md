# Changelog
All notable changes to this project will be documented in this file. Changes to the dev and test environments are documented in the **Unreleased** section; changes to the prod environment are documented with the updated version and date the change was Deployed.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- 2022-08-11 FORMS-1037 Deployed nginx:1.23.1-alpine-nonroot-user to pdf-server in the forms 1.2 dev environment
- 2022-08-10 FORMS-1037 Deployed nginx:1.23.1-alpine-nonroot-user to api-server in the forms 1.2 dev environment
- 2022-07-14 FORMS-935 Deployed formio-enterprise:7.4.0 to forms 1.2 in test environment
- 2022-07-14 FORMS-981 Deployed nginx:1.23.0 to all services in FS 1.2 test environment
- 2022-07-14 FORMS-987 Deployed pdf-server:3.3.9 to FS 1.2 test environment
- 2022-07-11 FORMS-934 Deployed formio-enterprise:7.4.0 to forms 1.1 and forms 1.2 in dev environment
- 2022-07-11 FORMS-980 Deployed nginx:1.23.0-alpine-nonroot-user to all services in FS 1.2 dev environment

## [1.2.2] - 2022-07-22
### Changed
- 2022-07-22 FORMS-1005 Increased memory, cpu for api-server in 1.2 dev, test, prod environments

### Removed
- 2022-07-21 FORMS-1004 Removed epa and irs portals in FS 1.2 dev
- 2022-07-19 FORMS-1006 Removed aws systems manager tasks from 1.1 dev, test, prod environments
    - only mgmt-server ssm tasks remain to patch and back up the instance

## [1.2.1] - 2022-07-21
### Changed
- 2022-07-20 Updated api-server memory from 1024 to 2560 in dev, test, prod

## [1.2.0] - 2022-07-09
### Changed
- 2022-07-09 Deployed Forms Service 1.2 to prod environment

## [1.1.7] - 2022-06-09
### Changed
- 2022-06-09 FORMS-915 Deployed nginx:1.22.0-alpine-nonroot-user to all formio apps in prod environment
- 2022-06-09 FORMS-916 Deployed redis:6.2.7-alpine3.16 to runtime-submission in the prod environment
- 2022-06-09 FORMS-914 Deployed ami-04372bb35fbf4e9d3 to all formio instances in the prod environment
- 2022-06-07 FORMS-903 Deployed redis:6.2.7-alpine3.16 to runtime-submission in the test environment
- 2022-06-07 FORMS-902 Deployed nginx:1.22.0-alpine-nonroot-user to all formio apps in test environment
- 2022-06-07 FORMS-901 Deployed ami-04372bb35fbf4e9d3 to all formio instances in the test environment
- 2022-06-03 FORMS-898 Deployed ami-04372bb35fbf4e9d3 to all formio instances in the dev environment
- 2022-06-03 FORMS-894 Deployed nginx:1.22.0-alpine-nonroot-user to all formio apps in dev environment
- 2022-06-01 FORMS-893 Deployed redis:6.2.7-alpine3.16 to runtime-submission in dev

## [1.1.6] - 2022-06-03
### Changed
- 2022-06-03 FORMS-892 Deployed formio-enterprise:7.3.3 to hub-formio and runtime-submission-epa apps in prod
- 2022-06-03 FORMS-891 Deployed pdf-server:3.3.8 to the hub-formio and runtime-submission-epa apps in the prod environment
- 2022-06-03 FORMS-863 Deployed nginx:1.21.6-alpine-nonroot-user to hub-formio and runtime-submission apps in prod environment
- 2022-06-03 FORMS-862 Deployed ami-0fea79bafb589ff8e to all formio instances in prod environment
- 2022-05-31 FORMS-883 Deployed pdf-server:3.3.8 to the hub-formio app in the test environment
- 2022-05-31 FORMS-884 Deployed formio-enterprise:7.3.3 to hub-formio in test
- 2022-05-25 FORMS-885 Added `.cdn.form.io` to `faas-<env>-hub-allowed-domains` in dev, test, prod
  - in the date/time form field, timezones are loaded from `cdn.form.io`
  - when a user attempted to render a pdf in the dev environment, this cdn was blocked by our firewall and the pdf-server container crashed the application
- 2022-05-25 FORMS-881 Deployed formio-enterprise:7.3.3 to the hub-formio app and runtime-submission-epa apps in the dev environment
- 2022-05-25 FORMS-832 Redeployed pdf-server:3.3.8 to the hub-formio app in the dev environment
- 2022-05-24 FORMS-854 Deployed image nginx:1.21.6-alpine-nonroot-user to the hub-formio and runtime-submission apps in the test environment
- 2022-05-18 FORMS-242 Deployed image nginx:1.21.6-alpine-nonroot-user to the hub-formio, runtime-submission, and runtime-submission-epa apps in the dev environment
  - this image runs nginx:1.21.6-alpine as an unprivileged user to comply with CIS_Docker_v1.2.0 - 4.1
- 2022-05-24 FORMS-861 Deployed ami-0fea79bafb589ff8e to the hub-formio and runtime-submission apps in the test environment
- 2022-05-12 FORMS-832 Deployed pdf-server:3.3.8 to the hub-formio app in the dev environment
  - this image has fewer vulnerabilities than the previous version, pdf-server:3.3.6
- 2022-05-05 FORMS-798 Deployed ami-0fea79bafb589ff8e to all formio instances in the dev environment
  - this ami has 6 fewer known exploited vulnerabilities than the previous ami

## [1.1.5] - 2022-05-20
### Added
- 2022-05-20 FORMS-859 Added ssm-task-run-patch-baseline to ssm-target-mgmt-server-thurs-7am-et in the dev and prod environments
  - this runs the default patch baseline on the dev-mgmt-server and prod-mgmt-server each week on Thursdays at 7am ET
- 2022-05-18 FORMS-850 Replaced documentdb tls certificates in dev, test, and prod
  - we replaced the documentdb tls certificates in each environment

## [1.1.4] - 2022-05-13
### Added
- 2022-05-13 FORMS-820 Deployed ssm-task-backup-docker-logs to the runtime-submission-epa app in the prod environment
    - `env/prod/mgmt/ssm-task-backup-docker-logs` is an AWS Systems Manager maintenance window task that backs up runtime-submission-epa docker logs to s3
    - `env/prod/mgmt/s3-bucket-epa-docker-logs` creates an s3 bucket to host the logfiles
    - this is a stop-gap measure to collect logs from the running containers considering we Removed the awslogs log driver on 2022-05-04 due to performance issues
### Removed
- 2022-05-13 FORMS-820 Removed the elastic beanstalk environment variable `DEBUG=*` to turn off debug mode in the runtime-submission-epa app in the prod environment
    - we believe this environment variable was generating significantly more docker logs, which caused the `docker logs` command to hang and cpu to spike

## [1.1.3] - 2022-05-05
### Added
- 2022-05-05 FORMS-815 Deployed ssm-task-run-patch-baseline to the prod environment
- 2022-05-03 FORMS-804 Deployed ssm-task-run-patch-baseline to the test environment
- 2022-04-26 FORMS-346 Deployed ssm-task-run-patch-baseline to the dev environment

### Removed
- 2022-05-04 FORMS-805 Removed awslogs log driver from runtime-submission-epa app in prod
- 2022-05-03 FORMS-801 Removed awslogs log driver from hub-formio and runtime-submission apps in the test environment

## [1.1.2] - 2022-04-28
### Changed
- 2022-04-28 FORMS-778 Deployed:
    - ami-0968bfb2bef6a026e to hub-formio and runtime-submission prod
    - formio-enterprise:7.3.2 to runtime-submission-epa prod
- 2022-04-26 FORMS-776 Deployed ami-0968bfb2bef6a026e to hub-formio and runtime-submission test
- 2022-04-21 FORMS-748 Deployed ami-0968bfb2bef6a026e to hub-formio and runtime-submission dev

## [1.1.1] - 2022-04-21
### Changed
- 2022-04-21 FORMS-747 Deployed formio-enterprise:7.3.2 to hub-formio prod
- 2022-04-19 FORMS-738 Deployed formio-enterprise:7.3.2 to hub-formio test
- 2022-04-14 FORMS-717 Deployed formio-enterprise:7.3.2 to hub-formio dev

## [1.1.0] - 2022-04-14
### Removed
- 2022-04-14 FORMS-709 Removed cis docker recommendation 5.12 from prod
- 2022-04-12 FORMS-708 Removed cis docker recommendation 5.12 from test
- 2022-04-07 FORMS-706 Removed cis docker recommendation 5.12 from dev

## [1.0.3] - 2022-04-07
### Changed
- 2022-04-07 FORMS-696 Deployed:
    - ami-03a0f325a864730cb to hub-formio prod
    - pdf-server:3.3.6 to hub-formio prod
    - ami-03a0f325a864730cb to runtime-submission prod
- 2022-04-05 FORMS-691 Deployed:
    - ami-03a0f325a864730cb to hub-formio test
    - pdf-server:3.3.6 to hub-formio test
    - ami-03a0f325a864730cb to runtime-submission test
- 2022-04-01 FORMS-687 Deployed:
    - ami-03a0f325a864730cb to hub-formio dev
    - pdf-server:3.3.6 to hub-formio dev
    - ami-03a0f325a864730cb to runtime-submission dev

## [1.0.2] - 2022-03-31
### Changed
- 2022-03-31 FORMS-619 Deployed:
    - nginx:1.21.6-alpine to hub-formio prod
    - nginx:1.21.6-alpine to runtime-submission prod
    - pdf-server:3.3.5 to hub-formio prod
    - submission-server:9.0.33 to runtime-submission prod
- 2022-03-29 FORMS-617 Deployed:
    - nginx:1.21.6-alpine to hub-formio test
    - nginx:1.21.6-alpine to runtime-submission test
    - pdf-server:3.3.5 to hub-formio test
    - submission-server:9.0.33 to runtime-submission test
- 2022-03-24 FORMS-617 Deployed:
    - nginx:1.21.6-alpine to hub-formio dev
    - nginx:1.21.6-alpine to runtime-submission dev
    - pdf-server:3.3.5 to hub-formio dev
    - submission-server:9.0.33 to runtime-submission dev

## [1.0.1] - 2022-03-24
### Added
- 2022-03-24 FORMS-522 Deployed CIS docker controls cis-5.12, cis-5.25 to hub-formio and runtime-submission prod
- 2022-03-22 FORMS-558 Deployed CIS docker controls cis-5.12, cis-5.25 to hub-formio and runtime-submission test
- 2022-03-17 FORMS-562 Deployed CIS docker controls cis-5.12, cis-5.25 to hub-formio and runtime-submission dev

### Changed
- 2022-03-22 FORMS-613 Deployed ami-08f23b677a6ee3765 to hub-formio and runtime-submission test
- 2022-03-22 FORMS-612 Deployed ami-08f23b677a6ee3765 to hub-formio and runtime-submission test
- 2022-03-17 FORMS-611 Deployed ami-08f23b677a6ee3765 to hub-formio and runtime-submission dev
- ami-08f23b677a6ee3765 configures/enables selinux on the docker daemon on the host machine

## [1.0.0] - 2022-03-10
### Changed
- 2022-03-10 FORMS-383 Deployed formio-enterprise:7.3.1 to hub-formio prod
- 2022-03-10 FORMS-383 Deployed pdf-server:3.3.1 to hub-formio prod
