@EndUserText.label: 'PR Event Parameter'
define abstract entity ZPR_S_EVENT_PR
{
  pr_number    : zpr_number;
  requested_by : syuname;
  department   : zpr_dept;
  total_value  : abap.dec(13,2);
}
