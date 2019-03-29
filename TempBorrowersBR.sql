SELECT
  _metadata_doc_id AS _id, 
  Name, 
  Email, 
  DateTime(TimeStamp(CreateDate),"America/Sao_Paulo") AS CreateDate
FROM `bom-pra-credito.datamart.TempBorrowers`;
