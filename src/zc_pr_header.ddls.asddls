@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CV for PR Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType: {
  serviceQuality: #C,
  sizeCategory:   #L,
  dataClass:      #TRANSACTIONAL
}
@VDM.viewType: #CONSUMPTION
@Search.searchable: true
define root view entity ZC_PR_HEADER
  as projection on ZI_PR_HEADER
{
      @Search.defaultSearchElement: true
  key PrNumber,
      DocType,
      PrDate,
      @Search.defaultSearchElement: true
      RequestedBy,

      @Consumption.valueHelpDefinition: [{
            entity: { name: 'ZVH_PR_DEPT', element: 'DeptCode' }
       }]
      Department,

      Status,
      @UI.hidden: true
      StatusCriticality,
      
      ApprovalProgress,

      @Semantics.amount.currencyCode: 'Currency'
      TotalValue,
//      @Semantics.amount.currencyCode: 'Currency'
      TotalValueChart,
      @Semantics.amount.currencyCode: 'Currency'
      BudgetTarget,
      @UI.hidden: true
      BudgetCriticality,
    
      @Consumption.valueHelpDefinition: [{
      entity: { name: 'I_CurrencyStdVH', element: 'Currency' }
      }]
      Currency,
      
      Priority,
      HeaderNote,
      
      CreatedBy,
      CreatedAt,
      ChangedBy,
      ChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _Currency,
      _Department,
      _Items : redirected to composition child ZC_PR_ITEM
}
