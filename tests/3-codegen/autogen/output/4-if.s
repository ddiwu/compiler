	.text
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -144
.main_label_entry:
# %op0 = alloca i32
	addi.d $t1, $fp, -28
	st.d $t1, $fp, -24
# %op1 = alloca i32
	addi.d $t1, $fp, -44
	st.d $t1, $fp, -40
# %op2 = alloca i32
	addi.d $t1, $fp, -60
	st.d $t1, $fp, -56
# store i32 11, i32* %op0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 11
	st.w $t1, $t0, 0
# store i32 22, i32* %op1
	ld.d $t0, $fp, -40
	addi.w $t1, $zero, 22
	st.w $t1, $t0, 0
# store i32 33, i32* %op2
	ld.d $t0, $fp, -56
	addi.w $t1, $zero, 33
	st.w $t1, $t0, 0
# %op3 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -64
# %op4 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -68
# %op5 = icmp sgt i32 %op3, %op4
	ld.w $t0, $fp, -64
	ld.w $t1, $fp, -68
	slt $t0, $t1, $t0
	st.b $t0, $fp, -69
# %op6 = zext i1 %op5 to i32
	ld.b $t0, $fp, -69
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -76
# %op7 = icmp ne i32 %op6, 0
	ld.w $t0, $fp, -76
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	slt $t3, $t0, $t1
	or $t0, $t2, $t3
	st.b $t0, $fp, -77
# br i1 %op7, label %label_00000000, label %label_00000001
	ld.b $t0, $fp, -77
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_00000000
	b .main_label_00000001
.main_label_00000000:
# %op8 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -84
# %op9 = load i32, i32* %op2
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -88
# %op10 = icmp sgt i32 %op8, %op9
	ld.w $t0, $fp, -84
	ld.w $t1, $fp, -88
	slt $t0, $t1, $t0
	st.b $t0, $fp, -89
# %op11 = zext i1 %op10 to i32
	ld.b $t0, $fp, -89
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -96
# %op12 = icmp ne i32 %op11, 0
	ld.w $t0, $fp, -96
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	slt $t3, $t0, $t1
	or $t0, $t2, $t3
	st.b $t0, $fp, -97
# br i1 %op12, label %label_00000003, label %label_00000004
	ld.b $t0, $fp, -97
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_00000003
	b .main_label_00000004
.main_label_00000001:
# %op13 = load i32, i32* %op2
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -104
# %op14 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -108
# %op15 = icmp slt i32 %op13, %op14
	ld.w $t0, $fp, -104
	ld.w $t1, $fp, -108
	slt $t0, $t0, $t1
	st.b $t0, $fp, -109
# %op16 = zext i1 %op15 to i32
	ld.b $t0, $fp, -109
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -116
# %op17 = icmp ne i32 %op16, 0
	ld.w $t0, $fp, -116
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	slt $t3, $t0, $t1
	or $t0, $t2, $t3
	st.b $t0, $fp, -117
# br i1 %op17, label %label_00000006, label %label_00000007
	ld.b $t0, $fp, -117
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_00000006
	b .main_label_00000007
.main_label_00000002:
# ret i32 0
	addi.w $a0, $zero, 0
	b main_exit
.main_label_00000003:
# %op18 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -124
# call void @output(i32 %op18)
	ld.w $a0, $fp, -124
	bl output
# br label %label_00000005
	b .main_label_00000005
.main_label_00000004:
# %op19 = load i32, i32* %op2
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -128
# call void @output(i32 %op19)
	ld.w $a0, $fp, -128
	bl output
# br label %label_00000005
	b .main_label_00000005
.main_label_00000005:
# br label %label_00000002
	b .main_label_00000002
.main_label_00000006:
# %op20 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -132
# call void @output(i32 %op20)
	ld.w $a0, $fp, -132
	bl output
# br label %label_00000008
	b .main_label_00000008
.main_label_00000007:
# %op21 = load i32, i32* %op2
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -136
# call void @output(i32 %op21)
	ld.w $a0, $fp, -136
	bl output
# br label %label_00000008
	b .main_label_00000008
.main_label_00000008:
# br label %label_00000002
	b .main_label_00000002
main_exit:
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
