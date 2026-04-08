@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CV for PR Item'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType: {
  serviceQuality: #C,
  sizeCategory:   #L,
  dataClass:      #TRANSACTIONAL
}
@VDM.viewType: #CONSUMPTION
@Search.searchable: true
define view entity ZC_PR_ITEM
  as projection on ZI_PR_ITEM
{
      @Search.defaultSearchElement: true
  key PrNumber,
  key ItemNumber,
      
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'ZVH_PR_MATERIAL', element: 'MaterialNumber' }
      }]
      @Consumption.semanticObject: 'ZPRMaterial'
      @ObjectModel.text.element: [ 'ShortText' ]
      MaterialNumber,

      @Search.defaultSearchElement: true
      ShortText,

      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'ZVH_PR_VENDOR', element: 'VendorNum' }
      }]
      Vendor,

      @Semantics.quantity.unitOfMeasure: 'Unit'
      Quantity,

      @Consumption.valueHelpDefinition: [{
        entity: { name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure' }
      }]
      Unit,
      @Semantics.amount.currencyCode: 'Currency'
      Price,

      @Consumption.valueHelpDefinition: [{
        entity: { name: 'I_CurrencyStdVH', element: 'Currency' }
      }]
      Currency,
      DeliveryDate,

      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'ZVH_PR_PLANT', element: 'Plant' }
      }]
      Plant,


      PhoneNumber,
      EMailAddress,
      WebAddress,


      ChangedAt,

      /* Associations */
      _Currency,
      _Header : redirected to parent ZC_PR_HEADER,
      _MaterialQV,
      _Material,
      _Plant,
      _Vendor
}
