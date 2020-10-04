[Query command results with Azure CLI | Microsoft Docs](https://docs.microsoft.com/en-us/cli/azure/query-azure-cli?view=azure-cli-latest)

## Dictionary or Array
* Dictionary
    * aka object
    * key value pairs
    * curly brackets `{}`
* Array
    * sequence of objects
    * can be indexed
    * square brackets `[]`

[Microsoft Docs:][Microsoft Docs] Az commands that could return more than one object return an array, and commands that always return only a single object return a dictionary.

## How to query a Dictionary
Our example is
```bash
az account show  # returns a single dictionary {}
```

### Query for a single value
```bash
az account show --query "id"  # query for the value of a key value-pair
```
```bash
az account show --query "user" # returns a nested object
```
```bash
az account show --query "user.name" # . (dot) operator
```

### Query for a multiple values

```bash
az account show --query "id"
az account show --query "isDefault"
az account show --query "[id,isDefault]"  # returns two values as an array []
```
The output of the last line above is an array. The objects inside that array are simple values, no keys are present. 

If you want to have an single object of the query results instead use
```bash
az account show --query "{id:id,isDefault:isDefault}"  # returns an object {} with two key value-pairs
```
Name the keys whatever you want
```bash
az account show --query "{foo:id,bar:isDefault}"
```





```bash

```

[Microsoft Docs]: https://docs.microsoft.com/en-us/cli/azure/query-azure-cli?view=azure-cli-latest