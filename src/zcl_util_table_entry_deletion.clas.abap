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

    SELECT FROM ztpr_header FIELDS * INTO TABLE @DATA(lt_head).
    SELECT FROM ztpr_item FIELDS * INTO TABLE @DATA(lt_item).

    DELETE ztpr_header FROM TABLE @lt_head.
    DELETE ztpr_item FROM TABLE @lt_item.

  ENDMETHOD.

ENDCLASS.
