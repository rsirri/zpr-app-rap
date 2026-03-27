@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH for Department'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  serviceQuality: #B,
  sizeCategory:   #S,
  dataClass:      #MASTER
}
@Search.searchable: true
@VDM.viewType: #COMPOSITE
define view entity ZVH_PR_DEPT
  as select from ZR_PR_DEPT
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold:   0.7
  key DeptCode,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold:   0.8
      DeptName,
      @Search.defaultSearchElement: true
      CostCenter,
      @Search.defaultSearchElement: true
      DeptHead,
      Active
}
