SELECT
_metadata_doc_id as _id,
FullProposalId,
CreateDate,
DateTime,
FromState,
ToState,
CurrentRole,
Amount,
CPF,
Investor,
InvestorId,
Login

FROM
(
SELECT DateTime(timestamp(DateTime),"America/Sao_Paulo") as DateTime, 
i.QueueName as Investor, h.* except(DateTime) 

FROM `bom-pra-credito.datamart.StateTransitionHistories` h 
LEFT OUTER JOIN `bom-pra-credito.datamart.Investors` i on h.InvestorId = i._id ) AS STH
