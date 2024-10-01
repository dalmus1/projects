#Start V17 Services
Set-Service LPA_SAN_WorkflowMonitorService -Startuptype Automatic -Status Running
Set-Service LPA_SAN_AdInformationCacheBuilder -Startuptype Automatic -Status Running
Set-Service LPA_SAN_CostImportService -Startuptype Automatic -Status Running
Set-Service LPA_SAN_CostImportServiceEDG -Startuptype Automatic -Status Running
Set-Service LPA_SAN_DecisionEngineService -Startuptype Automatic -Status Running
Set-Service LPA_SAN_DecisionEngineService_COST -Startuptype Automatic -Status Running
Set-Service LPA_SAN_DecisionEngineServiceReports -Startuptype Automatic -Status Running 
Set-Service LPA_SAN_DocumentExport -Startuptype Automatic -Status Running
Set-Service LPA_SAN_KidCalculationGetService -Startuptype Automatic -Status Running
Set-Service LPA_SAN_KidCalculationPushService -Startuptype Automatic -Status Running
Set-Service LPA_SAN_LogFileCleaner -Startuptype Automatic -Status Running
Set-Service LPA_SAN_MDSUpdateService -Startuptype Automatic -Status Running
Set-Service LPA_SAN_UpdatedDocumentsReport -Startuptype Automatic -Status Running
Set-Service LPA_SAN_UpdatedDocumentsReport_Poland -Startuptype Automatic -Status Running
Set-Service LPA_SAN_WebRequester -Startuptype Automatic -Status Running
Set-Service LPA_SAN_WorkflowMonitorService -Startuptype Automatic -Status Runninga