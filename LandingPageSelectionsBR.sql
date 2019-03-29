SELECT
_metadata_doc_id as _id, 
Name,
DateTime(timestamp(DateTime),"America/Sao_Paulo") as DateTime,
LandingPageId,
LandingPageName,
GenericCampaignId,
GenericCampaignName,
IsMobile,
UserAgent

FROM `bom-pra-credito.datamart.LandingPageSelections`
