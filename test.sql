/*
####################################################################################
# Name: 10pt_blanktechname
# Description: Count the number of distinct tapad id by day and device
# Input: default.id_syncs table
# Output: An Impala table of number of Tapad ids by day and device
# Version:
#   2016/10/20 RS: Initial version
#   
####################################################################################
*/
use rata; drop table if exists rata.pt_blank_dvctechname;

create table rata.pt_blank_dvctechname row format delimited fields terminated by '\t' as (
select user_agent, platform, device_techname from
(select a.header.user_agent as user_agent, a.header.platform as platform,
 case when lower(a.header.user_agent) like '%cpu iphone os 10%' then 'iphone os 10'
  	 when lower(a.header.user_agent) like '%cpu iphone os 9%' then 'iphone os 9'
  	 when lower(a.header.user_agent) like '%cpu iphone os 8%' then 'iphone os 8'
  	 when lower(a.header.user_agent) like '%cpu iphone os 7%' then 'iphone os 7'
  	 when lower(a.header.user_agent) like '%cpu iphone os 6%' then 'iphone os 6'
  	 when lower(a.header.user_agent) like '%cpu iphone os 5%' then 'iphone os 5'
  	 when lower(a.header.user_agent) like '%cpu iphone os 4%' then 'iphone os 4'
  	 when lower(a.header.user_agent) like '%cpu iphone os 3%' then 'iphone os 3'
	 when lcase(a.header.user_agent) like '%(null) [fban%' and lcase(a.header.user_agent) like '%fbdv/iphone%' then regexp_extract(regexp_replace(lcase(a.header.user_agent),'.*fbdv/',''),'iphone[0-9]',0) 
  	 when lower(a.header.user_agent) like '%ipad%' then 'ipad'
  	 when lower(a.header.user_agent) like '%lenovo a2010%' then 'lenovo a2010'
	 when lower(a.header.user_agent) like '%lenovo a859%' then 'lenovo a859'
	 when lower(a.header.user_agent) like '%lenovo_s920%' then 'lenovo s920'
  	 when lower(a.header.user_agent) like '%nokia603%' then 'nokia603'
	 when lower(a.header.user_agent) like '%lumia 640%' then 'lumia 640'
	 when lower(a.header.user_agent) like '%lumia 435%' then 'lumia 435'
	 when lower(a.header.user_agent) like '%lenovo_p780%' then 'lenovo p780'
	 when lower(a.header.user_agent) like '%lenovo b8000%' then 'lenovo b8000'
	 when lower(a.header.user_agent) like '%applewebkit%' and lower(a.header.user_agent) like '%android 4.%' then regexp_replace(regexp_replace(lcase(a.header.user_agent),'.*android 4.[0-9].[0-9];',''),'AppleWebKit/.*','')
     when (lcase(a.header.user_agent) like '%tablet; rv%' or (lcase(a.header.user_agent) like '%windows nt%' and (lcase(a.header.user_agent) like '%tablet pc%' or lcase(a.header.user_agent) like '%touch%')) then 'unindentified tablet' 
	 when lcase(a.header.user_agent) like '%mobile; rv:%' then 'unindentified android' 
	 when lower(a.header.user_agent) like 'i-mobile i-style 7.5a' then 'i-mobile i-style 7.  5a'
  	 when a.header.platform like '%COMPUTER%' or lower(a.header.user_agent) like '%windows nt' or lower(a.header.user_agent) like '%macintosh%' then 'computer'
  	 when a.header.platform like '%FEATURE%' then 'feature phone'
  	 when lower(a.header.user_agent) like '%zh-cn%' and lower(a.header.user_agent) like '%; android%' and lower(a.header.user_agent) not like '%build%'  then
  			trim(regexp_replace(regexp_replace(regexp_extract(lower(a.header.user_agent), 'zh-cn;.+; android',0),'zh-cn; ',''),'; android',''))
  	 when lower(a.header.user_agent) like '%zh-cn%' and lower(a.header.user_agent) like '%android%'  and lower(a.header.user_agent) not like '%; android%' and lower(a.header.user_agent) not like '%build%'  then
  			trim(regexp_replace(regexp_replace(regexp_extract(lower(a.header.user_agent), 'zh-cn;.+android',0),'zh-cn; ',''),'android',''))
  	 when lower(a.header.user_agent) like '%zh-cn%' and lower(a.header.user_agent) like '%android%' and lower(a.header.user_agent) like '%build%'  then
  			trim(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_extract(lower(a.header.user_agent), 'zh-cn;.+build',0),'q.+',''),'zh-cn; ',''),'android',''),'build',''))

  	 when lower(a.header.user_agent) like '%windows phone%' and lower(a.header.user_agent) like '%samsung%' then
  			trim(regexp_replace(regexp_replace(regexp_extract(lower(a.header.user_agent), 'samsung;.+like iphone os',0),'samsung; ',''),' like iphone.+',''))

  	 when lower(a.header.user_agent) like '%windows phone%' and lower(a.header.user_agent) like '%microsoft%' and lower(a.header.user_agent) not like '%iphone os%' then trim(regexp_replace(regexp_replace(regexp_extract(lower(a.header.user_agent), 'microsoft;.+ applewebkit',0),'microsoft; ',''),' applewebkit',''))

  	 when lower(a.header.user_agent) like '%windows phone%' and lower(a.header.user_agent) like '%microsoft%' and lower(a.header.user_agent) like '%iphone os%' then trim(regexp_replace(regexp_replace(regexp_extract(lower(a.header.user_agent), 'microsoft;.+like iphone os',0),'microsoft; ',''),' like iphone.+',''))

  	 when lower(a.header.user_agent) like '%windows phone%' and lower(a.header.user_agent) like '%nokia%' and lower(a.header.user_agent) like '%like%' then
  			trim(regexp_replace(regexp_replace(regexp_extract(lower(a.header.user_agent), 'nokia;.+like',0),'like.+',''),'nokia;',''))
  	 when lower(a.header.user_agent) like '%windows phone%' and lower(a.header.user_agent) like '%nokia%' and lower(a.header.user_agent) not like '%like%' then
  			trim(regexp_replace(lower(a.header.user_agent), '.+nokia;',''))

   else regexp_replace(regexp_replace(trim(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(lower(trim(regexp_replace(regexp_replace(regexp_extract(a.header.user_agent, ';.+Build',0),'.+;',''),'Build',''))),'samsung ',''), 'huawei ',''), 'lg-','lg '), 'asus_','asus '),'sony ','')),'-sm','sm'),'-sgh','sgh')

   end as device_techname
from default.id_syncs a, a.header.incoming_ids b, b.sightings_by_id_type c where a.header.network.country='THA' and partner_id in (2243)  and YEAR=2016 and MONTH=11 and c.key='TAPAD_COOKIE' and a.header.platform in ('ANDROID','ANDROID_TABLET','WINDOWS_PHONE','WINDOWS_TABLET','IPHONE') /*Mobile platform*/) A where device_techname ="" group by user_agent, platform, device_techname);

select * from rata.pt_blank_dvctechname;
