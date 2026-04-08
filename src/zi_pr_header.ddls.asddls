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
      Bsart                     as DocType,
      PrDate,
      RequestedBy,
      Department,

      Status,
      @UI.hidden: true
      case Status
        when 'D' then 5
        when 'S' then 2
        when 'A' then 3
        when 'R' then 1
        else 0
      end                       as StatusCriticality,

      case Status
        when 'D' then 0
        when 'S' then 50
        when 'A' then 100
        else 0
      end                       as ApprovalProgress,

      @Semantics.amount.currencyCode: 'Currency'
      TotalValue,
      //      @Semantics.amount.currencyCode: 'Currency'
      //      TotalValue                                                                  as TotalValueChart,
      cast(
      case
      when BudgetTarget = 0 then 0
      else ( cast( TotalValue as abap.dec(15,2) ) * 100 ) / cast( BudgetTarget as abap.dec(15,2) )
      end
      as abap.int2
      )                         as TotalValueChart,

      @Semantics.amount.currencyCode: 'Currency'
      BudgetTarget,

      cast(
      case
      when BudgetTarget = 0 then 0
      when ( ( cast( TotalValue as abap.dec(15,2) ) * 100 ) / cast( BudgetTarget as abap.dec(15,2) ) ) <= 50 then 3
      when ( ( cast( TotalValue as abap.dec(15,2) ) * 100 ) / cast( BudgetTarget as abap.dec(15,2) ) ) <= 80 then 2
      else 1 end as abap.int1 ) as BudgetCriticality,

      Currency,

      Priority,

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
