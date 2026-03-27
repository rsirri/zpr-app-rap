@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH for Vendor'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  serviceQuality: #B,
  sizeCategory:   #M,
  dataClass:      #MASTER
}
@Search.searchable: true
@VDM.viewType: #COMPOSITE
define view entity ZVH_PR_VENDOR
  as select from ZR_PR_VENDOR
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold:   0.7
  key VendorNum,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold:   0.8
      VendorName,
      @Search.defaultSearchElement: true
      Country,
      City,
      @Search.defaultSearchElement: true
      Currency,
      PaymentTerms,
      Active
}
