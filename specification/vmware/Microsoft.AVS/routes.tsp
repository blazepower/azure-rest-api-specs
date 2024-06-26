import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using OpenAPI;

namespace Microsoft.AVS;

interface Operations extends Azure.ResourceManager.Operations {}

@armResourceOperations
interface Locations {
  @doc("Return trial status for subscription by region")
  @armResourceAction(Location)
  checkTrialAvailability(
    ...ResourceInstanceParameters<Location>,

    @doc("Optionally, check for a specific SKU")
    @body
    sku?: ResourceSkuType,
  ): ArmResponse<Trial> | ErrorResponse;

  @doc("Return quota for subscription by region")
  @armResourceAction(Location)
  @post
  checkQuotaAvailability(
    ...ResourceInstanceParameters<Location>,
  ): ArmResponse<Quota> | ErrorResponse;
}

@armResourceOperations
interface PrivateClouds {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("PrivateClouds_List")
  list is ArmResourceListByParent<PrivateCloud>;

  listInSubscription is ArmListBySubscription<PrivateCloud>;

  get is ArmResourceRead<PrivateCloud>;

  createOrUpdate is ArmResourceCreateOrUpdateAsync<PrivateCloud>;

  // This could be modeled with ArmCustomPatchAsync if a 202 response with no body is used instead of a 201.
  // update is ArmCustomPatchAsync<PrivateCloud, PrivateCloudUpdate>;
  @doc("Update a PrivateCloud")
  @extension("x-ms-long-running-operation", true)
  @extension(
    "x-ms-long-running-operation-options",
    {
      `final-state-via`: "location",
    }
  )
  @armResourceUpdate(PrivateCloud)
  @patch
  update(
    ...ResourceInstanceParameters<PrivateCloud>,

    @body
    @doc("The private cloud properties to be updated.")
    privateCloudUpdate: PrivateCloudUpdate,
  ): ArmResponse<PrivateCloud> | {
    // @doc("Resource update request created.")
    ...CreatedResponse;

    ...Azure.Core.Foundations.RetryAfterHeader;
    ...LocationHeader;

    @body
    @doc("The updated private cloud.")
    placementPolicy: PrivateCloud;
  } | ErrorResponse;

  #suppress "deprecated"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes"
  delete is ArmResourceDeleteAsync<PrivateCloud>;

  @doc("Rotate the vCenter password")
  rotateVcenterPassword is ArmResourceActionNoContentAsyncNoRequestBody<PrivateCloud>;

  @doc("Rotate the NSX-T Manager password")
  rotateNsxtPassword is ArmResourceActionNoContentAsyncNoRequestBody<PrivateCloud>;

  @doc("List the admin credentials for the private cloud")
  listAdminCredentials is ArmResourceActionSyncNoRequestBody<
    PrivateCloud,
    AdminCredentials
  >;
}

@@projectedName(PrivateClouds.createOrUpdate::parameters.resource,
  "json",
  "privateCloud"
);
@@OpenAPI.extension(PrivateClouds.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "privateCloud"
);

@armResourceOperations
interface Clusters {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("Clusters_List")
  list is ArmResourceListByParent<Cluster>;

  get is ArmResourceRead<Cluster>;

  createOrUpdate is ArmResourceCreateOrUpdateAsync<Cluster>;

  // This could be modeled with ArmCustomPatchAsync if a 202 response with no body is used instead of a 201.
  // update is ArmCustomPatchAsync<Cluster, ClusterUpdate>;
  @doc("Update a Cluster")
  @extension("x-ms-long-running-operation", true)
  @extension(
    "x-ms-long-running-operation-options",
    {
      `final-state-via`: "location",
    }
  )
  @armResourceUpdate(Cluster)
  @patch
  update(
    ...ResourceInstanceParameters<Cluster>,

    @body
    @doc("The cluster properties to be updated.")
    clusterUpdate: ClusterUpdate,
  ): ArmResponse<Cluster> | {
    // @doc("Resource update request created.")
    ...CreatedResponse;

    ...Azure.Core.Foundations.RetryAfterHeader;
    ...LocationHeader;

    @body
    @doc("The updated cluster.")
    cluster: Cluster;
  } | ErrorResponse;

  #suppress "deprecated"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes"
  delete is ArmResourceDeleteAsync<Cluster>;

  @doc("List hosts by zone in a cluster")
  listZones is ArmResourceActionSyncNoRequestBody<Cluster, ClusterZoneList>;
}

@@projectedName(Clusters.createOrUpdate::parameters.resource,
  "json",
  "cluster"
);
@@OpenAPI.extension(Clusters.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "cluster"
);

@armResourceOperations
interface Datastores {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("Datastores_List")
  list is ArmResourceListByParent<Datastore>;

  get is ArmResourceRead<Datastore>;

  createOrUpdate is ArmResourceCreateOrUpdateAsync<Datastore>;

  #suppress "deprecated"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes"
  delete is ArmResourceDeleteAsync<Datastore>;
}

@@projectedName(Datastores.createOrUpdate::parameters.resource,
  "json",
  "datastore"
);
@@OpenAPI.extension(Datastores.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "datastore"
);

@armResourceOperations
interface HcxEnterpriseSites {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("HcxEnterpriseSites_List")
  list is ArmResourceListByParent<HcxEnterpriseSite>;

  get is ArmResourceRead<HcxEnterpriseSite>;

  createOrUpdate is ArmResourceCreateOrReplaceSync<HcxEnterpriseSite>;

  delete is ArmResourceDeleteSync<HcxEnterpriseSite>;
}

@@projectedName(HcxEnterpriseSites.createOrUpdate::parameters.resource,
  "json",
  "hcxEnterpriseSite"
);
@@OpenAPI.extension(HcxEnterpriseSites.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "hcxEnterpriseSite"
);

@armResourceOperations
interface Authorizations {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("Authorizations_List")
  list is ArmResourceListByParent<ExpressRouteAuthorization>;

  get is ArmResourceRead<ExpressRouteAuthorization>;

  createOrUpdate is ArmResourceCreateOrUpdateAsync<
    ExpressRouteAuthorization,
    BaseParameters<PrivateCloud>
  >;

  #suppress "deprecated"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes"
  delete is ArmResourceDeleteAsync<ExpressRouteAuthorization>;
}

@@projectedName(Authorizations.createOrUpdate::parameters.resource,
  "json",
  "authorization"
);
@@OpenAPI.extension(Authorizations.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "authorization"
);

@armResourceOperations
interface GlobalReachConnections {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("GlobalReachConnections_List")
  list is ArmResourceListByParent<GlobalReachConnection>;

  get is ArmResourceRead<GlobalReachConnection>;

  createOrUpdate is ArmResourceCreateOrUpdateAsync<GlobalReachConnection>;

  #suppress "deprecated"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes"
  delete is ArmResourceDeleteAsync<GlobalReachConnection>;
}

@@projectedName(GlobalReachConnections.createOrUpdate::parameters.resource,
  "json",
  "globalReachConnection"
);
@@OpenAPI.extension(GlobalReachConnections.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "globalReachConnection"
);

@armResourceOperations
interface WorkloadNetworks {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_Get")
  get is ArmResourceRead<WorkloadNetwork>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_List")
  list is ArmResourceListByParent<WorkloadNetwork>;
}

@armResourceOperations
interface WorkloadNetworkSegments {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_ListSegments")
  list is ArmResourceListByParent<WorkloadNetworkSegment>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_GetSegment")
  get is ArmResourceRead<WorkloadNetworkSegment>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_CreateSegments")
  create is ArmResourceCreateOrUpdateAsync<WorkloadNetworkSegment>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_UpdateSegments")
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<
    WorkloadNetworkSegment,
    WorkloadNetworkSegmentUpdate
  >;

  #suppress "deprecated"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes"
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_DeleteSegment")
  deleteSegment is ArmResourceDeleteAsync<WorkloadNetworkSegment>;
}

@@projectedName(WorkloadNetworkSegments.create::parameters.resource,
  "json",
  "workloadNetworkSegment"
);
@@OpenAPI.extension(WorkloadNetworkSegments.create::parameters.resource,
  "x-ms-client-name",
  "workloadNetworkSegment"
);

@@projectedName(WorkloadNetworkSegments.update::parameters.properties,
  "json",
  "workloadNetworkSegment"
);
@@OpenAPI.extension(WorkloadNetworkSegments.update::parameters.properties,
  "x-ms-client-name",
  "workloadNetworkSegment"
);

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator"
// @armResourceOperations
interface WorkloadNetworkDhcpConfigurations {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_ListDhcp")
  list is ArmResourceListByParent<WorkloadNetworkDhcp>;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "DhcpIdParameter should be last, but it is breaking to correct it."
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_GetDhcp")
  // get is ArmResourceRead<WorkloadNetworkDhcp>;
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AVS/privateClouds/{privateCloudName}/workloadNetworks/default/dhcpConfigurations/{dhcpId}")
  @doc("Get a {name}", WorkloadNetworkDhcp)
  @get
  get(
    ...BaseParameters<WorkloadNetworkDhcp>,
    ...DhcpIdParameter,
    ...PrivateCloudNameParameter,
  ): ArmResponse<WorkloadNetworkDhcp> | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_CreateDhcp")
  create is ArmResourceCreateOrUpdateAsync<WorkloadNetworkDhcp>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_UpdateDhcp")
  update is ArmCustomPatchAsync<WorkloadNetworkDhcp, WorkloadNetworkDhcpUpdate>;

  #suppress "deprecated"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes"
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_DeleteDhcp")
  delete is ArmResourceDeleteAsync<WorkloadNetworkDhcp>;
}

@@projectedName(WorkloadNetworkDhcpConfigurations.create::parameters.resource,
  "json",
  "workloadNetworkDhcp"
);
@@OpenAPI.extension(WorkloadNetworkDhcpConfigurations.create::parameters.resource,
  "x-ms-client-name",
  "workloadNetworkDhcp"
);

@@projectedName(WorkloadNetworkDhcpConfigurations.update::parameters.properties,
  "json",
  "workloadNetworkDhcp"
);
@@OpenAPI.extension(WorkloadNetworkDhcpConfigurations.update::parameters.properties,
  "x-ms-client-name",
  "workloadNetworkDhcp"
);

@@projectedName(WorkloadNetworkDhcpConfigurations.update::parameters.properties,
  "json",
  "workloadNetworkDhcp"
);
@@OpenAPI.extension(WorkloadNetworkDhcpConfigurations.update::parameters.properties,
  "x-ms-client-name",
  "workloadNetworkDhcp"
);

@armResourceOperations
interface WorkloadNetworkGateways {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_ListGateways")
  list is ArmResourceListByParent<WorkloadNetworkGateway>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_GetGateway")
  get is ArmResourceRead<WorkloadNetworkGateway>;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator"
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation"
// @armResourceOperations
@doc("Workload Network Port Mirroring Profiles")
interface WorkloadNetworkPortMirroringProfiles {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_ListPortMirroring")
  list is ArmResourceListByParent<WorkloadNetworkPortMirroring>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_GetPortMirroring")
  get is ArmResourceRead<WorkloadNetworkPortMirroring>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_CreatePortMirroring")
  create is ArmResourceCreateOrUpdateAsync<WorkloadNetworkPortMirroring>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_UpdatePortMirroring")
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<
    WorkloadNetworkPortMirroring,
    WorkloadNetworkPortMirroringUpdate
  >;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "PortMirroringProfileParameter should be last, but it is breaking to correct it."
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_DeletePortMirroring")
  // delete is ArmResourceDeleteAsync<WorkloadNetworkPortMirroring>;
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AVS/privateClouds/{privateCloudName}/workloadNetworks/default/portMirroringProfiles/{portMirroringId}")
  @doc("Delete a {name}", WorkloadNetworkPortMirroring)
  @delete
  @extension("x-ms-long-running-operation", true)
  @extension(
    "x-ms-long-running-operation-options",
    {
      `final-state-via`: "location",
    }
  )
  delete(
    ...BaseParameters<WorkloadNetworkPortMirroring>,
    ...PortMirroringProfileParameter,
    ...PrivateCloudNameParameter,
  ):
    | ArmDeletedResponse
    | ArmDeleteAcceptedLroResponse
    | ArmDeletedNoContentResponse
    | ErrorResponse;
}

@@projectedName(WorkloadNetworkPortMirroringProfiles.create::parameters.resource,
  "json",
  "workloadNetworkPortMirroring"
);
@@OpenAPI.extension(WorkloadNetworkPortMirroringProfiles.create::parameters.resource,
  "x-ms-client-name",
  "workloadNetworkPortMirroring"
);

@@projectedName(WorkloadNetworkPortMirroringProfiles.update::parameters.properties,
  "json",
  "workloadNetworkPortMirroring"
);
@@OpenAPI.extension(WorkloadNetworkPortMirroringProfiles.update::parameters.properties,
  "x-ms-client-name",
  "workloadNetworkPortMirroring"
);

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator"
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation"
// @armResourceOperations
@doc("Workload Network VM Groups")
interface WorkloadNetworkVmGroups {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_ListVMGroups")
  list is ArmResourceListByParent<WorkloadNetworkVMGroup>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_GetVMGroup")
  get is ArmResourceRead<WorkloadNetworkVMGroup>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_CreateVMGroup")
  create is ArmResourceCreateOrUpdateAsync<WorkloadNetworkVMGroup>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_UpdateVMGroup")
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<
    WorkloadNetworkVMGroup,
    WorkloadNetworkVMGroupUpdate
  >;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "VmGroupIdParameter should be last, but it is breaking to correct it."
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_DeleteVMGroup")
  // delete is ArmResourceDeleteAsync<WorkloadNetworkVMGroup>;
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AVS/privateClouds/{privateCloudName}/workloadNetworks/default/vmGroups/{vmGroupId}")
  @doc("Delete a {name}", WorkloadNetworkVMGroup)
  @delete
  @extension("x-ms-long-running-operation", true)
  @extension(
    "x-ms-long-running-operation-options",
    {
      `final-state-via`: "location",
    }
  )
  delete(
    ...BaseParameters<WorkloadNetworkVMGroup>,
    ...VmGroupIdParameter,
    ...PrivateCloudNameParameter,
  ):
    | ArmDeletedResponse
    | ArmDeleteAcceptedLroResponse
    | ArmDeletedNoContentResponse
    | ErrorResponse;
}

@@projectedName(WorkloadNetworkVmGroups.create::parameters.resource,
  "json",
  "workloadNetworkVMGroup"
);
@@OpenAPI.extension(WorkloadNetworkVmGroups.create::parameters.resource,
  "x-ms-client-name",
  "workloadNetworkVMGroup"
);

@@projectedName(WorkloadNetworkVmGroups.update::parameters.properties,
  "json",
  "workloadNetworkVMGroup"
);
@@OpenAPI.extension(WorkloadNetworkVmGroups.update::parameters.properties,
  "x-ms-client-name",
  "workloadNetworkVMGroup"
);

@armResourceOperations
interface WorkloadNetworkVirtualMachines {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_ListVirtualMachines")
  list is ArmResourceListByParent<WorkloadNetworkVirtualMachine>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_GetVirtualMachine")
  get is ArmResourceRead<WorkloadNetworkVirtualMachine>;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator"
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation"
// @armResourceOperations
@doc("Workload Network Dns Services")
interface WorkloadNetworkDnsServices {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_ListDnsServices")
  list is ArmResourceListByParent<WorkloadNetworkDnsService>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_GetDnsService")
  get is ArmResourceRead<WorkloadNetworkDnsService>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_CreateDnsService")
  create is ArmResourceCreateOrUpdateAsync<WorkloadNetworkDnsService>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_UpdateDnsService")
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<
    WorkloadNetworkDnsService,
    WorkloadNetworkDnsServiceUpdate
  >;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "DnsServiceIdParameter should be last, but it is breaking to correct it."
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_DeleteDnsService")
  // delete is ArmResourceDeleteAsync<WorkloadNetworkDnsService>;
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AVS/privateClouds/{privateCloudName}/workloadNetworks/default/dnsServices/{dnsServiceId}")
  @doc("Delete a {name}", WorkloadNetworkDnsService)
  @delete
  @extension("x-ms-long-running-operation", true)
  @extension(
    "x-ms-long-running-operation-options",
    {
      `final-state-via`: "location",
    }
  )
  delete(
    ...BaseParameters<WorkloadNetworkDnsService>,
    ...DnsServiceIdParameter,
    ...PrivateCloudNameParameter,
  ):
    | ArmDeletedResponse
    | ArmDeleteAcceptedLroResponse
    | ArmDeletedNoContentResponse
    | ErrorResponse;
}

@@projectedName(WorkloadNetworkDnsServices.create::parameters.resource,
  "json",
  "workloadNetworkDnsService"
);
@@OpenAPI.extension(WorkloadNetworkDnsServices.create::parameters.resource,
  "x-ms-client-name",
  "workloadNetworkDnsService"
);

@@projectedName(WorkloadNetworkDnsServices.update::parameters.properties,
  "json",
  "workloadNetworkDnsService"
);
@@OpenAPI.extension(WorkloadNetworkDnsServices.update::parameters.properties,
  "x-ms-client-name",
  "workloadNetworkDnsService"
);

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator"
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation"
// @armResourceOperations
@doc("Workload Network DNS Zones")
interface WorkloadNetworkDnsZones {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_ListDnsZones")
  list is ArmResourceListByParent<WorkloadNetworkDnsZone>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_GetDnsZone")
  get is ArmResourceRead<WorkloadNetworkDnsZone>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_CreateDnsZone")
  create is ArmResourceCreateOrUpdateAsync<WorkloadNetworkDnsZone>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_UpdateDnsZone")
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<
    WorkloadNetworkDnsZone,
    WorkloadNetworkDnsZoneUpdate
  >;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "DnsZoneIdParameter should be last, but it is breaking to correct it."
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_DeleteDnsZone")
  // delete is ArmResourceDeleteAsync<WorkloadNetworkDnsZone>;
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AVS/privateClouds/{privateCloudName}/workloadNetworks/default/dnsZones/{dnsZoneId}")
  @doc("Delete a {name}", WorkloadNetworkDnsZone)
  @delete
  @extension("x-ms-long-running-operation", true)
  @extension(
    "x-ms-long-running-operation-options",
    {
      `final-state-via`: "location",
    }
  )
  delete(
    ...BaseParameters<WorkloadNetworkDnsZone>,
    ...DnsZoneIdParameter,
    ...PrivateCloudNameParameter,
  ):
    | ArmDeletedResponse
    | ArmDeleteAcceptedLroResponse
    | ArmDeletedNoContentResponse
    | ErrorResponse;
}

@@projectedName(WorkloadNetworkDnsZones.create::parameters.resource,
  "json",
  "workloadNetworkDnsZone"
);
@@OpenAPI.extension(WorkloadNetworkDnsZones.create::parameters.resource,
  "x-ms-client-name",
  "workloadNetworkDnsZone"
);

@@projectedName(WorkloadNetworkDnsZones.update::parameters.properties,
  "json",
  "workloadNetworkDnsZone"
);
@@OpenAPI.extension(WorkloadNetworkDnsZones.update::parameters.properties,
  "x-ms-client-name",
  "workloadNetworkDnsZone"
);

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator"
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation"
// @armResourceOperations
interface WorkloadNetworkPublicIps {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_ListPublicIPs")
  list is ArmResourceListByParent<WorkloadNetworkPublicIP>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_GetPublicIP")
  get is ArmResourceRead<WorkloadNetworkPublicIP>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_CreatePublicIP")
  create is ArmResourceCreateOrUpdateAsync<WorkloadNetworkPublicIP>;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "PublicIPIdParameter should be last, but it is breaking to correct it."
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("WorkloadNetworks_DeletePublicIP")
  // delete is ArmResourceDeleteAsync<WorkloadNetworkPublicIP>;
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AVS/privateClouds/{privateCloudName}/workloadNetworks/default/publicIPs/{publicIPId}")
  @doc("Delete a {name}", WorkloadNetworkPublicIP)
  @delete
  @extension("x-ms-long-running-operation", true)
  @extension(
    "x-ms-long-running-operation-options",
    {
      `final-state-via`: "location",
    }
  )
  delete(
    ...BaseParameters<WorkloadNetworkPublicIP>,
    ...PublicIPIdParameter,
    ...PrivateCloudNameParameter,
  ):
    | ArmDeletedResponse
    | ArmDeleteAcceptedLroResponse
    | ArmDeletedNoContentResponse
    | ErrorResponse;
}

@@projectedName(WorkloadNetworkPublicIps.create::parameters.resource,
  "json",
  "workloadNetworkPublicIP"
);
@@OpenAPI.extension(WorkloadNetworkPublicIps.create::parameters.resource,
  "x-ms-client-name",
  "workloadNetworkPublicIP"
);

@armResourceOperations
interface CloudLinks {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("CloudLinks_List")
  list is ArmResourceListByParent<CloudLink>;

  get is ArmResourceRead<CloudLink>;

  createOrUpdate is ArmResourceCreateOrUpdateAsync<CloudLink>;

  #suppress "deprecated"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes"
  delete is ArmResourceDeleteAsync<CloudLink>;
}

@@projectedName(CloudLinks.createOrUpdate::parameters.resource,
  "json",
  "cloudLink"
);
@@OpenAPI.extension(CloudLinks.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "cloudLink"
);

@armResourceOperations
interface Addons {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("Addons_List")
  list is ArmResourceListByParent<Addon>;

  get is ArmResourceRead<Addon>;

  createOrUpdate is ArmResourceCreateOrUpdateAsync<Addon>;

  #suppress "deprecated"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes"
  delete is ArmResourceDeleteAsync<Addon>;
}

@@projectedName(Addons.createOrUpdate::parameters.resource, "json", "addon");
@@OpenAPI.extension(Addons.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "addon"
);

@armResourceOperations
interface VirtualMachines {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("VirtualMachines_List")
  list is ArmResourceListByParent<VirtualMachine>;

  get is ArmResourceRead<VirtualMachine>;

  // restrictMovement should be a ArmResourceActionNoContentAsync, but does not respond with a 204.
  @doc("Enable or disable DRS-driven VM movement restriction")
  @armResourceAction(Location)
  @post
  @extension("x-ms-long-running-operation", true)
  restrictMovement(
    ...ResourceInstanceParameters<VirtualMachine>,

    @body
    @doc("The body type of the operation request.")
    restrictMovement: VirtualMachineRestrictMovement,
  ): ArmAcceptedLroResponse | ErrorResponse;
}

@armResourceOperations
interface PlacementPolicies {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("PlacementPolicies_List")
  list is ArmResourceListByParent<PlacementPolicy>;

  get is ArmResourceRead<PlacementPolicy>;

  createOrUpdate is ArmResourceCreateOrUpdateAsync<PlacementPolicy>;

  // 202 response has a body, but it should not to match ArmCustomPatchAsync.
  // update is ArmCustomPatchAsync<PlacementPolicy, PlacementPolicyUpdate>;
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body"
  @doc("Update a PlacementPolicy")
  @extension("x-ms-long-running-operation", true)
  @extension(
    "x-ms-long-running-operation-options",
    {
      `final-state-via`: "location",
    }
  )
  @armResourceUpdate(PlacementPolicy)
  @patch
  update(
    ...ResourceInstanceParameters<PlacementPolicy>,

    @body
    @doc("The placement policy properties to be updated.")
    placementPolicyUpdate: PlacementPolicyUpdate,
  ): ArmResponse<PlacementPolicy> | {
    ...AcceptedResponse;
    ...Azure.Core.Foundations.RetryAfterHeader;
    ...LocationHeader;

    @body
    @doc("The updatd placement policy.")
    placementPolicy: PlacementPolicy;
  } | ErrorResponse;

  #suppress "deprecated"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes"
  delete is ArmResourceDeleteAsync<PlacementPolicy>;
}

@@projectedName(PlacementPolicies.createOrUpdate::parameters.resource,
  "json",
  "placementPolicy"
);
@@OpenAPI.extension(PlacementPolicies.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "placementPolicy"
);

@armResourceOperations
interface ScriptPackages {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("ScriptPackages_List")
  list is ArmResourceListByParent<ScriptPackage>;

  get is ArmResourceRead<ScriptPackage>;
}

@armResourceOperations
interface ScriptCmdlets {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("ScriptCmdlets_List")
  list is ArmResourceListByParent<ScriptCmdlet>;

  get is ArmResourceRead<ScriptCmdlet>;
}

@armResourceOperations
interface ScriptExecutions {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "Can not change existing operationId."
  @operationId("ScriptExecutions_List")
  list is ArmResourceListByParent<ScriptExecution>;

  get is ArmResourceRead<ScriptExecution>;

  createOrUpdate is ArmResourceCreateOrUpdateAsync<ScriptExecution>;

  #suppress "deprecated"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes"
  delete is ArmResourceDeleteAsync<ScriptExecution>;

  @doc("Return the logs for a script execution resource")
  @autoRoute
  @armResourceAction(ScriptExecution)
  @post
  getExecutionLogs(
    ...ResourceInstanceParameters<ScriptExecution>,

    #suppress "@azure-tools/typespec-azure-core/request-body-problem"
    @body
    @doc("Name of the desired output stream to return. If not provided, will return all. An empty array will return nothing.")
    scriptOutputStreamType?: ScriptOutputStreamType[],
  ): ArmResponse<ScriptExecution> | ErrorResponse;
}

@@projectedName(ScriptExecutions.createOrUpdate::parameters.resource,
  "json",
  "scriptExecution"
);
@@OpenAPI.extension(ScriptExecutions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "scriptExecution"
);

@doc("The location envelope.")
model LocationHeader {
  @doc("The Location header contains the URL where the status of the long running operation can be checked.")
  @header("Location")
  location?: string;
}

@armResourceOperations
interface IscsiPaths {
  list is ArmResourceListByParent<IscsiPath>;

  get is ArmResourceRead<IscsiPath>;

  createOrUpdate is ArmResourceCreateOrUpdateAsync<IscsiPath>;

  #suppress "deprecated"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes"
  delete is ArmResourceDeleteAsync<IscsiPath>;
}

// use { @body _: void } with the next version of typespec-azure
// https://github.com/Azure/typespec-azure/issues/3759

// Just like ArmResourceActionSync, but with no request body.
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation"
#suppress "@azure-tools/typespec-azure-core/documentation-required"
@autoRoute
@armResourceAction(TResource)
@post
op ArmResourceActionSyncNoRequestBody<
  TResource extends ArmResource,
  TResponse extends TypeSpec.Reflection.Model,
  TBaseParameters = BaseParameters<TResource>
>(
  ...ResourceInstanceParameters<TResource, TBaseParameters>,
): ArmResponse<TResponse> | ErrorResponse;

// Just like ArmResourceActionAsync, but with no request body.
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation"
#suppress "@azure-tools/typespec-azure-core/documentation-required"
op ArmResourceActionNoContentAsyncNoRequestBody<
  TResource extends ArmResource,
  TBaseParameters extends TypeSpec.Reflection.Model = BaseParameters<TResource>
> is ArmResourceActionAsyncBaseNoRequestBody<
  TResource,
  ArmAcceptedLroResponse | ArmNoContentResponse<"Action completed successfully.">,
  TBaseParameters
>;

// Just like ArmResourceActionAsyncBase, but with no request body.
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation"
#suppress "@azure-tools/typespec-azure-core/documentation-required"
@autoRoute
@extension("x-ms-long-running-operation", true)
@extension(
  "x-ms-long-running-operation-options",
  {
    `final-state-via`: "location",
  }
)
@armResourceAction(TResource)
@post
op ArmResourceActionAsyncBaseNoRequestBody<
  TResource extends ArmResource,
  TResponse,
  TBaseParameters extends TypeSpec.Reflection.Model
>(
  ...ResourceInstanceParameters<TResource, TBaseParameters>,
): TResponse | ErrorResponse;
