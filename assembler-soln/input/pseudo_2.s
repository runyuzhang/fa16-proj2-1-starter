lwb $t0 99($t1)
lwb $t0 -99($t1)
lwb $t0 0xB0BACAFE($t1)
swb $t0 99($t1)
swb $t0 0xB0BACAFE($t1)

sos $t0 $a1 $0
rsf $t0 $a1 $0

sos $0 $0 $0
sos $0 $0 $0
