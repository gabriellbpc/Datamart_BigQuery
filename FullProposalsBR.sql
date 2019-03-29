SELECT 
_id,
SimulationDate,
ParentProposalId,
ParentProposal,
FullProposalGroup,
BorrowerId,
CPF,
BorrowerName AS Name,
DateOfBirth,
StateOfBirth,
Gender,
EducationLevel,
MaritalStatus,
JobType,
MonthlyGrossIncome,
Device AS Device_type,
Device_family,
Device_brand
Browser_family,
Browser_version,
OperatingSystem_family,
OperatingSystem_version, 
LeadGenProviderName, 
PreSelectedFullInvestor,
--SuggestedInvestors, "VERIFICAR QUAL CAMPO NÃO ENCONTRADO" VERIFICAR CONDICAO
HasBids, 
--Bids, (Criar campo com bids separados por virgulas)
Campanha, 
CampaignName, 
lpName, 
affid, 
utm_medium, 
utm_source, 
utm_content, 
utm_campaign, 
Term, 
Amount, 
SelectedFullInvestors, 
AllocatedBranchName,
IntegrationFlows,
LoanObjective2 AS LoanObjective,
Product2 AS Product,
--Submission, = Esta na tabela MileStoneInfos - ETL ALOOMA
LinkedFullProposalId,
SelectedContractConditions,
HomeAddress.State AS HomeAddress_State,
HomeAddress.City AS HomeAddress_City,
HomeAddress.Neighborhood AS HomeAddress_Neighborhood,
HomeAddress.StreetAddress AS HomeAddress_StreetAddress,
HomeAddress.Number AS HomeAddress_Number,
HomeAddress.AdditionalData AS HomeAddress_AdditionalData,
HomeAddress.CEP AS HomeAddress_CEP,
--HomeType - VERIFICAR DANIEL condicao ja que no tempborrewers as linhas somem, (usarei e verifico) tentando achar a chave join
REGEXP_EXTRACT(LatLong,'([0-9]|-.+?),') as Lat, REGEXP_EXTRACT(LatLong,',(.+?)]') as Long,
Email,
MobilePhone2 AS MobilePhone,
HomePhone2 AS HomePhone,
HasNegativeCreditRecord, 
HasBankingData,
BankingDataStartDate2 AS BankingDataStartDate,
BankingData.BranchNumber,
BankingData.AccountNumber,
BankingAccountType,
IncomeProof,
HasVehicleData,
SUBSTR(VehicleYear,0,4) AS VehicleData_Year,
VehicleData.Value AS VehicleData_Value,
VehicleData.IsFinanced AS VehicleData_IsFinanced, 
VehicleData.AcceptedAsCollateral AS VehicleData_AcceptedAsCollateral,
HasRealEstateData, 
RealEstateData.Value AS RealEstateData_Value, 
RealEstateData.IsFinanced AS RealEstateData_IsFinanced,
RealEstateData.AcceptedAsCollateral AS RealEstateData_AcceptedAsCollateral,
RealEstateData.DocsOk AS RealEstateData_DocsOk,
Optin,
Webpush,
CurrentSalesState,
CurrentApprovalState,
CurrentDocumentationState,
CreditScore.bvs.ScoreValue AS CreditScore_BV,
--MatchScoreComplete.cbss.ScoreValue AS MatchScore_CBSS,
--MatchScoreComplete.losango.ScoreValue AS MatchScore_Losango,
--MatchScore.portocred.ScoreValue AS MatchScore_Portocred,
--MatchScore.Simplic.ScoreValue AS MatchScore_Simplic,
--MatchScoreComplete.Generic.ScoreValue AS MatchScore_Generic
--ScoreValue_CBSS,
--ScoreValue_Geru,
--ScoreValue_Marisa,
--ScoreValue_MoneyMan,
--ScoreValue_Simplic


FROM
(SELECT
  DateTime(TIMESTAMP(SimulationDate),"America/Sao_Paulo") AS SimulationDate, f.* EXCEPT (SimulationDate,Gender,MaritalStatus,EducationLevel,JobType),
  f._metadata_doc_id AS _id,
  bf.code AS FormalizationBranchCode,
  bf.name AS FormalizationBranchName,
  ba.code AS AllocatedBranchCode,
  ba.name AS AllocatedBranchName,
  i.QueueName AS PreSelectedFullInvestor,
  CONCAT(f.MobilePhone.AreaCode,'-',f.MobilePhone.Number) AS MobilePhone2,
  CONCAT(f.HomePhone.AreaCode,'-',f.HomePhone.Number) AS HomePhone2,
  f.HomeAddress.Location.coordinates as LatLong,
  CAST(VehicleData.CreateDate AS STRING) AS VehicleYear,
  IF(VehicleData.CreateDate IS NOT NULL, true, false) AS HasVehicleData,  
  IF(opt.CPF IS NOT NULL, true, false) AS Optin,
  IF(web.CPF IS NOT NULL, true, false) AS WebPush,
  IF(ParentProposalId IS NULL, true, false) AS ParentProposal,
  IF(BankingData.HasBankAccount IS NOT NULL, true, false) AS HasBankingData,
  IF(Gender = 0, 'Masculino',IF( Gender= 1 ,'Feminino',NULL)) AS Gender,
  IF(MaritalStatus = 0, 'Casado(a)', IF( MaritalStatus = 1 , 'Solteiro(a)', IF(MaritalStatus = 2 , 'Viúvo(a)', IF(MaritalStatus = 3 , 'Divorciado(a)',     IF(MaritalStatus = 4 , 'Separado(a)', IF(MaritalStatus = 5 , 'Outros', IF(MaritalStatus = 6 , 'Amasiado', NULL))))))) AS MaritalStatus,
  IF(EducationLevel = 0, 'Analfabeto', IF( EducationLevel = 1 , 'Fundamental', IF(EducationLevel = 2 , 'Médio', IF(EducationLevel = 3 , 'Superior        Incompleto', IF(EducationLevel = 4 , 'Superior Completo', NULL))))) AS EducationLevel,
  IF(JobType = 0, 'Assalariado', IF( JobType = 1 , 'Funcionário Público', IF(JobType = 2 , 'Aposentado ou Pensionista', IF(JobType = 3 , 'Autônomo',       IF(EducationLevel = 4 , 'Profissional Liberal',IF(JobType = 5, 'Empresário', IF( JobType = 6 , 'Estudante', IF(JobType = 7 , 'Forças Armadas',           IF(JobType = 8 , 'Trabalhador Rural', IF(JobType = 9 , 'Desempregado',IF(JobType = 10, 'Emprego Informal', IF( JobType = 11 , 'Em Casa', IF(JobType = 12 , 'Vive de Renda',IF(JobType = 13 , 'Outros', NULL)))))))))))))) AS JobType,
  IF(f.Product = 0, 'PersonalLoan',IF(f.Product = 1, 'PayrollLoanINSS',IF(f.Product = 2, 'PayrollLoanPublic',IF(f.Product = 3, 'PayrollLoanPrivate',IF(f.Product = 4, 'CreditCard',IF(f.Product = 5, 'RealEstateGuaranteeLoan',IF(f.Product = 6, 'WorkingCapitalLoan',IF(f.Product = 7, 'InvestmentTargetedLoan',IF(f.Product = 8, 'InvoiceOrCheckAdvance',IF(f.Product = 9, 'CompanyRealEstateGuaranteeLoan',IF(f.Product = 10, 'PrePaidCard',IF(f.Product = 11, 'AutoLoan',IF(f.Product = 12, 'RealEstateLoan',IF(f.Product = 13, 'Renegotiation',IF(f.Product = 14, 'DirectDebitPersonalLoan',IF(f.Product = 15, 'AutoGuaranteeLoan',NULL)))))))))))))))) AS Product2,
  IF(LoanObjective = 0, 'Quitação de Cartão de Crédito',IF(LoanObjective = 1, 'Consolidação de Dívidas',IF(LoanObjective = 2, 'Benfeitorias',IF(LoanObjective = 3, 'Compra de Valor Elevado',IF(LoanObjective = 4, 'Compra de Imóvel',IF(LoanObjective = 5, 'Compra de Veículos',IF(LoanObjective = 6, 'Financiamento de Moto',IF(LoanObjective = 7, 'Abrir um Negócio',IF(LoanObjective = 8, 'Viagem',IF(LoanObjective = 9, 'Despesas com Casamento',IF(LoanObjective = 10, 'Despesas Médicas',IF(LoanObjective = 11, 'Procedimentos Estéticos',IF(LoanObjective = 12, 'Despesas Dentais',IF(LoanObjective = 13, 'Despesas com Educação',IF(LoanObjective = 14, 'Contas',IF(LoanObjective = 15, 'Compras',IF(LoanObjective = 16,'Membro da Família',IF(LoanObjective = 17, 'Outros Débitos',IF(LoanObjective = 18, 'Cartão de Crédito',IF(LoanObjective = 19, 'Arrumar Veículo',IF(LoanObjective = 20, 'Pagamento por Limite de Cheque Especial',IF(LoanObjective = 999, 'Outros',NULL)))))))))))))))))))))) AS LoanObjective2,
  IF(BankingData.AccountType= 0,'Corrente',IF(BankingData.AccountType= 1,'Poupança',IF(BankingData.AccountType= 2,'Depósito Judicial Individual',IF(BankingData.AccountType= 3,'Depósito Judicial Conjunto',IF(BankingData.AccountType= 4,'Corrente Conjunta',IF(BankingData.AccountType= 5,'Poupança Conjunta',IF(BankingData.AccountType= 6,'Corrente', NULL))))))) AS BankingAccountType,
  IF(RealEstateData.DocsOk IS NOT NULL, true, false) AS HasRealEstateData,
  IF(BankingData.StartDate = '0001-01-01T00:00:00',NULL,BankingData.StartDate) AS BankingDataStartDate2,
  IF(int.FullProposalId IS NOT NULL, true, false) AS IntegrationFlows
 
FROM
  `bom-pra-credito.datamart.FullProposals` f 
  LEFT OUTER JOIN `bom-pra-credito.datamart.Investors` i ON f.SelectedFullInvestors = i._metadata_doc_id
  LEFT OUTER JOIN `bom-pra-credito.datamart.Branches` bf ON f.FormalizationBranchId = bf.id
  LEFT OUTER JOIN `bom-pra-credito.datamart.Branches` ba ON f.AllocatedBranchId = ba.id
  LEFT JOIN `bom-pra-credito.datamart.OptIns` opt ON f.CPF = opt.CPF
  LEFT JOIN `bom-pra-credito.datamart.WebPushRegistrations` web ON f.CPF = web.CPF
  LEFT JOIN `bom-pra-credito.datamart.IntegrationFlows` int ON f._metadata_doc_id = int.FullProposalId
  ) AS FP 
 