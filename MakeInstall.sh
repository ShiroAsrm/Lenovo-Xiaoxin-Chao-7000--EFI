#!/bin/sh
makedir="/Users/$USER/Desktop/EFI"
backupdir="/Users/$USER/Desktop/EFIBAK"
origindir="$( dirname "${BASH_SOURCE[0]}" )"
efidir="/Volumes/efi"

#起始块
function start()
{
clear
cat << EOF
　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
　潮潮潮潮潮潮潮潮潮　　　潮潮潮潮　　　　　　潮潮潮潮　　　　　　潮潮潮潮
　潮潮　　　　潮潮　　　潮潮潮潮潮潮　　　　潮潮潮潮潮潮　　　　潮潮潮潮潮潮
　潮潮　　　潮潮　　　潮潮潮　　潮潮潮　　潮潮潮　　潮潮潮　　潮潮潮　　潮潮潮
　　　　　　潮潮　　　潮潮潮　　潮潮潮　　潮潮潮　　潮潮潮　　潮潮潮　　潮潮潮
　　　　　潮潮　　　潮潮潮　　　　潮潮潮潮潮潮　　　　潮潮潮潮潮潮　　　　潮潮潮
　　　　　潮潮　　　潮潮潮　　　　潮潮潮潮潮潮　　　　潮潮潮潮潮潮　　　　潮潮潮
　　　　潮潮潮　　　潮潮潮　　　　潮潮潮潮潮潮　　　　潮潮潮潮潮潮　　　　潮潮潮
　　　　潮潮　　　　潮潮潮　　　　潮潮潮潮潮潮　　　　潮潮潮潮潮潮　　　　潮潮潮
　　　潮潮潮　　　　潮潮潮　　　　潮潮潮潮潮潮　　　　潮潮潮潮潮潮　　　　潮潮潮
　　　潮潮潮　　　　　潮潮潮　　潮潮潮　　潮潮潮　　潮潮潮　　潮潮潮　　潮潮潮
　　　潮潮潮　　　　　潮潮潮　　潮潮潮　　潮潮潮　　潮潮潮　　潮潮潮　　潮潮潮
　　　潮潮潮　　　　　　潮潮潮潮潮潮　　　　潮潮潮潮潮潮　　　　潮潮潮潮潮潮
　　　潮潮潮　　　　　　　潮潮潮潮　　　　　　潮潮潮潮　　　　　　潮潮潮潮




EOF
echo "联想潮7000 EFI自动生成脚本 by 澎湖冰洲"
choose
}

#第一选择块
function choose()
{

cat << EOF

请选择要执行的操作：
(1) 生成EFI文件
(2) 自动安装
(3) 退出

EOF

read -p "输入你的选择[1~3]: " input
case $input in
1) generate
;;
2) instinit
;;
3) end
;;
*)
echo "输入有误，请重新输入"
choose
esac
}



#生成EFI模块
function generate()
{

clear
cat << EOF
请选择您的触摸板型号：
(1) SYNA2B2C
(2) SYNA2393
(3) 返回
EOF

read -p "输入你的选择[1~3]: " input
case $input in
1) SYNA2B2C
;;
2) SYNA2393
;;
3) start
;;
*)
echo "输入有误，请重新输入"
generate
esac
}

#目录冲突检测块
function dirdetect()
{
if [[ -d $makedir ]];then
echo "目标目录已经存在，发生冲突，正在备份冲突目录为EFIBAK……"
sudo mv -f $makedir $backupdir
echo "备份生成目录成功"
fi
}

#2B2C触摸板生成模块
function SYNA2B2C()
{
dirdetect

echo "正在生成SYNA2B2C的EFI……"
cp -r $origindir/Basic $makedir
cp -r $origindir/config/SYNA2B2C.plist $makedir/CLOVER/config.plist
cp -r  $origindir/ACPI/SYNA2B2C $makedir/ClOVER/ACPI
read -p "生成成功，按任意键返回上层！"
start
}

#2393触摸板生成模块
function SYNA2393()
{
dirdetect

echo "正在生成SYNA2393的EFI……"
sudo rm -Rf $makedir
cp -R $origindir/basic $makedir
cp $origindir/config/SYNA2394.plist $makedir/CLOVER/config.plist
cp -R  $origindir/ACPI/SYNA2394 $makedir/CLOVER/ACPI
read -p "生成成功，按任意键返回上层！"
start
}




#安装初始化块
function instinit()
{
clear
cat << EOF
自动安装要求：
1、UEFI模式
2、安装了Clover Configurator
3、设置的四叶草引导路径为/EFI/CLOVER/CLOVERX64.efi
EOF

read -p "如您确认以上三点无误，请输入y回车，否则按任意键返回！！！！" input
if [[ $input == y ]];then
install
else
start
fi
}

#安装块
function install()
{
echo "正在挂载EFI……"
efidir=`$origindir/mount_efi.sh`
echo "正在备份原有EFI，原EFI将被备份到桌面下的EFIREC下"
cp -r $efidir /Users/$USER/Desktop/EFIREC
echo "备份完成，正在准备安装新EFI……"
rm -rf $efidir/EFI
cp -rf $makedir $efidir
rm -rf $makedir
if [[ -d $efidir ]];then
say 从现在起开启全新的潮7000之旅
read -p "自动安装成功，重启生效！按任意键返回。"
start
else
read -p "自动安装失败，按任意键返回。"
start
fi
}

#结束块
function end()
{
echo "正在退出,欢迎下次使用!"
exit 0
}



start
