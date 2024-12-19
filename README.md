# Cyclecloud Mysql

Purpose of this project is to provide a convenient way to set up a mysql database used for HPC environments, primarily for scheduler based job accounting such as slurm job accounting.

This project is NOT meant to be used in production environments for the following reasons:
- It does not support HA
- It does not have any workload based autoscaling
- It does not use TLS 1.2 which is recommended for securing production environments.
- It does not do any automatic archiving/purging. User is responsible for managing their data if the disk is full.

For that reason, public IP address is disabled on this project.
For production environments, users should use [Azure MySQL](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview).
This project is only meant for prototyping and use in dev environments.

## What this does

This sets up a simple basic VM with mysql DB and makes it use the block device for storage. It applies basic minimal configuration to get the SQL server up and running in cyclecloud environment.

The database can then be used for 1 or more slurm clusters for job accounting.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
