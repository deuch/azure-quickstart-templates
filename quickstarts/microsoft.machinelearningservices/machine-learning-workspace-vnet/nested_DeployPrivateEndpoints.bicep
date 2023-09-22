param enablePE bool
param defaultPEConnections array
param blobPEConnections array
param filePEConnections array
param KVPEConnections array
param subnetId string
param privateDnsZoneName object
param privateAznbDnsZoneName object
param privateBlobDnsZoneName object
param privateFileDnsZoneName object
param privateKVDnsZoneName object

param vnetId string

@description('Specifies the name of the Azure Machine Learning workspace.')
param workspaceName string

@description('Required if existing VNET location differs from workspace location')
param vnetLocation string

@description('Tags for workspace, will also be populated if provisioning new dependent resources.')
param tagValues object

@allowed([
  'AutoApproval'
  'ManualApproval'
  'none'
])
param privateEndpointType string

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-05-01' = if (enablePE) {
  name: '${workspaceName}-PrivateEndpoint'
  location: vnetLocation
  tags: tagValues
  properties: {
    privateLinkServiceConnections: ((privateEndpointType == 'AutoApproval') ? defaultPEConnections : json('null'))
    manualPrivateLinkServiceConnections: ((privateEndpointType == 'ManualApproval') ? defaultPEConnections : json('null'))
    subnet: {
      id: subnetId
    }
  }
}

resource privateEndpointBlob 'Microsoft.Network/privateEndpoints@2022-05-01' = if (enablePE) {
  name: '${workspaceName}-PrivateEndpoint-Blob'
  location: vnetLocation
  tags: tagValues
  properties: {
    privateLinkServiceConnections: ((privateEndpointType == 'AutoApproval') ? blobPEConnections : json('null'))
    manualPrivateLinkServiceConnections: ((privateEndpointType == 'ManualApproval') ? blobPEConnections : json('null'))
    subnet: {
      id: subnetId
    }
  }
}

resource privateEndpointFile 'Microsoft.Network/privateEndpoints@2022-05-01' = if (enablePE) {
  name: '${workspaceName}-PrivateEndpoint-File'
  location: vnetLocation
  tags: tagValues
  properties: {
    privateLinkServiceConnections: ((privateEndpointType == 'AutoApproval') ? filePEConnections : json('null'))
    manualPrivateLinkServiceConnections: ((privateEndpointType == 'ManualApproval') ? filePEConnections : json('null'))
    subnet: {
      id: subnetId
    }
  }
}

resource privateEndpointKV 'Microsoft.Network/privateEndpoints@2022-05-01' = if (enablePE) {
  name: '${workspaceName}-PrivateEndpoint-KV'
  location: vnetLocation
  tags: tagValues
  properties: {
    privateLinkServiceConnections: ((privateEndpointType == 'AutoApproval') ? KVPEConnections : json('null'))
    manualPrivateLinkServiceConnections: ((privateEndpointType == 'ManualApproval') ? KVPEConnections : json('null'))
    subnet: {
      id: subnetId
    }
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = if (privateEndpointType == 'AutoApproval') {
  name: privateDnsZoneName[toLower(environment().name)]
  location: 'global'
  tags: tagValues
  properties: {
  }
  dependsOn: [
    privateEndpoint
  ]
}

resource privateAznbDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = if (privateEndpointType == 'AutoApproval') {
  name: privateAznbDnsZoneName[toLower(environment().name)]
  location: 'global'
  tags: tagValues
  properties: {
  }
  dependsOn: [
    privateEndpoint
  ]
}
resource privateBlobDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = if (privateEndpointType == 'AutoApproval') {
  name: privateBlobDnsZoneName[toLower(environment().name)]
  location: 'global'
  tags: tagValues
  properties: {
  }
  dependsOn: [
    privateEndpointBlob
  ]
}

resource privateFileDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = if (privateEndpointType == 'AutoApproval') {
  name: privateFileDnsZoneName[toLower(environment().name)]
  location: 'global'
  tags: tagValues
  properties: {
  }
  dependsOn: [
    privateEndpointFile
  ]
}

resource privateKVDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = if (privateEndpointType == 'AutoApproval') {
  name: privateKVDnsZoneName[toLower(environment().name)]
  location: 'global'
  tags: tagValues
  properties: {
  }
  dependsOn: [
    privateEndpointKV
  ]
}


resource privateDnsZoneVnLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (privateEndpointType == 'AutoApproval') {
  parent: privateDnsZone
  name: uniqueString(vnetId)
  location: 'global'
  tags: tagValues
  properties: {
    virtualNetwork: {
      id: vnetId
    }
    registrationEnabled: false
  }
  dependsOn: [
    privateEndpoint
  ]
}

resource privateAznbDnsZoneVnLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (privateEndpointType == 'AutoApproval') {
  parent: privateAznbDnsZone
  name: uniqueString(vnetId)
  location: 'global'
  tags: tagValues
  properties: {
    virtualNetwork: {
      id: vnetId
    }
    registrationEnabled: false
  }
  dependsOn: [
    privateEndpoint
  ]
}

resource privateBlobDnsZoneVnLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (privateEndpointType == 'AutoApproval') {
  parent: privateBlobDnsZone
  name: uniqueString(vnetId)
  location: 'global'
  tags: tagValues
  properties: {
    virtualNetwork: {
      id: vnetId
    }
    registrationEnabled: false
  }
  dependsOn: [
    privateEndpointBlob
  ]
}

resource privateFileDnsZoneVnLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (privateEndpointType == 'AutoApproval') {
  parent: privateFileDnsZone
  name: uniqueString(vnetId)
  location: 'global'
  tags: tagValues
  properties: {
    virtualNetwork: {
      id: vnetId
    }
    registrationEnabled: false
  }
  dependsOn: [
    privateEndpointFile
  ]
}

resource privateKVDnsZoneVnLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (privateEndpointType == 'AutoApproval') {
  parent: privateKVDnsZone
  name: uniqueString(vnetId)
  location: 'global'
  tags: tagValues
  properties: {
    virtualNetwork: {
      id: vnetId
    }
    registrationEnabled: false
  }
  dependsOn: [
    privateEndpointKV
  ]
}



resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-05-01' = if (privateEndpointType == 'AutoApproval') {
  parent: privateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-api-azureml-ms'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
      {
        name: 'privatelink-notebooks-azure-net'
        properties: {
          privateDnsZoneId: privateAznbDnsZone.id
        }
      }
      {
        name: 'privatelink-blob-core-windows-net'
        properties: {
          privateDnsZoneId: privateBlobDnsZone.id
        }
      }
      {
        name: 'privatelink-file-core-windows-net'
        properties: {
          privateDnsZoneId: privateFileDnsZone.id
        }
      }
      {
        name: 'privatelink-vaultcore-windows-net'
        properties: {
          privateDnsZoneId: privateKVDnsZone.id
        }
      }
    ]
  }
}
