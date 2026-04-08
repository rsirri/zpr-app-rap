@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Itnerface View for Material'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #MASTER
}
@VDM.viewType: #COMPOSITE
define root view entity ZI_PR_MATERIAL
  as select from ZR_PR_MATERIAL
  association [0..1] to ZR_MATTYPE as _MaterialTypeT on $projection.MaterialType = _MaterialTypeT.MaterialType

{
  key MaterialNumber,
      ShortText,

      @ObjectModel.text.association: '_MaterialTypeT'
      MaterialType,

      BaseUnit,
      MatGroup,
      Active,
      @UI.hidden: true
      case Active
      when 'X' then 3
      else 1
      end as ActiveCriticality,
      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.lastChangedBy: true
      ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      ChangedAt,

      _MaterialTypeT

}
