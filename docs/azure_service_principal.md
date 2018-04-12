## Create a Service Principal Account
Pick any one of the two different ways to create a Service Principal.
 - Azure Portal
 - Azure CLI
 
## Using Azure Portal:
 - Login to your Azure account on https://portal.azure.com
 - Navigate to `User setting` under `Azure Active Directory`.
 - Ensure that user can register applications, ONLY an admin user can register applications.
 - Create an `Azure Active Directory application` [(Learn more)](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal?view=azure-cli-latest).
 - Retrieve `application ID` and `authentication key`
 - Assign the newly created application to a role in order to access Azure resources.
 
 If programmatic login is required, remember to retrieve `tenant ID` since you will need to pass this during authentication.[(Learn more)](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal?view=azure-cli-latest).
 
 ## Using Azure CLI :
 - Create an application in Azure Active Directory using the following command
  `az ad sp create-for-rbac --name minio-mapp --password "XXXXXXXXX"`
 
  ```
  $ az ad sp create-for-rbac --name minio-mapp --password "XXXXXXXXX"
  Retrying role assignment creation: 1/36
  Retrying role assignment creation: 2/36
  Retrying role assignment creation: 3/36
  {
    "appId": "04e4c5c8-4c77-4147-b1d9-00a0226be5d3",
    "displayName": "minio-mapp",
    "name": "http://minio-mapp",
    "password": "XXXXXXXXX",
    "tenant": "XXxxXXxx-XXXx-XXXx-XXXx-xxxXXXXXxXxx"
  }
  ```
 - Default option for the role that the new application will take in Azure is "Contributor", this provides more privilages than usual and if required can be restricted to a role with lesser permission, such as a "Reader" role. 

```
$ az role assignment create --assignee 04e4c5c8-4c77-4147-b1d9-00a0226be5d3 --role Reader
{
  "id": "/subscriptions/XXxxXXxx-XXXx-XXXx-XXXx-xxxXXXXXxXxx/providers/Microsoft.Authorization/roleAssignments/1faa99e2-1ceb-48b0-92e9-9aba77078344",
  "name": "1faa99e2-1ceb-48b0-92e9-9aba77078344",
  "properties": {
    "additionalProperties": {
      "createdBy": null,
      "createdOn": "2018-01-18T04:18:03.5317841Z",
      "updatedBy": "XXxxXXxx-XXXx-XXXx-XXXx-xxxXXXXXxXxx",
      "updatedOn": "2018-01-18T04:18:03.5317841Z"
    },
    "principalId": "4ef772e9-bbe2-4ad8-8e9a-a97dd0084169",
    "roleDefinitionId": "/subscriptions/XXxxXXxx-XXXx-XXXx-XXXx-xxxXXXXXxXxx/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7",
    "scope": "/subscriptions/XXxxXXxx-XXXx-XXXx-XXXx-xxxXXXXXxXxx"
  },
  "type": "Microsoft.Authorization/roleAssignments"
}

$ az role assignment delete --assignee 04e4c5c8-4c77-4147-b1d9-00a0226be5d3 --role Contributor

$ az role assignment list   --assignee 04e4c5c8-4c77-4147-b1d9-00a0226be5d3
[
  {
    "id": "/subscriptions/XXxxXXxx-XXXx-XXXx-XXXx-xxxXXXXXxXxx/providers/Microsoft.Authorization/roleAssignments/1faa99e2-1ceb-48b0-92e9-9aba77078344",
    "name": "1faa99e2-1ceb-48b0-92e9-9aba77078344",
    "properties": {
      "additionalProperties": {
        "createdBy": "XXxxXXxx-XXXx-XXXx-XXXx-xxxXXXXXxXxx",
        "createdOn": "2018-01-18T04:18:04.5474392Z",
        "updatedBy": "XXxxXXxx-XXXx-XXXx-XXXx-xxxXXXXXxXxx",
        "updatedOn": "2018-01-18T04:18:04.5474392Z"
      },
      "principalId": "4ef772e9-bbe2-4ad8-8e9a-a97dd0084169",
      "principalName": "http://minio-mapp",
      "roleDefinitionId": "/subscriptions/XXxxXXxx-XXXx-XXXx-XXXx-xxxXXXXXxXxx/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7",
      "roleDefinitionName": "Reader",
      "scope": "/subscriptions/XXxxXXxx-XXXx-XXXx-XXXx-xxxXXXXXxXxx"
    },
    "type": "Microsoft.Authorization/roleAssignments"
  }
]
```
