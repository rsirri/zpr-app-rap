@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH for Plant'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  serviceQuality: #B,
  sizeCategory:   #S,
  dataClass:      #MASTER
}
@Search.searchable: true
@VDM.viewType: #COMPOSITE
define view entity ZVH_PR_PLANT
  as select from ZR_PR_PLANT
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold:   0.7
  key Plant,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold:   0.8
      PlantName,
      @Search.defaultSearchElement: true
      Country,
      City,
      @Search.defaultSearchElement: true
      CompanyCode,
      Active
}
