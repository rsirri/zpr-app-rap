@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic View for Vendor'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #MASTER
}
@VDM.viewType: #BASIC
define view entity ZR_PR_VENDOR
  as select from ztpr_vendor
{
  key vendor_num    as VendorNum,
      vendor_name   as VendorName,
      country       as Country,
      city          as City,
      currency      as Currency,
      payment_terms as PaymentTerms,
      active        as Active
}
