CLASS zcl_pr_nr_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES : if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_pr_nr_check IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA lv_object TYPE cl_numberrange_intervals=>nr_object.

    lv_object = 'ZPR_NUM'.
    TRY.
        cl_numberrange_intervals=>read(
          EXPORTING
            object       = lv_object
          IMPORTING
            interval     = DATA(lt_interval)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_nr_subobject.
      CATCH cx_number_ranges.
    ENDTRY.

    out->write(
      EXPORTING
        data   = lt_interval
        name   = 'Number Range intervals for ZPR_NUM'
*      RECEIVING
*        output =
    ).
    cl_numberrange_runtime=>number_status(
      EXPORTING
        nr_range_nr = '01'
        object      = lv_object
*    subobject   =
*    toyear      =
  IMPORTING
    number      = DATA(lv_number)
    ).
*CATCH cx_nr_object_not_found.
*CATCH cx_number_ranges.
    out->write( lv_number ).

  ENDMETHOD.

ENDCLASS.
