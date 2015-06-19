#!/bin/bash 

#create case
sampling_file="sampling_data"
paras="CD_COASTAL:CD_INDIAN:CD_PACIFIC:CD_ATLANTIC"
licom_base="/share1/zhangtao/LICOM_tide150430/"
case_templ="$licom_base/Exp_notracer/exe/"
diag_templ="$licom_base/tide_diag/"
wrk_dir="`pwd`"

mkdir -p $licom_base/Exp_notracer_$2
cp -rp $case_templ  $licom_base/Exp_notracer_$2/exe
cp -rp $diag_templ  $licom_base/Exp_notracer_$2/tide_diag
echo `date`: "creating case [EXP_notracer_$2] successfully"

#run
cd  $licom_base/Exp_notracer_$2/exe
paras_num=`echo $paras | awk -F ':' '{print NF}'`
for i in `seq 1 $paras_num`
do
	para=`echo $paras |cut -d : -f $i`
	var_line=`sed -n "$2p" $wrk_dir/$sampling_file`
    para_val="$para=`echo $var_line |cut -d ' ' -f $i`"
    #echo $para_val
    sed -i "/\<$para\>/c \\  $para_val" ocn.parm
done
echo `date`: "configure case [EXP_notracer_$2] successfully"
./run $3 $4 > output
#sleep 10
mv output  ocn.parm  ub_000106.dat vb_000106.dat z0_000106.dat $licom_base/Exp_notracer_$2/tide_diag/

#diag
cd $licom_base/Exp_notracer_$2/tide_diag
./diag_metrics
rm ub_000106.dat vb_000106.dat z0_000106.dat
rm -rf $licom_base/Exp_notracer_$2/exe
