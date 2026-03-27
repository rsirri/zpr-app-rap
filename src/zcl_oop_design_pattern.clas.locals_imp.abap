*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

*CLASS lcl_document DEFINITION ABSTRACT.
*
*  PUBLIC SECTION.
*    METHODS display ABSTRACT.
*
*ENDCLASS.
*
*CLASS lcl_so DEFINITION INHERITING FROM lcl_document.
*
*  PUBLIC SECTION.
*    METHODS display REDEFINITION.
*
*ENDCLASS.
*
*CLASS lcl_so IMPLEMENTATION.
*
*  METHOD display.
*    cl_demo_output=>write( 'Sales Order Created or Initiated' ).
*    cl_demo_output=>display( ).
*  ENDMETHOD.
*
*ENDCLASS.
*
*CLASS lcl_po DEFINITION INHERITING FROM lcl_document.
*
*  PUBLIC SECTION.
*    METHODS display REDEFINITION.
*
*ENDCLASS.
*
*CLASS lcl_po IMPLEMENTATION.
*
*  METHOD display.
*    cl_demo_output=>write( 'Purchase Order Created or Initiated' ).
*    cl_demo_output=>display(
**      data    =
**      name    =
**      exclude =
**      include =
*    ).
*  ENDMETHOD.
*
*ENDCLASS.
*
*CLASS lcl_inv DEFINITION INHERITING FROM lcl_document.
*  PUBLIC SECTION.
*    METHODS: display REDEFINITION.
*
*ENDCLASS.
*
*CLASS lcl_inv IMPLEMENTATION.
*
*  METHOD display.
*    cl_demo_output=>write( 'Invoice Created or Initiated' ).
*    cl_demo_output=>display( ).
*  ENDMETHOD.
*
*ENDCLASS.
*
*CLASS lcl_factory_document DEFINITION.
*  PUBLIC SECTION.
*    CLASS-METHODS : create_docu IMPORTING iv_type TYPE string RETURNING VALUE(ro_document) TYPE REF TO lcl_document.
*ENDCLASS.
*
*CLASS lcl_factory_document IMPLEMENTATION.
*
*  METHOD create_docu.
*
*    CASE iv_type.
*      WHEN 'SO'.
*        CREATE OBJECT ro_document TYPE lcl_so.
*      WHEN 'PO'.
*        CREATE OBJECT ro_document TYPE lcl_po.
*      WHEN 'INV'.
*        CREATE OBJECT ro_document TYPE lcl_inv.
*    ENDCASE.
*
*  ENDMETHOD.
*
*ENDCLASS.

*INTERFACE if_pricing_strategy.
*  METHODS calculate_price IMPORTING iv_amount TYPE netpr RETURNING VALUE(rv_amount) TYPE netpr.
*ENDINTERFACE.
*
*CLASS lcl_std_pricing DEFINITION.
*  PUBLIC SECTION.
*    INTERFACES : if_pricing_strategy.
*
*ENDCLASS.
*
*CLASS lcl_std_pricing IMPLEMENTATION.
*
*  METHOD if_pricing_strategy~calculate_price.
*    rv_amount = iv_amount.
*  ENDMETHOD.
*
*ENDCLASS.
*
*CLASS lcl_discount_pricing DEFINITION.
*  PUBLIC SECTION.
*    INTERFACES : if_pricing_strategy.
*
*ENDCLASS.
*
*CLASS lcl_discount_pricing IMPLEMENTATION.
*
*  METHOD if_pricing_strategy~calculate_price.
*    rv_amount = iv_amount * '0.9'.
*  ENDMETHOD.
*
*ENDCLASS.
*
*CLASS lcl_pricing_context DEFINITION.
*
*  PUBLIC SECTION.
*
*    METHODS : set_strategy IMPORTING io_stratgey TYPE REF TO if_pricing_strategy,
*      execute_strategy IMPORTING iv_amount TYPE netpr RETURNING VALUE(rv_final_amount) TYPE netpr.
*
*  PRIVATE SECTION.
*    DATA go_strategy TYPE REF TO if_pricing_strategy.
*
*ENDCLASS.
*
*CLASS lcl_pricing_context IMPLEMENTATION.
*
*  METHOD execute_strategy.
*    rv_final_amount = go_strategy->calculate_price( iv_amount = iv_amount ).
*  ENDMETHOD.
*
*  METHOD set_strategy.
*    go_strategy = io_stratgey.
*  ENDMETHOD.
*
*ENDCLASS.

*INTERFACE if_observer.
*  METHODS : update IMPORTING iv_message TYPE string.
*ENDINTERFACE.
*
*CLASS lcl_sales_order DEFINITION.
*
*  PUBLIC SECTION.
*
*    METHODS : register_observer IMPORTING io_observer TYPE REF TO if_observer,
*      notify_observers.
*
*  PRIVATE SECTION.
*    DATA : gt_observers TYPE TABLE OF REF TO if_observer.
*
*ENDCLASS.
*
*CLASS lcl_sales_order IMPLEMENTATION.
*
*
*  METHOD notify_observers.
*    DATA : lo_observer TYPE REF TO if_observer.
*    LOOP AT gt_observers INTO lo_observer.
*      lo_observer->update( 'Sales Order Created' ).
*    ENDLOOP.
*  ENDMETHOD.
*
*  METHOD register_observer.
*    APPEND io_observer TO gt_observers.
*  ENDMETHOD.
*
*ENDCLASS.
*
*CLASS lcl_finance DEFINITION.
*  PUBLIC SECTION.
*    INTERFACES if_observer.
*ENDCLASS.
*
*CLASS lcl_finance IMPLEMENTATION.
*
*  METHOD if_observer~update.
*    WRITE : 'Finance Department Notified:', iv_message.
*  ENDMETHOD.
*
*ENDCLASS.
*
*CLASS lcl_warehouse DEFINITION.
*  PUBLIC SECTION.
*    INTERFACES if_observer.
*ENDCLASS.
*
*CLASS lcl_warehouse IMPLEMENTATION.
*
*  METHOD if_observer~update.
*    WRITE : 'Warehouse Notified:', iv_message.
*  ENDMETHOD.
*
*ENDCLASS.

INTERFACE if_material_pricing.
  METHODS : get_price RETURNING VALUE(rv_price) TYPE znetpr.
ENDINTERFACE.

CLASS lcl_std_pricing DEFINITION.

  PUBLIC SECTION.
    INTERFACES if_material_pricing.
    METHODS constructor
      IMPORTING
        i_base_price TYPE znetpr.

  PRIVATE SECTION.
    DATA : mv_base_price TYPE znetpr.

ENDCLASS.

CLASS lcl_std_pricing IMPLEMENTATION.

  METHOD constructor.

    me->mv_base_price = i_base_price.

  ENDMETHOD.

  METHOD if_material_pricing~get_price.
    rv_price = mv_base_price.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_tax_decorator DEFINITION .

  PUBLIC SECTION.

    INTERFACES : if_material_pricing.

    METHODS: constructor IMPORTING io_pricing TYPE REF TO if_material_pricing iv_tax_percent TYPE znetpr.
  PRIVATE SECTION.
    DATA: go_pricing     TYPE REF TO if_material_pricing,
          mv_tax_percent TYPE znetpr.
ENDCLASS.

CLASS lcl_tax_decorator IMPLEMENTATION.

  METHOD constructor.
    go_pricing = io_pricing.
    mv_tax_percent = iv_tax_percent.
  ENDMETHOD.

  METHOD if_material_pricing~get_price.
    rv_price = go_pricing->get_price( ) * ( 1 + mv_tax_percent / 100 ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_discount_decorator DEFINITION .

  PUBLIC SECTION.

    INTERFACES : if_material_pricing.

    METHODS: constructor IMPORTING io_pricing TYPE REF TO if_material_pricing iv_tax_percent TYPE znetpr.
  PRIVATE SECTION.
    DATA: go_pricing     TYPE REF TO if_material_pricing,
          mv_tax_percent TYPE znetpr.
ENDCLASS.

CLASS lcl_discount_decorator IMPLEMENTATION.

  METHOD constructor.
    go_pricing = io_pricing.
    mv_tax_percent = iv_tax_percent.
  ENDMETHOD.

  METHOD if_material_pricing~get_price.
    rv_price = go_pricing->get_price( ) * ( 1 - mv_tax_percent / 100 ).
  ENDMETHOD.
ENDCLASS.
