	.text
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -80
.main_label_entry:
# %op0 = alloca i32
	addi.d $t1, $fp, -28
	st.d $t1, $fp, -24
# %op1 = alloca i32
	addi.d $t1, $fp, -44
	st.d $t1, $fp, -40
# store i32 10, i32* %op0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 10
	st.w $t1, $t0, 0
# store i32 0, i32* %op1
	ld.d $t0, $fp, -40
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# br label %label_00000000
	b .main_label_00000000
.main_label_00000000:
# %op2 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -48
# %op3 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -52
# %op4 = icmp slt i32 %op2, %op3
	ld.w $t0, $fp, -48
	ld.w $t1, $fp, -52
	slt $t0, $t0, $t1
	st.b $t0, $fp, -53
# %op5 = zext i1 %op4 to i32
	ld.b $t0, $fp, -53
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -60
# %op6 = icmp ne i32 %op5, 0
	ld.w $t0, $fp, -60
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	slt $t3, $t0, $t1
	or $t0, $t2, $t3
	st.b $t0, $fp, -61
# br i1 %op6, label %label_00000001, label %label_00000002
	ld.b $t0, $fp, -61
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_00000001
	b .main_label_00000002
.main_label_00000001:
# %op7 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -68
# call void @output(i32 %op7)
	ld.w $a0, $fp, -68
	bl output
# %op8 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -72
# %op9 = add i32 %op8, 1
	ld.w $t0, $fp, -72
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -76
# store i32 %op9, i32* %op1
	ld.d $t0, $fp, -40
	ld.w $t1, $fp, -76
	st.w $t1, $t0, 0
# br label %label_00000000
	b .main_label_00000000
.main_label_00000002:
# ret i32 0
	addi.w $a0, $zero, 0
	b main_exit
main_exit:
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
