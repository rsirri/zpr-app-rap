CLASS zcl_util_table_entry_deletion DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES : if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_util_table_entry_deletion IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    SELECT FROM ztpr_header FIELDS * INTO TABLE @DATA(lt_head).
    SELECT FROM ztpr_item FIELDS * wHERE pr_number = '0000000000' INTO TABLE @DATA(lt_item).
*
*    DELETE ztpr_header FROM TABLE @lt_head.
    DELETE ztpr_item FROM TABLE @lt_item.

*    UPDATE ztpr_header SET budget_target = 200 WHERE pr_number = '4600000006'.
*    UPDATE ztpr_header SET budget_target = 6000 WHERE pr_number = '4600000005'.
*    UPDATE ztpr_header SET budget_target = 50  WHERE pr_number = '4600000001'.
*    UPDATE ztpr_header SET budget_target = 40 WHERE pr_number = '4600000003'.
*    UPDATE ztpr_header SET budget_target = 100 WHERE pr_number = '4600000004'.
*    COMMIT WORK.

  ENDMETHOD.

ENDCLASS.
