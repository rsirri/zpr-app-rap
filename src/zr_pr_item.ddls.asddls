@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic view for PR Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #TRANSACTIONAL
}
@VDM.viewType: #BASIC
define view entity ZR_PR_ITEM
  as select from ztpr_item
{
  key pr_number       as PrNumber,
  key item_number     as ItemNumber,
      material_number as MaterialNumber,
      short_text      as ShortText,
      vendor          as Vendor,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      quantity        as Quantity,
      unit            as Unit,
      @Semantics.amount.currencyCode: 'Currency'
      price           as Price,
      currency        as Currency,
      delivery_date   as DeliveryDate,
      plant           as Plant,
      phone_number    as PhoneNumber,
      email_address   as EMailAddress,
      web_address     as WebAddress,
      changed_at      as ChangedAt
}
