SELECT
	EST._metadata_doc_id as _id,
	EST.CPF,
	EST.ScoreName,
	SAFE_CAST(EST.ScoreValue AS FLOAT64) AS ScoreValue,
  DateTime(TimeStamp(RequestDate),"America/Sao_Paulo") as RequestDate,
  DateTime(TimeStamp(ResponseDate),"America/Sao_Paulo") as ResponseDate,
	I.Name AS Investor,
	FullProposalId,
	IF(Cached = false,0,1) AS Cached
FROM 
	`bom-pra-credito.datamart.ExternalScoreTransactions` EST 
LEFT JOIN 
	`bom-pra-credito.datamart.Investors` I 
ON 
	 EST.InvestorID = I._metadata_doc_id
