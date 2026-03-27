CLASS zcl_pr_nr_setup DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES : if_oo_adt_classrun.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_pr_nr_setup IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA : lt_intervals TYPE cl_numberrange_intervals=>nr_interval.

    lt_intervals = VALUE #( ( nrrangenr = '01' fromnumber = '' tonumber = '' externind = ' ' procind = 'I' )
                          ).
    out->write( |Create Intervals for Object: { 'ZPR_NUM' }| ).
    TRY.
        cl_numberrange_intervals=>create(
          EXPORTING
            interval  = lt_intervals
            object    = 'ZPR_NUM'
          IMPORTING
            error     = DATA(lv_error)
            error_inf = DATA(lv_error_inf)
            error_iv  = DATA(lv_error_iv)
            warning   = DATA(lv_error_warn)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges.
    ENDTRY.

    IF lv_error IS INITIAL.
      out->write( |Created Intervals for Object: { 'ZPR_NUM' }| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
