/*Example of command on Unix using to:*/

/*Execute the impala code*/
impala-shell -i impala.prd.sg1.tapad.com:21000 -f 01load_mobileatlas.txt
impala-shell -i impala.prd.sg1.tapad.com:21000 -f 02pantip_sighting_device.txt

/*Export created Impala tables to csv file */

impala-shell -i impala.prd.sg1.tapad.com:21000 -B -o /local/home/rata.suwantong/pantip_sighting_bydevice_pre.csv --output_delimiter=',' -q "use rata;  select * from rata.pantip_sighting_bydevice_atlas order by day desc, num_tapad_id desc"
  
/*Name the columns in the csv files */  
echo $'DATE,MOBILE_PLATFORM,HL_CARRIER,CARRIER, DEVICE_TECHNAME, BRAND, DEVICE_COMMERCNAME, HL_DEVICE_COMMERCNAME, RELEASE_YEAR, RELEASE_MONTH, RELEASE_PRICE, SCREENSIZE, NUM_TAPAD_ID' | cat - pantip_sighting_bydevice_pre.csv > pantip_sighting_bydevice_201610.csv
  
/* Zip the csv files*/ 
zip -r pantip_sighting_bydevice_201610.zip pantip_sighting_bydevice_201610.csv
