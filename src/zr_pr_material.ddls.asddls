@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic View for Material'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #MASTER
}
@VDM.viewType: #BASIC
define view entity ZR_PR_MATERIAL
  as select from ztpr_material
{

  key material_number as MaterialNumber,
      short_text      as ShortText,
      material_type   as MaterialType,
      base_unit       as BaseUnit,
      mat_group       as MatGroup,
      active          as Active,
      created_by      as CreatedBy,
      created_at      as CreatedAt,
      changed_by      as ChangedBy,
      changed_at      as ChangedAt
      
}
