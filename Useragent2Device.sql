/*
####################################################################################
# Name: Useragent2Device
# Description: Extract device name from user agent
# Input: default.id_syncs table
# Version:
#   2016/11/04 RS: Initial version
#   
####################################################################################
*/


select device_techname, platform from (
select  case 
when lcase(user_agent) like '%cpu iphone os%' and lcase(user_agent) like '%ipod%' and lcase(platform)='iphone' then 'ipod' 
when lcase(user_agent) like '%cpu iphone os%' or lcase(user_agent) like '%iphone; u; cpu iphone%' or lcase(user_agent) like '%iphone; cpu os%' and lcase(platform)='iphone' then regexp_replace(regexp_replace(regexp_replace(lcase(user_agent),'.*iphone;( u;)? cpu ',''),'like mac os.*',''),'_.*','')
when lcase(user_agent) like '%(null) [fban%' and lcase(user_agent) like '%fbdv/iphone%' and lcase(platform)='iphone' then regexp_extract(regexp_replace(lcase(user_agent),'.*fbdv/',''),'iphone[0-9]',0)
when lcase(user_agent) like '%android; mobile; rv%' then 'unidentified android' else
regexp_replace(regexp_replace(regexp_replace(trim(regexp_replace(regexp_replace(regexp_replace(regexp_replace(lcase(user_agent),'.*android [0-9](.[0-9](.[0-9])?)?; ',''),' build.*|; android/.*|\\) applewebkit.*|/v[0-9] linux.*|v_td.*|_td/v[0-9].*|i_style.*',''),'.*th[-|_]gb; |.*en[-|_]au; |.*en[-|_]ph;|.*en[-|_]th; |.*th([-|_]th;)? |.*en[-|_]us; |.*zh[-|_]cn; |.*en[-|_]nz; |.*en[-|_]gb; |.*zh[-|_]tw; |.*en[-|_]fi; |.*en[-|_]tw; |.*en[-|_]jp; |.*nokia; ',''),'/.*|linux.*','')),'[^0-9a-z\- \.]',''),'.*samsung |.*lenovo |.*microsoft |.*th- ',''),'like.*|lollipop.*','') end as device_techname,
user_agent, platform  
from (select a.header.user_agent as user_agent, case when a.header.platform ='IPHONE' and lcase(a.header.user_agent) like '%windows phone%' then 'WINDOWS_PHONE' else a.header.platform end as platform from default.id_syncs a, a.header.incoming_ids b, b.sightings_by_id_type c where a.header.network.country='THA' and partner_id in (2243)  and YEAR=2016 and MONTH=11 and c.key='TAPAD_COOKIE' and a.header.platform in ('ANDROID','ANDROID_TABLET','WINDOWS_PHONE','WINDOWS_TABLET','IPHONE')) A group by device_techname, user_agent, platform) B group by device_techname, platform ;
