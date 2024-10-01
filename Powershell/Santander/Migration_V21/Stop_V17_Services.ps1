#Stop v17 Services
Set-Service LPA_SAN_WorkflowMonitorService -Startuptype Automatic -Status Running
Set-Service LPA_SAN_AdInformationCacheBuilder -Startuptype Disabled -Status Stopped
Set-Service LPA_SAN_CostImportService -Startuptype Disabled -Status Stopped
Set-Service LPA_SAN_CostImportServiceEDG -Startuptype Disabled -Status Stopped
Set-Service LPA_SAN_DecisionEngineService -Startuptype Disabled -Status Stopped
Set-Service LPA_SAN_DecisionEngineService_COST -Startuptype Disabled -Status Stopped
Set-Service LPA_SAN_DecisionEngineServiceReports -Startuptype Disabled -Status Stopped 
Set-Service LPA_SAN_DocumentExport -Startuptype Disabled -Status Stopped
Set-Service LPA_SAN_KidCalculationGetService -Startuptype Disabled -Status Stopped
Set-Service LPA_SAN_KidCalculationPushService -Startuptype Disabled -Status Stopped
Set-Service LPA_SAN_LogFileCleaner -Startuptype Disabled -Status Stopped
Set-Service LPA_SAN_MDSUpdateService -Startuptype Disabled -Status Stopped
Set-Service LPA_SAN_UpdatedDocumentsReport -Startuptype Disabled -Status Stopped
Set-Service LPA_SAN_UpdatedDocumentsReport_Poland -Startuptype Disabled -Status Stopped
Set-Service LPA_SAN_WebRequester -Startuptype Disabled -Status Stopped
Set-Service LPA_SAN_WorkflowMonitorService -Startuptype Disabled -Status Stoppeda