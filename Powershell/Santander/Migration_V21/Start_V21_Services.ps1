#Start V21 Services
Set-Service LPA_Santander_WorkflowMonitorService -Startuptype Automatic -Status Running
Set-Service LPA_Santander_AdInformationCacheBuilder -Startuptype Automatic -Status Running
Set-Service LPA_Santander_CostImportService -Startuptype Automatic -Status Running
Set-Service LPA_Santander_CostImportServiceEDG -Startuptype Automatic -Status Running
Set-Service LPA_Santander_DecisionEngineService -Startuptype Automatic -Status Running
Set-Service LPA_Santander_DecisionEngineService_COST -Startuptype Automatic -Status Running
Set-Service LPA_Santander_DecisionEngineServiceReports -Startuptype Automatic -Status Running 
Set-Service LPA_Santander_DocumentExport -Startuptype Automatic -Status Running
Set-Service LPA_Santander_KidCalculationGetService -Startuptype Automatic -Status Running
Set-Service LPA_Santander_KidCalculationPushService -Startuptype Automatic -Status Running
Set-Service LPA_Santander_LogFileCleaner -Startuptype Automatic -Status Running
Set-Service LPA_Santander_MDSUpdateService -Startuptype Automatic -Status Running
Set-Service LPA_Santander_UpdatedDocumentsReport -Startuptype Automatic -Status Running
Set-Service LPA_Santander_UpdatedDocumentsReport_Poland -Startuptype Automatic -Status Running
Set-Service LPA_Santander_WebRequester -Startuptype Automatic -Status Running
Set-Service LPA_Santander_WorkflowMonitorService -Startuptype Automatic -Status Running