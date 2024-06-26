import "@typespec/rest";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@azure-tools/typespec-providerhub";

namespace Microsoft.DatabaseWatcher;

using Azure.ResourceManager;
using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

@armResourceOperations
interface SharedPrivateLinkResources {
  get is ArmResourceRead<SharedPrivateLinkResource>;
  create is ArmResourceCreateOrUpdateAsync<SharedPrivateLinkResource>;
  delete is ArmResourceDeleteWithoutOkAsync<SharedPrivateLinkResource>;
  listByParent is ArmResourceListByParent<SharedPrivateLinkResource>;
}

@parentResource(Watcher)
model SharedPrivateLinkResource
  is ProxyResource<SharedPrivateLinkResourceProperties> {
  @doc("The Shared Private Link resource name.")
  @key("sharedPrivateLinkResourceName")
  @pattern("^[a-zA-Z0-9]{1}[a-zA-Z0-9-_.]{0,62}[a-zA-Z0-9_]{1}$")
  @segment("sharedPrivateLinkResources")
  @path
  name: string;
}

@doc("The generic properties of a Shared Private Link resource.")
model SharedPrivateLinkResourceProperties {
  @doc("The resource id of the resource the shared private link resource is for.")
  privateLinkResourceId: ResourceIdentifier;

  @doc("The group id from the provider of resource the shared private link resource is for.")
  groupId: string;

  @doc("The request message for requesting approval of the shared private link resource.")
  requestMessage: string;

  @doc("The DNS zone to be included in the DNS name of the shared private link. Value is service-specific.")
  dnsZone?: string;

  @visibility("read")
  @doc("Status of the shared private link resource. Can be Pending, Approved, Rejected or Disconnected.")
  status?: SharedPrivateLinkResourceStatus;

  @visibility("read")
  @doc("The provisioning state of the resource.")
  provisioningState?: ResourceProvisioningState;
}

@doc("Status of the shared private link resource. Can be Pending, Approved, Rejected or Disconnected.")
enum SharedPrivateLinkResourceStatus {
  @doc("The shared private link connection request was not yet authorized by the resource owner.")
  Pending,

  @doc("The shared private link connection request was approved by the resource owner.")
  Approved,

  @doc("The shared private link connection request was rejected by the resource owner.")
  Rejected,

  @doc("The shared private link connection request was disconnected by the resource owner.")
  Disconnected,
}
