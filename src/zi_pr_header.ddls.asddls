@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'IV - PR Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  serviceQuality: #B,
  sizeCategory:   #L,
  dataClass:      #TRANSACTIONAL
}
@VDM.viewType: #COMPOSITE
define root view entity ZI_PR_HEADER
  as select from ZR_PR_HEADER as Header
  composition [0..*] of ZI_PR_ITEM as _Items
  association [0..1] to ZR_PR_DEPT as _Department on $projection.Department = _Department.DeptCode
  association [0..1] to I_Currency as _Currency   on $projection.Currency = _Currency.Currency
{
  key PrNumber,
      Bsart as DocType,
      PrDate,
      RequestedBy,
      Department,
      Status,
      @UI.hidden: true
      case Status
        when 'D' then 2
        when 'S' then 3
        when 'A' then 1
        when 'R' then 6
        else 0
      end as StatusCriticality,
      @Semantics.amount.currencyCode: 'Currency'
      TotalValue,
      Currency,

      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.lastChangedBy: true
      ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      ChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      _Items,
      _Department,
      _Currency
}
