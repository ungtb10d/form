# Forms Service Infrastructure as Code

## Platform Description
Forms Service is a shared platform-as-a-service web product built and maintained by the Technology Transformation Services (TTS) Center of Excellence of the US General Services Administration (GSA). The product enables various federal agencies to create digital, sign-able forms as mandated by the 21st Century Integrated Digital Experience Act (21st Century IDEA). The platform offers the following self-service applications:

- developer portal for form development and api management
    - hosted in the test environment
    - domain: portal-test.forms.gov
- form manager portal to design forms and access form submission data
    - enables agencies to create signable forms using a GUI interface
        - after forms are created they are exposed via JSON API
        - a consuming public facing web application embeds the form using this API which allows customers sign and fill in documents
    - hosted in the prod environment
    - domain: portal.forms.gov
- electronic signature portal for agency staff to securely send ad-hoc documents for signature


## Infrastructure Deployment
This section describes how to deploy the cloud infrastructure that runs the Forms Service application.

### Set up your local environment
1. Install the following dependencies
    - git
    - aws-cli
    - terraform
    - terragrunt
1. Configure local aws credentials
    - `aws configure`
      - https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
1. Clone this repository
    - `git clone git@github.com:18F/formservice-iac.git`
1. Review and set the project-specific variables in the following files:
    - `env/env.hcl`
    - `env/provider.tf`
    - `env/region.hcl`
    - `env/terragrunt.hcl`
1. Review and set the AWS account locals in the following files:
    - `env/dev/account.hcl`
    - `env/dev/env.hcl`
    - `env/test/account.hcl`
    - `env/test/env.hcl`
    - `env/prod/account.hcl`
    - `env/prod/env.hcl`

### Deploy new cloud infrastructure
to do

### Deploy updated images to the existing cloud infrastructure
to do

### Deploy bastion host mgmt-server
We use an EC2 instance as a bastion host for miscellaneous management of the cloud infrastructure.

#### Deploy Prisma Cloud Defender on mgmt-server
1. Log in to [Prisma Cloud](https://app.gov.prismacloud.io)
1. Decommission the existing defender on the previous mgmt-server
    1. Navigate to `Compute > Manage > Defenders > Manage`
    1. Select the `...` on the defender
    1. Click **Decommission**
1. Deploy a new Prisma Cloud container defender to the new mgmt-server
    1. Navigate to `Compute > Manage > Defenders > Deploy > Defenders`
    1. Select `Single Defender` on step 1
    1. Select `Container Defender - Linux` on step 6
    1. Copy the curl script on step 8
    1. Paste the curl script in a terminal on the newly deployed mgmt-server to install a new Prisma Cloud container defender
    1. Verify the new defender is running
        1. Navigate to `Compute > Manage > Defenders > Manage tab > Defenders tab`
        1. Verify the ip address of the newly deployed mgmt-server is listed on this page
            - the defender type should be **Container Defender - Linux**
            - we can see more details on the defender by clicking the `...` under the **Actions** column
1. Configure the new Prisma Cloud container defender to scan our AWS Elastic Container Registry
    1. Navigate to `Compute > Defend > Vulnerabilities > Images > Registry Settings`
    1. Under the **Registries** heading, select the `...` for the Amazon EC2 Container Registry, then click **Edit**
        - this is where we tell Prisma the details of our AWS Elastic Container Registry
    1. Select the `ECR Scanner` next to **Scanners scope**
    1. Click the pencil icon to edit the **ECR Scanner**
    1. In the **Hosts** dropdown, select the ip address of the the new mgmt-server
    1. Verify the Prisma Cloud container defender is scanning our Elastic Container Registry
        1. Navigate to `Compute > Vulnerabilities > Images tab > Registries tab`
        1. Click **Scan** to scan our Elastic Container Registry for vulnerabilities

## AWS Systems Manager (SSM)
We use [AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html) (formerly known as *Amazon Simple Systems Manager (SSM)*) to run automated tasks on the ec2 instances that host the running formio containers.

We keep our SSM tasks in the `mgmt` directory for each environment. The following is a summary of the current state of Systems Manager in the `prod` environment:
```
ssm-window-hourly
│ a maintenance window that runs every hour, on the hour
│
└───ssm-target-ecs-hourly
│   │ a maintenance window target that targets all ec2 instances running formio applications
│   │
│   └───ssm-task-reboot-if-docker-dead
│         a maintenance window task that reboots the instance if the docker daemon is dead; FORMS-462
│
└───ssm-target-mgmt-server-hourly
│   │  a maintenance window target that targets the mgmt-server
│   │  
│   └───ssm-task-backup-mgmt-server
│   │     a maintenance window task that backs up faas-prod-mgmt-server files to s3; FORMS-531
│   │
│   └───ssm-task-run-patch-baseline
│         a maintenance window task that applies the default baseline to patch instances, then reboots the instances; FORMS-346
│
└───ssm-target-runtime-submission-epa-hourly
    │  a maintenance window target that targets runtime-submission-epa instances
    │
    └───ssm-task-backup-docker-logs
          a maintenance window task that backs up runtime-submission-epa docker logs to s3; FORMS-820

ssm-window-thurs-7am-et
│ a maintenance window that runs Thursdays at 7am ET
│  
└───ssm-target-ecs-thurs-7am-et
│   │ a maintenance window target that targets all ec2 instances running formio applications
│   │
│   └───ssm-task-run-patch-baseline
│   │     a maintenance window task that applies the default baseline to patch instances, then reboots the instances; FORMS-346
│   │
│   └───ssm-task-set-logfile-permissions
│   │     a maintenance window task sets appropriate permissions on logfiles; FORMS-284
│   │
│   └───ssm-task-update-ecs-agent
│         a maintenance window task that installs available updates for the ecs agent, then restarts docker and starts ecs; FORMS-142
│
└───ssm-target-mgmt-server-thurs-7am-et
    │  a maintenance window target that targets the mgmt-server
    │
    └───ssm-task-run-patch-baseline
          a maintenance window task that applies the default baseline to patch instances, then reboots the instances; FORMS-859

```
