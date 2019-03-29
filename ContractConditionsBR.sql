SELECT
  _metadata_doc_id as _id,
  FullProposalId,
  DateTime(TimeStamp(CreateDate),"America/Sao_Paulo") as CreateDate,
  FirstPaymentDate,
  MonthlyEffectiveTotalCost,
  YearlyEffectiveTotalCost,
  YearlyInterestRate,
  MonthlyInterestRate,
  AvailableAmount,
  NumberOfInstallments,
  InstallmentValue,
  ApprovalFeedback, 
  CPF
FROM `bom-pra-credito.datamart.ContractConditions`
