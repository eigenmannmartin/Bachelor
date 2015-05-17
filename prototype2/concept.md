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
C_PRES_STORE_update meta:{ model:[model_name] }, data:{}
C_PRES_STORE_delete meta:{ model:[model_name], id:[element_id] }

--- API Layer ----------------------------------------
API will listen to C_PRES_STORE_update and delete


--- API Layer ----------------------------------------
S_API_WEB_get meta:{ model:[model_name], [id:[element_id]] } 
S_API_WEB_put meta:{ model:[model_name] }, data:{ obj:{} }
S_API_WEB_update meta:{ model:[model_name] }, data:{ obj:{}, prev:{} }
S_API_WEB_delete meta:{ model:[model_name] }, data:{ obj:{} }

S_API_WEB_send meta:{ model:[model_name], [socket:[socket]] } data:{ obj:{} }

--- Logic Layer --------------------------------------
S_LOGIC_SM_get meta:{ model:[model_name], socket:[socket], [id:[element_id]] } 
S_LOGIC_SM_create meta:{ model:[model_name] }, data:{ obj:{} }
S_LOGIC_SM_update meta:{ model:[model_name] }, data:{ obj:{}, prev:{} }
S_LOGIC_SM_delete meta:{ model:[model_name] }, data:{ obj:{} }

--- Storage Layer ------------------------------------
Sequelize async API