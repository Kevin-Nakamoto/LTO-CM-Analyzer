#!/bin/sh

show_field () {
  fd_start_addr=$(($2*2+1))
  fd_end_addr=$(($3*2-1+$fd_start_addr))
  data=`echo $1 | cut -c $fd_start_addr-$fd_end_addr`

  if [ "$5" = "true" ]
  then
    echo "  "$4": "`echo $data | xxd -p -r`
  else 
    echo "  "$4": "$data
  fi
}    

calc_page_data () {
  pg_start_addr=`echo "ibase=16; $1" | bc`
  pg_start_addr=$(($pg_start_addr*2+1))
  pg_end_addr=$(($2*2-1+$pg_start_addr))
  echo $3 | cut -c $pg_start_addr-$pg_end_addr
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
  show_field $1 0 1 "Last Write-Inhibited Block Number"
  show_field $1 1 1 "Block 1 Protection Flag"
  show_field $1 2 2 "Reserved"
}

show_cart_mfg_info () {
  echo "-- Cartridge Manufacturer's Information --"
  show_field $1 0 2 "Page Id"
  show_field $1 2 2 "Page Length"
  show_field $1 4 8 "Cartridge Manufacturer" "true"
  show_field $1 12 10 "Serial Number" "true"
  show_field $1 22 2 "Cartridge Type"
  show_field $1 24 8 "Date of Manufacture" "true"
  show_field $1 32 2 "Tape Length"
  show_field $1 34 2 "Tape Thickness"
  show_field $1 36 2 "Empty Reel Inertia"
  show_field $1 38 2 "Hub Radius"
  show_field $1 40 2 "Full Reel Pack Radius"
  show_field $1 42 2 "Maximum Media Speed"
  show_field $1 44 4 "License Code"
  show_field $1 48 12 "Cartridge Manufacturer's Use"
  show_field $1 60 4 "CRC"
}

show_media_mfg_info () {
  echo "-- Media Manufacturer's Information --"
  show_field $1 0 2 "Page Id"
  show_field $1 2 2 "Page Length"
  show_field $1 4 48 "Servowriter Manufacturer" "true"
  show_field $1 52 8 "Reserved"
  show_field $1 60 4 "CRC"
}

show_init_data () {
  echo "-- Initialisation Data --"
  show_field $1 0 2 "Page Id"
  show_field $1 2 2 "Page Length"
  show_field $1 4 8 "Initialising Drive Manufacturer" "true"
  show_field $1 12 10 "Drive Id" "true"
  show_field $1 22 2 "Format Type"
  show_field $1 24 4 "LP1 Position"
  show_field $1 28 4 "LP2 Position"
  show_field $1 32 4 "LP3 Position"
  show_field $1 36 4 "LP4 Position"
  show_field $1 40 4 "LP5 Position"
  show_field $1 44 4 "LP6 Position"
  show_field $1 48 12 "Reserved"
  show_field $1 60 4 "CRC"
}

show_tape_wrt_pass () {
  echo "-- Tape Write Pass --"
  show_field $1 0 2 "Page Id"
  show_field $1 2 2 "Page Length"
  show_field $1 4 12 "Reserved"
  show_field $1 16 4 "Write Pass Field 0"
  show_field $1 20 4 "Write Pass Field 1"
  show_field $1 24 4 "Write Pass Field 2"
  show_field $1 28 4 "Write Pass Field 3"
  show_field $1 32 4 "Write Pass Field 4"
  show_field $1 36 4 "Write Pass Field 5"
  show_field $1 40 4 "Write Pass Field 6"
  show_field $1 44 4 "Write Pass Field 7"
}

show_tape_dir () {
  echo "-- Tape Directory --"
  show_field $1 0 2 "Page Id"
  show_field $1 2 2 "Page Length"
  show_field $1 4 4 "FID Tape Write Pass"
  show_field $1 8 8 "Reserved"
  for i in `seq 0 95`
  do
    show_field $1 $((16+$i*16)) 16 "Wrap Section $i"
  done
}

show_eod_info () {
  echo "-- EOD Information --"
  show_field $1 0 2 "Page Id"
  show_field $1 2 2 "Page Length"
  show_field $1 4 4 "Tape Write Pass for last written EOD"
  show_field $1 8 4 "Thread Count"
  show_field $1 12 6 "Record count at EOD"
  show_field $1 18 6 "File Mark Count at EOD"
  show_field $1 24 4 "EOD Data Set Number"
  show_field $1 28 4 "Wrap Section Number of EOD"
  show_field $1 32 2 "Validity of EOD"
  show_field $1 34 2 "First CQ Set Number"
  show_field $1 36 4 "Physical Position of EOD"
  show_field $1 40 20 "Reserved"
  show_field $1 60 4 "CRC"
}

show_status_alert () {
  echo "-- Cartridge Status and Tape Alert Flags --"
  show_field $1 0 2 "Page Id"
  show_field $1 2 2 "Page Length"
  show_field $1 4 8 "Tape Alert Flags"
  show_field $1 12 4 "Thread Count"
  show_field $1 16 2 "Cartridge Status"
  show_field $1 18 10 "Reserved"
  show_field $1 28 4 "CRC"
}

show_mechanism_related () {
  echo "-- Mechanism Related --"
  show_field $1 0 2 "Page Id"
  show_field $1 2 2 "Page Length"
  show_field $1 4 8 "Drive Manufacturer Identity"
  show_field $1 12 368 "Mechanism related data"
  show_field $1 380 4 "CRC"
}

show_sus_appd_wrt () {
  echo "-- Suspended Append Writes --"
  show_field $1 0 2 "Page Id"
  show_field $1 2 2 "Page Length"
  show_field $1 4 4 "Reserved"

  for i in `seq 0 13`
  do
    show_field $1 $((8*$i+8)) 8 "Suspended Append $i"
  done

  show_field $1 120 4 "Reserved"
  show_field $1 124 4 "CRC"
}

show_usage_info () {
  echo "-- Usage Information $2 --"
  show_field $1 0 2 "Page Id"
  show_field $1 2 2 "Page Length"
  show_field $1 4 8 "Drive Manufacturer" "true"
  show_field $1 12 10 "Drive Id" "true"
  show_field $1 22 2 "Suspended Writes at Append"
  show_field $1 24 4 "Thread Count"
  show_field $1 28 8 "Total Data Sets Written"
  show_field $1 36 8 "Total Data Sets Read"
  show_field $1 44 4 "Total Write Retries"
  show_field $1 48 4 "Total Read Retries"
  show_field $1 52 2 "Total Unrecovered Write Errors"
  show_field $1 54 2 "Total Unrecovered Read Errors"
  show_field $1 56 2 "Total Number of Suspended Writes"
  show_field $1 58 2 "Total Number of Fatal Suspended Writes"
  show_field $1 60 4 "CRC"
}

show_app_specific () {
  echo "-- Application Specific Data --"
  show_field $1 0 2 "Page Id"
  show_field $1 2 2 "Page Length"
  show_field $1 4 1024 "Application Data"
  show_field $1 1028 24 "Reserved"
  show_field $1 1052 4 "CRC"
}

#-- Main

if [ "$1" = "" ]; then
  echo "Usage: $(basename "$0") [*.eml]"
  exit 2
fi

if [ ! -e "$1" ]; then
  echo "File Not Found"
  exit 2
fi

#ASCII to Hex
input=`cat "$1" | xxd -p -r`

#Search for Starting Address of Each Page
page_table=`calc_page_data 24 $((${#input}/2-36)) $input`
i=0
while :
do
  page_descriptor=`echo $page_table | cut -c $((1+i*8))-$((8+i*8))`
  page_version=`echo $page_descriptor | cut -c 1`
  page_id=`echo $page_descriptor | cut -c 2-4`
  start_addr=`echo $page_descriptor | cut -c 5-8`

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

lto_cm_mfg_info=`calc_page_data 0 32 $input`
show_lto_cm_mfg_info $lto_cm_mfg_info

lto_cm_wrtinh=`calc_page_data 20 4 $input`
show_lto_cm_wrtinh $lto_cm_wrtinh

cart_mfg_info=`calc_page_data $cart_mfg_info_addr 64 $input`
show_cart_mfg_info $cart_mfg_info

media_mfg_info=`calc_page_data $media_mfg_info_addr 64 $input`
show_media_mfg_info $media_mfg_info

if [ "$init_data_addr" != "" ]; then
  init_data=`calc_page_data $init_data_addr 64 $input`
  show_init_data $init_data
fi

if [ "$tape_wrt_pass_addr" != "" ]; then
  tape_wrt_pass=`calc_page_data $tape_wrt_pass_addr 48 $input`
  show_tape_wrt_pass $tape_wrt_pass
fi

if [ "$tape_dir_addr" != "" ]; then
  tape_dir=`calc_page_data $tape_dir_addr 1552 $input`
  show_tape_dir $tape_dir
fi

if [ "$eod_info_addr" != "" ]; then
  eod_info=`calc_page_data $eod_info_addr 64 $input`
  show_eod_info $eod_info
fi

if [ "$status_alert_addr" != "" ]; then
  status_alert=`calc_page_data $status_alert_addr 32 $input`
  show_status_alert $status_alert
fi

if [ "$mechanism_related_addr" != "" ]; then
  mechanism_related=`calc_page_data $mechanism_related_addr 384 $input`
  show_mechanism_related $mechanism_related
fi

if [ "$sus_appd_wrt_addr" != "" ]; then
  sus_appd_wrt=`calc_page_data $sus_appd_wrt_addr 128 $input`
  show_sus_appd_wrt $sus_appd_wrt
fi

if [ "$usage_info0_addr" != "" ]; then
  usage_info=`calc_page_data $usage_info0_addr 64 $input`
  show_usage_info $usage_info0 0
fi

if [ "$usage_info1_addr" != "" ]; then
  usage_info=`calc_page_data $usage_info1_addr 64 $input`
  show_usage_info $usage_info 1
fi 

if [ "$usage_info2_addr" != "" ]; then
  usage_info=`calc_page_data $usage_info2_addr 64 $input`
  show_usage_info $usage_info 2
fi 

if [ "$usage_info3_addr" != "" ]; then
  usage_info=`calc_page_data $usage_info3_addr 64 $input`
  show_usage_info $usage_info 3
fi 

if [ "$app_specific_addr" != "" ]; then
  app_specific=`calc_page_data $app_specific_addr 1056 $input`
  show_app_specific $app_specific
fi

