CLASS lhc_PRHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR PRHeader RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR PRHeader RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE PRHeader.

    METHODS earlynumbering_cba_Items FOR NUMBERING
      IMPORTING entities FOR CREATE PRHeader\_Items.

    METHODS approve FOR MODIFY
      IMPORTING keys FOR ACTION PRHeader~approve RESULT result.

    METHODS reject FOR MODIFY
      IMPORTING keys FOR ACTION PRHeader~reject RESULT result.

    METHODS submitForApproval FOR MODIFY
      IMPORTING keys FOR ACTION PRHeader~submitForApproval RESULT result.

    METHODS setInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR PRHeader~setInitialStatus.

    METHODS checkItemsExist FOR VALIDATE ON SAVE
      IMPORTING keys FOR PRHeader~checkItemsExist.

    METHODS checkMandatoryFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR PRHeader~checkMandatoryFields.

ENDCLASS.

CLASS lhc_PRHeader IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_pr_header IN LOCAL MODE
    ENTITY PRHeader
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_headers)
        FAILED failed.

    result = VALUE #( FOR ls_header IN lt_headers
                      LET lv_is_draft = COND #( WHEN ls_header-Status = 'D'
                                                THEN if_abap_behv=>fc-o-enabled
                                                ELSE if_abap_behv=>fc-o-disabled )
                          lv_is_submitted = COND #( WHEN ls_header-Status = 'S'
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )
                       IN (
                            %tky                      = ls_header-%tky
                            %action-submitForApproval = lv_is_draft
                            %action-approve           = lv_is_submitted
                            %action-reject            = lv_is_submitted
                            %update                   = lv_is_draft
                            %delete                   = lv_is_draft
                          )
                    ).

  ENDMETHOD.

  METHOD get_global_authorizations.

    " Check if create is requested
    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      result-%create = if_abap_behv=>auth-allowed.
    ENDIF.

    " Check if actions are requested
    IF requested_authorizations-%action-submitForApproval = if_abap_behv=>mk-on.
      result-%action-submitForApproval = if_abap_behv=>auth-allowed.
    ENDIF.

    IF requested_authorizations-%action-approve = if_abap_behv=>mk-on.
      result-%action-approve = if_abap_behv=>auth-allowed.
    ENDIF.

    IF requested_authorizations-%action-reject = if_abap_behv=>mk-on.
      result-%action-reject = if_abap_behv=>auth-allowed.
    ENDIF.

  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA : lV_OBJECT   TYPE if_numberrange_buffer=>nr_object,
           lV_INTERVAL TYPE if_numberrange_buffer=>nr_interval,
           lV_QUANTITY TYPE if_numberrange_buffer=>nr_quantity.

    LOOP AT entities INTO DATA(entity).

      " Skip if already assigned
      IF entity-PrNumber IS NOT INITIAL.
        APPEND CORRESPONDING #( entity ) TO mapped-prheader.
        CONTINUE.
      ENDIF.

*      TRY.
*
*          cl_numberrange_runtime=>number_get(
*            EXPORTING
*              nr_range_nr       = '01'
*              object            = 'ZPR_NUM'
*              quantity          = 1
*            IMPORTING
*              number            = DATA(lv_number)
*              returncode        = DATA(lv_subrc)
*              returned_quantity = DATA(lv_total_quantity)
*          ).
*        CATCH cx_nr_object_not_found.
*        CATCH cx_number_ranges INTO DATA(lr_error).
      SELECT SINGLE FROM ztpr_header FIELDS MAX( pr_number ) INTO @DATA(lv_pr_number).
      IF sy-subrc NE 0.
        lv_pr_number = '4600000000'.
*        APPEND VALUE #( %cid    = entity-%cid
*                %msg    = new_message_with_text(
*                  severity = if_abap_behv_message=>severity-error
*                  text     = 'Error while reading Number range' )
*              ) TO reported-prheader.
      ELSE.
        IF lv_pr_number IS INITIAL.
          lv_pr_number = 4600000000.
        ENDIF.
        lv_pr_number += 1.
      ENDIF.
*      CONTINUE.
*      ENDTRY.

      APPEND VALUE #( %cid = entity-%cid
                      %key = VALUE #( PrNumber = lv_pr_number )
                      %is_draft = entity-%is_draft
                    ) TO mapped-prheader.

    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Items.

    LOOP AT entities INTO DATA(entity).

      DATA(lv_item_number) = CONV posnr( 0 ).

      LOOP AT entity-%target INTO DATA(item).

        IF item-ItemNumber IS NOT INITIAL.
          APPEND CORRESPONDING #( item ) TO mapped-pritem.
          CONTINUE.
        ENDIF.

        lv_item_number = lv_item_number + 10.

        APPEND VALUE #( %cid = item-%cid
                        %key = VALUE #( PrNumber = entity-PrNumber
                                        ItemNumber = lv_item_number )
                        %is_draft = entity-%is_draft
                      ) TO mapped-pritem.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD approve.

    READ ENTITIES OF zi_pr_header IN LOCAL MODE
        ENTITY PRHeader
          FIELDS ( Status )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_headers)
        FAILED failed.

    LOOP AT lt_headers INTO DATA(ls_header).

      " Guard — only Submitted can be approved
      IF ls_header-Status <> 'S'.
        APPEND VALUE #( %tky = ls_header-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = 'Only Submitted PRs can be approved' )
                      ) TO reported-PRHeader.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-PRHeader.
        CONTINUE.
      ENDIF.

      " Transition S → A
      MODIFY ENTITIES OF zi_pr_header IN LOCAL MODE
        ENTITY PRHeader
          UPDATE FIELDS ( Status )
          WITH VALUE #(
                        ( %tky   = ls_header-%tky
                          Status = 'A' )
                      ).

    ENDLOOP.

    READ ENTITIES OF zi_pr_header IN LOCAL MODE
      ENTITY PRHeader
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #( FOR ls IN lt_result
                        ( %tky   = ls-%tky
                          %param = ls )
                    ).

  ENDMETHOD.

  METHOD reject.


    READ ENTITIES OF zi_pr_header IN LOCAL MODE
      ENTITY PRHeader
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers)
      FAILED failed.

    LOOP AT lt_headers INTO DATA(ls_header).

      " Guard — only Submitted can be rejected
      IF ls_header-Status <> 'S'.
        APPEND VALUE #( %tky = ls_header-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = 'Only Submitted PRs can be rejected' )
                      ) TO reported-PRHeader.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-PRHeader.
        CONTINUE.
      ENDIF.

      " Transition S → R
      MODIFY ENTITIES OF zi_pr_header IN LOCAL MODE
        ENTITY PRHeader
          UPDATE FIELDS ( Status )
          WITH VALUE #(
            ( %tky   = ls_header-%tky
              Status = 'R' )
          ).

    ENDLOOP.

    READ ENTITIES OF zi_pr_header IN LOCAL MODE
      ENTITY PRHeader
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #( FOR ls IN lt_result
                        ( %tky   = ls-%tky
                          %param = ls )
                    ).

  ENDMETHOD.

  METHOD submitForApproval.


    READ ENTITIES OF zi_pr_header IN LOCAL MODE
      ENTITY PRHeader
        FIELDS ( Status PrNumber )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers)
      FAILED failed.

    LOOP AT lt_headers INTO DATA(ls_header).

      " Guard — only Draft can be submitted
      IF ls_header-Status <> 'D'.
        APPEND VALUE #( %tky = ls_header-%tky
                         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text     = 'Only Draft PRs can be submitted' )
                      ) TO reported-PRHeader.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-PRHeader.
        CONTINUE.
      ENDIF.

      " Transition D → S
      MODIFY ENTITIES OF zi_pr_header IN LOCAL MODE
        ENTITY PRHeader
          UPDATE FIELDS ( Status )
          WITH VALUE #(
            ( %tky   = ls_header-%tky
              Status = 'S' )
          ).

    ENDLOOP.

    " Return updated records to UI
    READ ENTITIES OF zi_pr_header IN LOCAL MODE
      ENTITY PRHeader
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #( FOR ls IN lt_result
                        ( %tky   = ls-%tky
                          %param = ls )
                    ).

  ENDMETHOD.

  METHOD setInitialStatus.

    READ ENTITIES OF zi_pr_header IN LOCAL MODE
    ENTITY PRHeader
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_headers).

    MODIFY ENTITIES OF zi_pr_header IN LOCAL MODE
    ENTITY PRHeader
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR ls_hdr IN lt_headers
                      WHERE ( Status IS INITIAL )
                      ( %tky = ls_hdr-%tky
                        Status = 'D' )
                    ).

  ENDMETHOD.

  METHOD checkItemsExist.

    READ ENTITIES OF zi_pr_header IN LOCAL MODE
    ENTITY PRHeader BY \_Items
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    LOOP AT keys INTO DATA(key).

      READ TABLE lt_items
        WITH KEY PrNumber = key-PrNumber
        TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        APPEND VALUE #( %tky = key-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = 'At least one item is required' )
                      ) TO reported-PRHeader.
        APPEND VALUE #( %tky = key-%tky ) TO failed-PRHeader.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD checkMandatoryFields.

    READ ENTITIES OF zi_pr_header IN LOCAL MODE
    ENTITY PRHeader
      FIELDS ( PrDate Department )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).

    LOOP AT lt_headers INTO DATA(ls_header).

      " Business rule — PR Date cannot be in the past
      IF ls_header-PrDate < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %tky = ls_header-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = 'PR Date cannot be in the past' )
                      ) TO reported-PRHeader.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-PRHeader.
      ENDIF.

*      " Business rule — Department must exist in dept table
*      SELECT SINGLE dept_code
*        FROM ztpr_dept
*        WHERE dept_code = @ls_header-Department
*          AND active    = @abap_true
*        INTO @DATA(lv_dept).
*
*      IF sy-subrc <> 0.
*        APPEND VALUE #( %tky = ls_header-%tky
*                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                      text     = 'Department does not exist or is inactive' )
*                      ) TO reported-PRHeader.
*        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-PRHeader.
*      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_PRItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalValue FOR DETERMINE ON MODIFY
      IMPORTING keys FOR PRItem~calculateTotalValue.

ENDCLASS.

CLASS lhc_PRItem IMPLEMENTATION.

  METHOD calculateTotalValue.

    " Step 1 — Navigate from items up to parent headers
    READ ENTITIES OF zi_pr_header IN LOCAL MODE
      ENTITY PRItem BY \_Header
        FIELDS ( PrNumber )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).

    " Step 2 — For each header sum all item values
    LOOP AT lt_headers INTO DATA(ls_header).

      READ ENTITIES OF zi_pr_header IN LOCAL MODE
        ENTITY PRHeader BY \_Items
          FIELDS ( Price Quantity )
          WITH VALUE #(
            ( %tky = ls_header-%tky )
          )
        RESULT DATA(lt_items).

      " Step 3 — Calculate Price x Quantity for all items
      DATA(lv_total) = REDUCE ztpr_header-total_value( INIT sum  = CONV ztpr_header-total_value( 0 )
                                                       FOR  item IN lt_items
                                                       NEXT sum  = sum + ( item-Price * item-Quantity )
                                                     ).

      " Step 4 — Push total back to Header
      MODIFY ENTITIES OF zi_pr_header IN LOCAL MODE
        ENTITY PRHeader
          UPDATE FIELDS ( TotalValue )
          WITH VALUE #(
            ( %tky       = ls_header-%tky
              TotalValue = lv_total )
          ).

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
