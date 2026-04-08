@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'IV - PR Items'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  serviceQuality: #B,
  sizeCategory:   #L,
  dataClass:      #TRANSACTIONAL
}
@VDM.viewType: #COMPOSITE
define view entity ZI_PR_ITEM
  as select from ZR_PR_ITEM
  association        to parent ZI_PR_HEADER as _Header     on $projection.PrNumber = _Header.PrNumber
  association [1]    to ZI_QV_MATERIAL      as _MaterialQV on $projection.MaterialNumber = _MaterialQV.MaterialNumber
  association [0..1] to ZR_PR_MATERIAL      as _Material   on $projection.MaterialNumber = _Material.MaterialNumber
  association [0..1] to ZR_PR_PLANT         as _Plant      on $projection.Plant = _Plant.Plant
  association [0..1] to I_Currency          as _Currency   on $projection.Currency = _Currency.Currency
  association [0..1] to ZR_PR_VENDOR        as _Vendor     on $projection.Vendor = _Vendor.VendorNum
{
  key PrNumber,
  key ItemNumber,
  
      @ObjectModel.foreignKey.association: '_MaterialQV'
      MaterialNumber,
      ShortText,
      Vendor,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      Quantity,
      Unit,
      @Semantics.amount.currencyCode: 'Currency'
      Price,
      Currency,
      DeliveryDate,
      Plant,

      @Semantics.telephone.type: [ #WORK ]
      PhoneNumber,
      @Semantics.eMail.address: true
      EMailAddress,
      WebAddress,

      @Semantics.systemDateTime.lastChangedAt: true
      ChangedAt,

      _Header,
      _MaterialQV,
      _Material,
      _Plant,
      _Currency,
      _Vendor
}
