@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic view for PR Department'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #S,
    dataClass: #MASTER
}
@VDM.viewType: #BASIC
define view entity ZR_PR_DEPT
  as select from ztpr_dept
{
  key dept_code   as DeptCode,
      dept_name   as DeptName,
      cost_center as CostCenter,
      dept_head   as DeptHead,
      active      as Active
}
