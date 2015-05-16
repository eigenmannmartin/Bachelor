Key-Points:
- Message based/oriented Architecture
- Separation of Concerns
- Flux Architecture
- Layers and modules are all singletons
- Dispatcher for every module
- Layer-Based function naming

Messages:
-All messages are named target specific
    [C/S]_[LAYER]_[MODULE]_[Module specific Message]
-No Callbacks




--- Presentation Layer -------------------------------
C_PRES_STORE_update meta:{ model:[model_name] }, data:{ obj:{} }
C_PRES_STORE_delete meta:{ model:[model_name], id:[element_id] }

--- API Layer ----------------------------------------
C_API_WEB_update meta:{ model:[model_name] }, data:{ obj:{} }
C_API_WEB_delete meta:{ model:[model_name], id:[element_id] }


--- API Layer ----------------------------------------
S_API_WEB_get meta:{ model:[model_name], [id:[element_id]] } 
S_API_WEB_put meta:{ model:[model_name] }, data:{ obj:{} }
S_API_WEB_update meta:{ model:[model_name] }, data:{ obj:{}, prev:{} }
S_API_WEB_delete meta:{ model:[model_name], data:{ obj:{} }

--- Logic Layer --------------------------------------
S_LOGIC_SM_get meta:{ model:[model_name], [id:[element_id]] } 
S_LOGIC_SM_create meta:{ model:[model_name] }, data:{ obj:{} }
S_LOGIC_SM_update meta:{ model:[model_name] }, data:{ obj:{}, prev:{} }
S_LOGIC_SM_delete meta:{ model:[model_name] }, data:{ obj:{} }

--- Storage Layer ------------------------------------
S_STORAGE_DB_select meta:{ model:[model_name], [id:[element_id]] } 
S_STORAGE_DB_insert meta:{ model:[model_name] }, data:{ obj:{} }
S_STORAGE_DB_update meta:{ model:[model_name], data:{ obj:{} }
S_STORAGE_DB_delete meta:{ model:[model_name] }, data:{ obj:{} }