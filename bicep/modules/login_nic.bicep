param region string
param numberOfInstances int
param subnetId string

resource loginNSG 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'loginNSG'
  location: region
}
resource loginNIC 'Microsoft.Network/networkInterfaces@2019-11-01' = [ for i in range(1, numberOfInstances): {
  name: 'login${i}NIC'
  location: region
  properties: {
    enableAcceleratedNetworking: true
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: loginNSG.id
    }
  }
}]

output count int = numberOfInstances
output ids array = [for i in range(0, numberOfInstances): loginNIC[i].id]
