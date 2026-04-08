*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_pr_evt DEFINITION
  INHERITING FROM cl_abap_behavior_event_handler.
  PRIVATE SECTION.
    METHODS handle_submitted FOR ENTITY EVENT
      IMPORTING params FOR PRHeader~PRSubmitted.
    METHODS handle_approved FOR ENTITY EVENT
      IMPORTING params FOR PRHeader~PRApproved.
    METHODS handle_rejected FOR ENTITY EVENT
      IMPORTING params FOR PRHeader~PRRejected.
ENDCLASS.

CLASS lcl_pr_evt IMPLEMENTATION.

  METHOD handle_approved.
    DATA lt_log TYPE TABLE OF zpr_event_log.

    LOOP AT params INTO DATA(ls_param).
      APPEND VALUE #(
        pr_number    = ls_param-pr_number
        event_type   = 'APPROVED'
        event_at     = cl_abap_context_info=>get_system_date( )
        triggered_by = cl_abap_context_info=>get_user_alias( )
      ) TO lt_log.
    ENDLOOP.

    MODIFY zpr_event_log FROM TABLE @lt_log.

  ENDMETHOD.

  METHOD handle_rejected.
    DATA lt_log TYPE TABLE OF zpr_event_log.

    LOOP AT params INTO DATA(ls_param).
      APPEND VALUE #(
        pr_number    = ls_param-pr_number
        event_type   = 'REJECTED'
        event_at     = cl_abap_context_info=>get_system_date( )
        triggered_by = cl_abap_context_info=>get_user_alias( )
      ) TO lt_log.
    ENDLOOP.
    cl_abap_tx=>save( ).
    MODIFY zpr_event_log FROM TABLE @lt_log.

  ENDMETHOD.

  METHOD handle_submitted.

    DATA lt_log TYPE TABLE OF zpr_event_log.

    LOOP AT params INTO DATA(ls_param).
      APPEND VALUE #(
              pr_number    = ls_param-pr_number
              event_type   = 'SUBMITTED'
              event_at     = cl_abap_context_info=>get_system_date( )
              triggered_by = ls_param-requested_by
            ) TO lt_log.
    ENDLOOP.
    MODIFY zpr_event_log FROM TABLE @lt_log.

  ENDMETHOD.

ENDCLASS.
