@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic view for PR Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #TRANSACTIONAL
}
@VDM.viewType: #BASIC
define view entity ZR_PR_HEADER
  as select from ztpr_header
{
  key pr_number             as PrNumber,
      bsart                 as Bsart,
      pr_date               as PrDate,
      requested_by          as RequestedBy,
      department            as Department,
      status                as Status,
      @Semantics.amount.currencyCode: 'Currency'
      total_value           as TotalValue,
      currency              as Currency,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      changed_by            as ChangedBy,
      changed_at            as ChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
