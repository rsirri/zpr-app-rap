@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Quick View for Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #MASTER
}
@VDM.viewType: #COMPOSITE
@UI.headerInfo:{
                typeName: 'Material Details',
                title.value: 'ShortText',
                description.value: 'MaterialNumber',
                typeImageUrl: 'sap-icon://product'
               }
define view entity ZI_QV_MATERIAL
  as select from ZR_PR_MATERIAL
{

      @UI.facet: [
                    {
                        type: #FIELDGROUP_REFERENCE,
                        label: 'Material Information',
                        targetQualifier: 'MatQV',
                        purpose: #QUICK_VIEW
                    }
                 ]

      @UI: { fieldGroup: [{ qualifier: 'MatQV', position: 10 }] }
  key MaterialNumber,
      @UI: { fieldGroup: [{ qualifier: 'MatQV', position: 20 }] }
      ShortText,
      @UI: { fieldGroup: [{ qualifier: 'MatQV', position: 30 }] }
      MaterialType,
      @UI: { fieldGroup: [{ qualifier: 'MatQV', position: 40 }] }
      BaseUnit,
      @UI: { fieldGroup: [{ qualifier: 'MatQV', position: 50 }] }
      MatGroup
}
