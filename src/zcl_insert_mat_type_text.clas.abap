CLASS zcl_insert_mat_type_text DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_insert_mat_type_text IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DELETE FROM ztpr_mat_type_t.    "clear first

    INSERT ztpr_mat_type_t FROM TABLE @( VALUE #(
      ( client = sy-mandt  material_type = 'ROH'  spras = 'E'  mat_type_name = 'Raw Material'     )
      ( client = sy-mandt  material_type = 'FERT' spras = 'E'  mat_type_name = 'Finished Product' )
      ( client = sy-mandt  material_type = 'HALB' spras = 'E'  mat_type_name = 'Semi-Finished'    )
      ( client = sy-mandt  material_type = 'HAWA' spras = 'E'  mat_type_name = 'Trading Goods'    )
      ( client = sy-mandt  material_type = 'DIEN' spras = 'E'  mat_type_name = 'Services'         )
      ( client = sy-mandt  material_type = 'VERP' spras = 'E'  mat_type_name = 'Packaging'        )
      ( client = sy-mandt  material_type = 'NLAG' spras = 'E'  mat_type_name = 'Non-Stock'        )
      ( client = sy-mandt  material_type = 'ERSA' spras = 'E'  mat_type_name = 'Spare Parts'      )
      ( client = sy-mandt  material_type = 'MUSE' spras = 'E'  mat_type_name = 'Samples'          )
    ) ).

    IF sy-subrc = 0.
      out->write( 'Material type texts inserted successfully' ).
    ELSE.
      out->write( |Error: { sy-subrc }| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
