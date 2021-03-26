param location string = resourceGroup().location
param vmAdminUserName string = 'Student'
param vmAdminPassword string = 'Pa55w.rd1234'
param vmDcName string = 'DC'
param vmDcSize string = 'Standard_DS2_v2'
param vmDcSubnetId string
param vmDcIp string
param vmDcNodeConfigurationName string = 'ADDomain_NewForest.localhost'
param aaId string
param aaJobName string

resource dc 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: vmDcName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmDcSize
    }
    storageProfile: {
      imageReference:{
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: '${vmDcName}-Disk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: '${vmDcName}'
      adminUsername: vmAdminUserName
      adminPassword: vmAdminPassword
      windowsConfiguration: {
        timeZone: 'W. Europe Standard Time'
      }
    }
    networkProfile:{
      networkInterfaces: [
        {
          id: dcNic.id
        }
      ]
    }
  }
}
resource dcNic 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: '${vmDcName}-Nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: vmDcIp
          subnet: {
            id: vmDcSubnetId
          }
        }
      }
    ]
  }
}
resource dcExtension 'Microsoft.Compute/virtualMachines/extensions@2020-06-01' = {
  name: '${dc.name}/Dsc'
  location: location
  properties: {
    type: 'DSC'
    publisher: 'Microsoft.Powershell'
    typeHandlerVersion: '2.77'
    autoUpgradeMinorVersion: true
    protectedSettings: {
      Items: {
        registrationKeyPrivate: listKeys(aaId, '2020-01-13-preview').keys[0].value
      }
    }
    settings: {
      Properties: [
        {
          Name: 'RegistrationKey'
          Value: {
            UserName: 'PLACEHOLDER_DONOTUSE'
            Password: 'PrivateSettingsRef:registrationKeyPrivate'
          }
          TypeName: 'System.Management.Automation.PSCredential'
        }
        {
          Name: 'RegistrationUrl'
          Value: reference(aaId, '2020-01-13-preview').registrationUrl
          TypeName: 'System.String'
        }
        {
          Name: 'NodeConfigurationName'
          Value: vmDcNodeConfigurationName
          TypeName: 'System.String'
        }
        {
          Name: 'ConfigurationMode'
          Value: 'ApplyandAutoCorrect'
          TypeName: 'System.String'
        }
        {
          Name: 'RebootNodeIfNeeded'
          Value: true
          TypeName: 'System.Boolean'
        }
        {
          Name: 'ActionAfterReboot'
          Value: 'ContinueConfiguration'
          TypeName: 'System.String'
        }
      ]
    }
  }
}
