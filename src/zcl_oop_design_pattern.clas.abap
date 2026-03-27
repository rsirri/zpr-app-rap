CLASS zcl_oop_design_pattern DEFINITION PUBLIC  .

  PUBLIC SECTION.
    INTERFACES : if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_oop_design_pattern IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*  DATA lo_sgtn TYPE REF TO zcl_sgtn_db.
*
*  lo_sgtn = zcl_sgtn_db=>get_instance( ).

*  DATA(lo_docu_po) = lcl_factory_document=>create_docu( iv_type = 'PO' ).
*  lo_docu_po->display( ).
*  DATA(lo_docu_so) = lcl_factory_document=>create_docu( iv_type = 'SO' ).
*  lo_docu_so->display( ).
*  DATA(lo_docu_inv) = lcl_factory_document=>create_docu( iv_type = 'INV' ).
*  lo_docu_inv->display( ).
*
*  DATA : lo_pricing_contect  TYPE REF TO lcl_pricing_context,
*         lo_pricing_strategy TYPE REF TO if_pricing_strategy,
*         lv_final_price      TYPE netpr.
*
*
*  CREATE OBJECT lo_pricing_contect.
*
*  " Std Pricing
*  CREATE OBJECT lo_pricing_strategy TYPE lcl_std_pricing.
*  lo_pricing_contect->set_strategy( lo_pricing_strategy ).
*  lv_final_price = lo_pricing_contect->execute_strategy( iv_amount = 100 ).
*  WRITE : / 'Standard price:', lv_final_price.
*
*  " Discount Pricing
*  CREATE OBJECT lo_pricing_strategy TYPE lcl_discount_pricing.
*  lo_pricing_contect->set_strategy( lo_pricing_strategy ).
*  lv_final_price = lo_pricing_contect->execute_strategy( 100 ).
*  WRITE : / 'Discounted price:', lv_final_price.

*  DATA : lo_sales_order TYPE REF TO lcl_sales_order,
*         lo_finance     TYPE REF TO lcl_finance,
*         lo_warehouse   TYPE REF TO lcl_warehouse.
*
*  CREATE OBJECT : lo_sales_order,
*                  lo_finance,
*                  lo_warehouse.
*
*  lo_sales_order->register_observer( lo_finance  ).
*  lo_sales_order->register_observer( lo_warehouse  ).
*
*  lo_sales_order->notify_observers( ).

    DATA : lo_base_pricing     TYPE REF TO if_material_pricing,
           lo_tax_pricing      TYPE REF TO if_material_pricing,
           lo_discount_pricing TYPE REF TO if_material_pricing,
           lv_final_price      TYPE znetpr.

    CREATE OBJECT lo_base_pricing TYPE lcl_std_pricing
      EXPORTING
        i_base_price = 100.

    CREATE OBJECT lo_tax_pricing TYPE lcl_tax_decorator
      EXPORTING
        io_pricing     = lo_base_pricing
        iv_tax_percent = 10.

    CREATE OBJECT lo_discount_pricing TYPE lcl_discount_decorator
      EXPORTING
        io_pricing     = lo_tax_pricing
        iv_tax_percent = 5.

    lv_final_price = lo_discount_pricing->get_price( ).
    out->write( lv_final_price ).

  ENDMETHOD.

ENDCLASS.
