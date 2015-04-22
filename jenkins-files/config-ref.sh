#! /bin/bash

name="$1"
id="$2"
arch="$3"

scripts=$(dirname $0)

sudo virsh destroy ref-$name 2> /dev/null
sudo virsh undefine ref-$name 2> /dev/null

script=$(printf "s/@@NAME@@/%s/; s/@@ID@@/%02d/; s/@@ARCH@@/%s/\n" $name $id $arch)
sed "$script" $scripts/config-ref.template > $WORKSPACE/wicked-ref.xml

sudo virsh define $WORKSPACE/wicked-ref.xml
[ $? -eq 0 ] || exit $?
sudo virsh start ref-$name
[ $? -eq 0 ] || exit $?

rm $WORKSPACE/wicked-ref.xml