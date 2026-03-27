@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic view for Plant'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #MASTER
}
@VDM.viewType: #BASIC
define view entity ZR_PR_PLANT
  as select from ztpr_plant
{
  key plant        as Plant,
      plant_name   as PlantName,
      country      as Country,
      city         as City,
      company_code as CompanyCode,
      active       as Active
}
