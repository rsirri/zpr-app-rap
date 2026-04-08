@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CV : Material'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #MASTER
}
@VDM.viewType: #CONSUMPTION
@ObjectModel.semanticKey: [ 'MaterialNumber' ]
define root view entity ZC_PR_MATERIAL
  as projection on ZI_PR_MATERIAL
{
  key MaterialNumber,
      ShortText,

      @ObjectModel.text.element: [ 'MatTypeName' ]
      MaterialType,
      _MaterialTypeT.MatTypeName,

      @Semantics.baseUnitOfMeasure: true
      BaseUnit,
      MatGroup,
      Active,
      @UI.hidden: true
      ActiveCriticality,
      CreatedBy,
      CreatedAt,
      ChangedBy,
      ChangedAt,

      _MaterialTypeT

}
