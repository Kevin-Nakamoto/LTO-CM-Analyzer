#!/bin/sh

show_field () {
  cut_from=$(($2*2+1))
  cut_to=$(($3*2-1+$cut_from))
  msg=$4
  data=`echo $1 | cut -c $cut_from-$cut_to`

  if [ "$5" = "true" ]
  then
    echo "  "$msg": "`echo $data | xxd -p -r`
  else 
    echo "  "$msg": "$data
  fi
}    

calc_page_data () {
  start_byte=`echo "ibase=16; $1" | bc`
  start_byte=$(($start_byte*2+1))
  end_byte=$(($2*2-1+$start_byte))
  echo $3 | cut -c $start_byte-$end_byte
}

show_lto_cm_mfg_info () {
  echo "-- LTO CM Manufacturer's Information --"
  show_field $1 0 4 "LTO CM Serial Number"
  show_field $1 4 1 "CM Serial Number Check Byte"
  show_field $1 5 1 "CM Size"
  show_field $1 6 2 "Type"
  show_field $1 8 24 "Manufacturer's Information"
}

show_lto_cm_wrtinh () {
  echo "-- LTO CM Write-Inhibit --"
  show_field $1 32 1 "Last Write-Inhibited Block Number"
  show_field $1 33 1 "Block 1 Protection Flag"
  show_field $1 34 2 "Reserved"
}

show_cart_mfg_info () {
  echo "-- Cartridge Manufacturer's Information --"
  cart_mfg_info=`calc_page_data $1 64 $2`
  show_field $cart_mfg_info 0 2 "Page Id"
  show_field $cart_mfg_info 2 2 "Page Length"
  show_field $cart_mfg_info 4 8 "Cartridge Manufacturer" "true"
  show_field $cart_mfg_info 12 10 "Serial Number" "true"
  show_field $cart_mfg_info 22 2 "Cartridge Type"
  show_field $cart_mfg_info 24 8 "Date of Manufacture" "true"
  show_field $cart_mfg_info 32 2 "Tape Length"
  show_field $cart_mfg_info 34 2 "Tape Thickness"
  show_field $cart_mfg_info 36 2 "Empty Reel Inertia"
  show_field $cart_mfg_info 38 2 "Hub Radius"
  show_field $cart_mfg_info 40 2 "Full Reel Pack Radius"
  show_field $cart_mfg_info 42 2 "Maximum Media Speed"
  show_field $cart_mfg_info 44 4 "License Code"
  show_field $cart_mfg_info 48 12 "Cartridge Manufacturer's Use"
  show_field $cart_mfg_info 60 4 "CRC"
}

show_media_mfg_info () {
  echo "-- Media Manufacturer's Information --"
  media_mfg_info=`calc_page_data $1 64 $2`
  show_field $media_mfg_info 0 2 "Page Id"
  show_field $media_mfg_info 2 2 "Page Length"
  show_field $media_mfg_info 4 48 "Servowriter Manufacturer" "true"
  show_field $media_mfg_info 52 8 "Reserved"
  show_field $media_mfg_info 60 4 "CRC"
}

show_init_data () {
  echo "-- Initialisation Data --"
  init_data=`calc_page_data $1 64 $2`
  show_field $init_data 0 2 "Page Id"
  show_field $init_data 2 2 "Page Length"
  show_field $init_data 4 8 "Initialising Drive Manufacturer" "true"
  show_field $init_data 12 10 "Drive Id" "true"
  show_field $init_data 22 2 "Format Type"
  show_field $init_data 24 4 "LP1 Position"
  show_field $init_data 28 4 "LP2 Position"
  show_field $init_data 32 4 "LP3 Position"
  show_field $init_data 36 4 "LP4 Position"
  show_field $init_data 40 4 "LP5 Position"
  show_field $init_data 44 4 "LP6 Position"
  show_field $init_data 48 12 "Reserved"
  show_field $init_data 60 4 "CRC"
}

show_tape_wrt_pass () {
  echo "-- Tape Write Pass --"
  tape_wrt_pass=`calc_page_data $1 48 $2`
  show_field $tape_wrt_pass 0 2 "Page Id"
  show_field $tape_wrt_pass 2 2 "Page Length"
  show_field $tape_wrt_pass 4 12 "Reserved"
  show_field $tape_wrt_pass 16 4 "Write Pass Field 0"
  show_field $tape_wrt_pass 20 4 "Write Pass Field 1"
  show_field $tape_wrt_pass 24 4 "Write Pass Field 2"
  show_field $tape_wrt_pass 28 4 "Write Pass Field 3"
  show_field $tape_wrt_pass 32 4 "Write Pass Field 4"
  show_field $tape_wrt_pass 36 4 "Write Pass Field 5"
  show_field $tape_wrt_pass 40 4 "Write Pass Field 6"
  show_field $tape_wrt_pass 44 4 "Write Pass Field 7"
}

show_tape_dir () {
  echo "-- Tape Directory --"
  tape_dir=`calc_page_data $1 1552 $2`
  show_field $tape_dir 0 2 "Page Id"
  show_field $tape_dir 2 2 "Page Length"
  show_field $tape_dir 4 4 "FID Tape Write Pass"
  show_field $tape_dir 8 8 "Reserved"
  for i in `seq 0 95`
  do
    show_field $tape_dir $((16+$i*16)) 16 "Wrap Section $i"
  done
}

show_eod_info () {
  echo "-- EOD Information --"
  eod_info=`calc_page_data $1 64 $2`
  show_field $eod_info 0 2 "Page Id"
  show_field $eod_info 2 2 "Page Length"
  show_field $eod_info 4 4 "Tape Write Pass for last written EOD"
  show_field $eod_info 8 4 "Thread Count"
  show_field $eod_info 12 6 "Record count at EOD"
  show_field $eod_info 18 6 "File Mark Count at EOD"
  show_field $eod_info 24 4 "EOD Data Set Number"
  show_field $eod_info 28 4 "Wrap Section Number of EOD"
  show_field $eod_info 32 2 "Validity of EOD"
  show_field $eod_info 34 2 "First CQ Set Number"
  show_field $eod_info 36 4 "Physical Position of EOD"
  show_field $eod_info 40 20 "Reserved"
  show_field $eod_info 60 4 "CRC"
}

show_status_alert () {
  echo "-- Cartridge Status and Tape Alert Flags --"
  status_alert=`calc_page_data $1 32 $2`
  show_field $status_alert 0 2 "Page Id"
  show_field $status_alert 2 2 "Page Length"
  show_field $status_alert 4 8 "Tape Alert Flags"
  show_field $status_alert 12 4 "Thread Count"
  show_field $status_alert 16 2 "Cartridge Status"
  show_field $status_alert 18 10 "Reserved"
  show_field $status_alert 28 4 "CRC"
}

show_mechanism_related () {
  echo "-- Mechanism Related --"
  mechanism_related=`calc_page_data $1 384 $2`
  show_field $mechanism_related 0 2 "Page Id"
  show_field $mechanism_related 2 2 "Page Length"
  show_field $mechanism_related 4 8 "Drive Manufacturer Identity"
  show_field $mechanism_related 12 368 "Mechanism related data"
  show_field $mechanism_related 380 4 "CRC"
}

show_sus_appd_wrt () {
  echo "-- Suspended Append Writes --"
  sus_appd_wrt=`calc_page_data $1 128 $2`
  show_field $sus_appd_wrt 0 2 "Page Id"
  show_field $sus_appd_wrt 2 2 "Page Length"
  show_field $sus_appd_wrt 4 4 "Reserved"

  for i in `seq 0 13`
  do
    show_field $sus_appd_wrt $((8*$i+8)) 8 "Suspended Append $i"
  done

  show_field $sus_appd_wrt 120 4 "Reserved"
  show_field $sus_appd_wrt 124 4 "CRC"
}

show_usage_info () {
  echo "-- Usage Information $3 --"
  usage_info=`calc_page_data $1 64 $2`
  show_field $usage_info 0 2 "Page Id"
  show_field $usage_info 2 2 "Page Length"
  show_field $usage_info 4 8 "Drive Manufacturer" "true"
  show_field $usage_info 12 10 "Drive Id" "true"
  show_field $usage_info 22 2 "Suspended Writes at Append"
  show_field $usage_info 24 4 "Thread Count"
  show_field $usage_info 28 8 "Total Data Sets Written"
  show_field $usage_info 36 8 "Total Data Sets Read"
  show_field $usage_info 44 4 "Total Write Retries"
  show_field $usage_info 48 4 "Total Read Retries"
  show_field $usage_info 52 2 "Total Unrecovered Write Errors"
  show_field $usage_info 54 2 "Total Unrecovered Read Errors"
  show_field $usage_info 56 2 "Total Number of Suspended Writes"
  show_field $usage_info 58 2 "Total Number of Fatal Suspended Writes"
  show_field $usage_info 60 4 "CRC"
}

show_app_specific () {
  echo "-- Application Specific Data --"
  app_specific=`calc_page_data $1 1056 $2`
  show_field $app_specific 0 2 "Page Id"
  show_field $app_specific 2 2 "Page Length"
  show_field $app_specific 4 1024 "Application Data"
  show_field $app_specific 1028 24 "Reserved"
  show_field $app_specific 1052 4 "CRC"
}

#-- Main

if [ "$1" = "" ]; then
  echo "Usage: $(basename "$0") [*.eml]"
  exit 2
fi

#ASCII to Hex
input=`cat "$1" | xxd -p -r`

#Search for Starting Address of Unprotected Pages
i=0
while :
do
  byte0_1=`echo $input | cut -c $((73+i*4*2))-$((80+i*4*2))`
  page_version=`echo $byte0_1 | cut -c 1`
  page_id=`echo $byte0_1 | cut -c 2-4`
  start_addr=`echo $byte0_1 | cut -c 5-8`

  case "$page_id" in
    "001" ) cart_mfg_info_addr=$start_addr;;
    "002" ) media_mfg_info_addr=$start_addr;;
    "101" ) init_data_addr=$start_addr;;
    "102" ) tape_wrt_pass_addr=$start_addr;;
    "103" ) tape_dir_addr=$start_addr;;
    "104" ) eod_info_addr=$start_addr;;
    "105" ) status_alert_addr=$start_addr;;
    "106" ) mechanism_related_addr=$start_addr;;
    "107" ) sus_appd_wrt_addr=$start_addr;;
    "108" ) usage_info0_addr=$start_addr;;
    "109" ) usage_info1_addr=$start_addr;;
    "10A" ) usage_info2_addr=$start_addr;;
    "10B" ) usage_info3_addr=$start_addr;;
    "200" ) app_specific_addr=$start_addr;;
  esac
  
  #An End Of Page Table (EOPT) Page Descriptor. Exit search loop
  if [ "$page_id" = "FFF" -a "$page_version" = "0" ]; then
    break
  fi

  i=$((i+1))

done

#Display Fields	
show_lto_cm_mfg_info $input
show_lto_cm_wrtinh $input
show_cart_mfg_info $cart_mfg_info_addr $input
show_media_mfg_info $media_mfg_info_addr $input

if [ "$init_data_addr" != "" ]; then
  show_init_data $init_data_addr $input
fi

if [ "$tape_wrt_pass_addr" != "" ]; then
  show_tape_wrt_pass $tape_wrt_pass_addr $input
fi

if [ "$tape_dir_addr" != "" ]; then
  show_tape_dir $tape_dir_addr $input
fi

if [ "$eod_info_addr" != "" ]; then
  show_eod_info $eod_info_addr $input
fi

if [ "$status_alert_addr" != "" ]; then
  show_status_alert $status_alert_addr $input
fi

if [ "$mechanism_related_addr" != "" ]; then
  show_mechanism_related $mechanism_related_addr $input
fi

if [ "$sus_appd_wrt_addr" != "" ]; then
  show_sus_appd_wrt $sus_appd_wrt_addr $input
fi

if [ "$usage_info0_addr" != "" ]; then
  show_usage_info $usage_info0_addr $input 0
fi

if [ "$usage_info1_addr" != "" ]; then
  show_usage_info $usage_info1_addr $input 1
fi 
if [ "$usage_info2_addr" != "" ]; then
  show_usage_info $usage_info2_addr $input 2
fi 

if [ "$usage_info3_addr" != "" ]; then
  show_usage_info $usage_info3_addr $input 3
fi 

if [ "$app_specific_addr" != "" ]; then
  show_app_specific $app_specific_addr $input  
fi

