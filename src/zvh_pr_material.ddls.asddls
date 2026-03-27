@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH for Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  serviceQuality: #B,
  sizeCategory:   #M,
  dataClass:      #MASTER
}
@Search.searchable: true
@VDM.viewType: #COMPOSITE
define view entity ZVH_PR_MATERIAL
  as select from ZR_PR_MATERIAL
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold:   0.7
  key MaterialNumber,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold:   0.8
      ShortText,
      @Search.defaultSearchElement: true
      MaterialType,
      BaseUnit,
      @Search.defaultSearchElement: true
      MatGroup,
      Active
}
