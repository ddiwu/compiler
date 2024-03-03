	.text
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -176
.main_label_entry:
# %op0 = alloca [10 x i32]
	addi.d $t1, $fp, -64
	st.d $t1, $fp, -24
# %op1 = alloca i32
	addi.d $t1, $fp, -76
	st.d $t1, $fp, -72
# store i32 0, i32* %op1
	ld.d $t0, $fp, -72
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# %op2 = icmp sge i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -77
# br i1 %op2, label %label_00000000, label %label_00000001
	ld.b $t0, $fp, -77
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_00000000
	b .main_label_00000001
.main_label_00000000:
# %op3 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 0
	lu12i.w $t3, 0
	ori $t3, $t3, 40
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	mul.w $t1, $t1, $t3
	bstrpick.d $t1, $t1, 31, 0
	add.d $t0, $t0, $t1
	mul.w $t2, $t2, $t4
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -88
# br label %label_00000002
	b .main_label_00000002
.main_label_00000001:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_00000002
	b .main_label_00000002
.main_label_00000002:
# store i32 11, i32* %op3
	ld.d $t0, $fp, -88
	addi.w $t1, $zero, 11
	st.w $t1, $t0, 0
# %op4 = icmp sge i32 4, 0
	addi.w $t0, $zero, 4
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -89
# br i1 %op4, label %label_00000003, label %label_00000004
	ld.b $t0, $fp, -89
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_00000003
	b .main_label_00000004
.main_label_00000003:
# %op5 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 4
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 40
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	mul.w $t1, $t1, $t3
	bstrpick.d $t1, $t1, 31, 0
	add.d $t0, $t0, $t1
	mul.w $t2, $t2, $t4
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -104
# br label %label_00000005
	b .main_label_00000005
.main_label_00000004:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_00000005
	b .main_label_00000005
.main_label_00000005:
# store i32 22, i32* %op5
	ld.d $t0, $fp, -104
	addi.w $t1, $zero, 22
	st.w $t1, $t0, 0
# %op6 = icmp sge i32 9, 0
	addi.w $t0, $zero, 9
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -105
# br i1 %op6, label %label_00000006, label %label_00000007
	ld.b $t0, $fp, -105
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_00000006
	b .main_label_00000007
.main_label_00000006:
# %op7 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 9
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 9
	lu12i.w $t3, 0
	ori $t3, $t3, 40
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	mul.w $t1, $t1, $t3
	bstrpick.d $t1, $t1, 31, 0
	add.d $t0, $t0, $t1
	mul.w $t2, $t2, $t4
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -120
# br label %label_00000008
	b .main_label_00000008
.main_label_00000007:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_00000008
	b .main_label_00000008
.main_label_00000008:
# store i32 33, i32* %op7
	ld.d $t0, $fp, -120
	addi.w $t1, $zero, 33
	st.w $t1, $t0, 0
# %op8 = icmp sge i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -121
# br i1 %op8, label %label_00000009, label %label_0000000a
	ld.b $t0, $fp, -121
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_00000009
	b .main_label_0000000a
.main_label_00000009:
# %op9 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 0
	lu12i.w $t3, 0
	ori $t3, $t3, 40
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	mul.w $t1, $t1, $t3
	bstrpick.d $t1, $t1, 31, 0
	add.d $t0, $t0, $t1
	mul.w $t2, $t2, $t4
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -136
# %op10 = load i32, i32* %op9
	ld.d $t0, $fp, -136
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -140
# br label %label_0000000b
	b .main_label_0000000b
.main_label_0000000a:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_0000000b
	b .main_label_0000000b
.main_label_0000000b:
# call void @output(i32 %op10)
	ld.w $a0, $fp, -140
	bl output
# %op11 = icmp sge i32 4, 0
	addi.w $t0, $zero, 4
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -141
# br i1 %op11, label %label_0000000c, label %label_0000000d
	ld.b $t0, $fp, -141
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_0000000c
	b .main_label_0000000d
.main_label_0000000c:
# %op12 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 4
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 40
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	mul.w $t1, $t1, $t3
	bstrpick.d $t1, $t1, 31, 0
	add.d $t0, $t0, $t1
	mul.w $t2, $t2, $t4
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -152
# %op13 = load i32, i32* %op12
	ld.d $t0, $fp, -152
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -156
# br label %label_0000000e
	b .main_label_0000000e
.main_label_0000000d:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_0000000e
	b .main_label_0000000e
.main_label_0000000e:
# call void @output(i32 %op13)
	ld.w $a0, $fp, -156
	bl output
# %op14 = icmp sge i32 9, 0
	addi.w $t0, $zero, 9
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -157
# br i1 %op14, label %label_0000000f, label %label_00000010
	ld.b $t0, $fp, -157
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_0000000f
	b .main_label_00000010
.main_label_0000000f:
# %op15 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 9
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 9
	lu12i.w $t3, 0
	ori $t3, $t3, 40
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	mul.w $t1, $t1, $t3
	bstrpick.d $t1, $t1, 31, 0
	add.d $t0, $t0, $t1
	mul.w $t2, $t2, $t4
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -168
# %op16 = load i32, i32* %op15
	ld.d $t0, $fp, -168
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -172
# br label %label_00000011
	b .main_label_00000011
.main_label_00000010:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_00000011
	b .main_label_00000011
.main_label_00000011:
# call void @output(i32 %op16)
	ld.w $a0, $fp, -172
	bl output
# ret i32 0
	addi.w $a0, $zero, 0
	b main_exit
main_exit:
	addi.d $sp, $sp, 176
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
