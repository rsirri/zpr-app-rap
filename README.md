# zpr-app-rap
SAP BTP RAP Purchase Requisition App - ABAP Cloud
🛒 Purchase Requisition App — SAP BTP RAP
A full-stack Purchase Requisition (PR) management application built on SAP BTP ABAP Cloud using the ABAP RESTful Application Programming Model (RAP). This is a portfolio project demonstrating modern SAP development capabilities across the full BTP stack.

🏗️ Architecture Overview
┌─────────────────────────────────────────────────────────────┐
│                    Fiori Elements UI                         │
│          (List Report + Object Page + Draft)                 │
└────────────────────────┬────────────────────────────────────┘
                         │ OData V4
┌────────────────────────▼────────────────────────────────────┐
│              Service Binding (ZSRB_PR_APP_UI)                │
│              Service Definition (ZSD_PR_APP)                 │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│           Projection Layer  (ZC_ — Consumption Views)        │
│     ZC_PR_HEADER  ◄──────────────►  ZC_PR_ITEM              │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│           Interface Layer   (ZI_ — Composite Views)          │
│     ZI_PR_HEADER  ◄──────────────►  ZI_PR_ITEM              │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│           Basic Layer       (ZR_ — DB Views)                 │
│  ZR_PR_HEADER  ZR_PR_ITEM  ZR_PR_DEPT  ZR_PR_MATERIAL       │
│  ZR_PR_PLANT   ZR_PR_VENDOR                                  │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│              Database Tables (ZTPR_*)                        │
│  ztpr_header  ztpr_item  ztpr_header_d  ztpr_item_d          │
│  ztpr_dept    ztpr_material  ztpr_plant  ztpr_vendor          │
└─────────────────────────────────────────────────────────────┘

🛠️ Tech Stack
LayerTechnology Runtime SAP BTP ABAP Cloud (Trial)IDE Eclipse ADT (no SE38, no GUI tools)BackendABAP OO · RAP Managed · CDS ViewsAPIOData V4 (UI + API bindings) FrontendSAP Fiori Elements (List Report + Object Page)DraftRAP Draft Framework (with draft tables)VersioningabapGit → GitHub

📦 Project Structure
src/
├── Database Tables
│   ├── ztpr_header        — PR Header (pr_number, status, total_value...)
│   ├── ztpr_item          — PR Items  (material, qty, price, vendor...)
│   ├── ztpr_header_d      — Draft table for Header
│   ├── ztpr_item_d        — Draft table for Items
│   ├── ztpr_dept          — Department master
│   ├── ztpr_material      — Material master
│   ├── ztpr_plant         — Plant master
│   └── ztpr_vendor        — Vendor master
│
├── CDS — Basic Views (ZR_)
│   ├── ZR_PR_HEADER
│   ├── ZR_PR_ITEM
│   └── ZR_PR_DEPT / MATERIAL / PLANT / VENDOR
│
├── CDS — Interface Views (ZI_)  [VDM Composite]
│   ├── ZI_PR_HEADER       — Root, compositions, associations, StatusCriticality
│   └── ZI_PR_ITEM         — Child, associations to material/plant/vendor
│
├── CDS — Value Help Views (ZVH_)
│   └── ZVH_PR_DEPT / MATERIAL / PLANT / VENDOR
│
├── CDS — Consumption/Projection Views (ZC_)
│   ├── ZC_PR_HEADER       — @Metadata.allowExtensions, value helps, redirections
│   └── ZC_PR_ITEM
│
├── Metadata Extensions
│   ├── ZC_PR_HEADER       — UI annotations, facets, actions, datapoints
│   └── ZC_PR_ITEM         — Line item, field groups, delivery/pricing facets
│
├── Behavior Definition
│   ├── ZI_PR_HEADER (Interface BDEF)
│   │   ├── managed · strict(2) · with draft
│   │   ├── early numbering
│   │   ├── draft actions: Edit, Activate, Discard, Resume, Prepare
│   │   ├── actions: submitForApproval, approve, reject
│   │   ├── determinations: setInitialStatus
│   │   └── validations: checkMandatoryFields, checkItemsExist
│   └── ZC_PR_HEADER (Projection BDEF)
│       └── use draft · use actions · use associations
│
├── Behavior Implementation
│   └── ZBP_I_PR_HEADER
│       ├── lhc_PRHeader
│       │   ├── get_global_authorizations
│       │   ├── get_instance_features  (button visibility per status)
│       │   ├── earlynumbering_create  (sequential PR numbers)
│       │   ├── earlynumbering_cba_Items (10/20/30 item numbering)
│       │   ├── setInitialStatus       (Status = 'D' on create)
│       │   ├── submitForApproval      (D → S)
│       │   ├── approve                (S → A)
│       │   ├── reject                 (S → R)
│       │   ├── checkMandatoryFields   (PR Date, Department)
│       │   └── checkItemsExist        (at least one item required)
│       └── lhc_PRItem
│           └── calculateTotalValue    (Price × Qty → Header.TotalValue)
│
└── Service
    ├── ZSD_PR_APP         — Service Definition
    ├── ZSRB_PR_APP_UI     — OData V4 UI Binding (Fiori Elements)
    └── ZSRB_PR_APP_API    — OData V4 API Binding (CAP consumption)

✨ Features
PR Lifecycle Management
DRAFT → SUBMITTED → APPROVED
                  ↘ REJECTED
StatusColorAvailable ActionsDraft (D)🟠 OrangeEdit · Delete · Submit for ApprovalSubmitted (S)🔵 BlueApprove · RejectApproved (A)🟢 GreenView onlyRejected (R)🔴 RedView only
Key Capabilities

Draft-enabled — save work in progress without activating
Instance feature control — buttons shown/hidden based on PR status
Auto-numbering — PR numbers from range 4600000001+
Item numbering — automatic 10/20/30 sequence
Total Value — auto-calculated from item Price × Quantity via side effects
Value Helps — Department, Material, Plant, Vendor, Currency, UoM
Criticality — status displayed with colored icons in list and object page
KPI Header Strip — Status, Total Value, PR Date as datapoints
Admin Info — Created/Changed By + At tracked automatically


🧩 CDS VDM Naming Convention
PrefixLayerPurposeZR_BasicDirect DB selects, @ObjectModel.usageTypeZI_Interface/CompositeAssociations, computed fields, BDEF targetZC_Consumption/Projectionas projection on, value helps, UI redirectionsZVH_Value Help@Search.searchable, used in @Consumption.valueHelpDefinition

🔄 How to Restore (New BTP Trial)
This repo uses abapGit for version control. To restore on a new instance:
1. Create a new BTP ABAP Cloud trial instance
2. Open Eclipse ADT → connect to new instance
3. Install abapGit plugin:
   Help → Install New Software
   URL: https://eclipse.abapgit.org/updatesite/
4. Window → Show View → abapGit Repositories
5. New Repository → Online
   URL: https://github.com/rsirri/zpr-app-rap
6. Pull → all objects recreated automatically
7. Activate all objects

🗺️ Roadmap

 Number Range — migrate from MAX()+1 workaround to cl_numberrange_runtime=>number_get with late numbering
 Release Strategy — multi-level approval via ztpr_rel_strategy + ztpr_rel_level
 RAP Events — raise PRSubmitted, PRApproved, PRRejected events
 CAP Integration — consume ZSRB_PR_APP_API from a Node.js CAP service on BTP
 ABAP Unit Tests — behavior handler test coverage


👤 Author
Rajesh Sirri
Senior SAP Technical Consultant · SAP BTP Full-Stack Developer

🌐 Portfolio: rsirri.github.io
💼 GitHub: github.com/rsirri
Built with Eclipse ADT on SAP BTP ABAP Cloud

## 🚀 Live Demo
[▶ Open App](https://87073b08-232b-42f9-ae7c-bc59cf2ae025.abap-web.us10.hana.ondemand.com/sap/bc/ui5_ui5/sap/zprapp)

📄 License
MIT License — free to use as reference or learning material.
