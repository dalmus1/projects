#Stop v21 Services
Set-Service LPA_Santander_WorkflowMonitorService -Startuptype Automatic -Status Running
Set-Service LPA_Santander_AdInformationCacheBuilder -Startuptype Disabled -Status Stopped
Set-Service LPA_Santander_CostImportService -Startuptype Disabled -Status Stopped
Set-Service LPA_Santander_CostImportServiceEDG -Startuptype Disabled -Status Stopped
Set-Service LPA_Santander_DecisionEngineService -Startuptype Disabled -Status Stopped
Set-Service LPA_Santander_DecisionEngineService_COST -Startuptype Disabled -Status Stopped
Set-Service LPA_Santander_DecisionEngineServiceReports -Startuptype Disabled -Status Stopped 
Set-Service LPA_Santander_DocumentExport -Startuptype Disabled -Status Stopped
Set-Service LPA_Santander_KidCalculationGetService -Startuptype Disabled -Status Stopped
Set-Service LPA_Santander_KidCalculationPushService -Startuptype Disabled -Status Stopped
Set-Service LPA_Santander_LogFileCleaner -Startuptype Disabled -Status Stopped
Set-Service LPA_Santander_MDSUpdateService -Startuptype Disabled -Status Stopped
Set-Service LPA_Santander_UpdatedDocumentsReport -Startuptype Disabled -Status Stopped
Set-Service LPA_Santander_UpdatedDocumentsReport_Poland -Startuptype Disabled -Status Stopped
Set-Service LPA_Santander_WebRequester -Startuptype Disabled -Status Stopped
Set-Service LPA_Santander_WorkflowMonitorService -Startuptype Disabled -Status Stopped