@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Type Text'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #TEXT
define view entity ZR_MATTYPE
  as select from ztpr_mat_type_t
{

  key material_type as MaterialType,

      @Semantics.language: true
  key spras         as Language,

      @Semantics.text: true
      mat_type_name as MatTypeName
}
