SELECT
  CC._metadata_doc_id as _id,
  FullProposalId,
  FirstPaymentDate,
  MonthlyEffectiveTotalCost,
  YearlyEffectiveTotalCost,
  YearlyInterestRate,
  MonthlyInterestRate,
  AvailableAmount,
  NumberOfInstallments,
  InstallmentValue,
  ApprovalFeedback,
  DateTime(TimeStamp(CloseDate),"America/Sao_Paulo") as CloseDate,
  FP.CPF
FROM
  `bom-pra-credito.datamart.ClosedContractConditionss` AS CC
 LEFT JOIN `bom-pra-credito.datamart.FullProposals` AS FP ON CC.`FullProposalId` = FP.`_metadata_doc_id`; 
