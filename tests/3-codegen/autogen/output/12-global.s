# Global variables
	.text
	.section .bss, "aw", @nobits
	.globl seed
	.type seed, @object
	.size seed, 4
seed:
	.space 4
	.text
	.globl randomLCG
	.type randomLCG, @function
randomLCG:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -32
.randomLCG_label_entry:
# %op0 = load i32, i32* @seed
	la.local $t0, seed
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -20
# %op1 = mul i32 %op0, 1103515245
	ld.w $t0, $fp, -20
	lu12i.w $t1, 269412
	ori $t1, $t1, 3693
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -24
# %op2 = add i32 %op1, 12345
	ld.w $t0, $fp, -24
	lu12i.w $t1, 3
	ori $t1, $t1, 57
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -28
# store i32 %op2, i32* @seed
	la.local $t0, seed
	ld.w $t1, $fp, -28
	st.w $t1, $t0, 0
# %op3 = load i32, i32* @seed
	la.local $t0, seed
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -32
# ret i32 %op3
	ld.w $a0, $fp, -32
	b randomLCG_exit
randomLCG_exit:
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl randBin
	.type randBin, @function
randBin:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -32
.randBin_label_entry:
# %op0 = call i32 @randomLCG()
	bl randomLCG
	st.w $a0, $fp, -20
# %op1 = icmp sgt i32 %op0, 0
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -21
# %op2 = zext i1 %op1 to i32
	ld.b $t0, $fp, -21
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -28
# %op3 = icmp ne i32 %op2, 0
	ld.w $t0, $fp, -28
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	slt $t3, $t0, $t1
	or $t0, $t2, $t3
	st.b $t0, $fp, -29
# br i1 %op3, label %label_00000000, label %label_00000001
	ld.b $t0, $fp, -29
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .randBin_label_00000000
	b .randBin_label_00000001
.randBin_label_00000000:
# ret i32 1
	addi.w $a0, $zero, 1
	b randBin_exit
.randBin_label_00000001:
# ret i32 0
	addi.w $a0, $zero, 0
	b randBin_exit
.randBin_label_00000002:
# ret i32 0
	addi.w $a0, $zero, 0
	b randBin_exit
randBin_exit:
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl returnToZeroSteps
	.type returnToZeroSteps, @function
returnToZeroSteps:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -112
.returnToZeroSteps_label_entry:
# %op0 = alloca i32
	addi.d $t1, $fp, -28
	st.d $t1, $fp, -24
# %op1 = alloca i32
	addi.d $t1, $fp, -44
	st.d $t1, $fp, -40
# store i32 0, i32* %op0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# store i32 0, i32* %op1
	ld.d $t0, $fp, -40
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# br label %label_00000003
	b .returnToZeroSteps_label_00000003
.returnToZeroSteps_label_00000003:
# %op2 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -48
# %op3 = icmp slt i32 %op2, 20
	ld.w $t0, $fp, -48
	addi.w $t1, $zero, 20
	slt $t0, $t0, $t1
	st.b $t0, $fp, -49
# %op4 = zext i1 %op3 to i32
	ld.b $t0, $fp, -49
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -56
# %op5 = icmp ne i32 %op4, 0
	ld.w $t0, $fp, -56
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	slt $t3, $t0, $t1
	or $t0, $t2, $t3
	st.b $t0, $fp, -57
# br i1 %op5, label %label_00000004, label %label_00000005
	ld.b $t0, $fp, -57
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .returnToZeroSteps_label_00000004
	b .returnToZeroSteps_label_00000005
.returnToZeroSteps_label_00000004:
# %op6 = call i32 @randBin()
	bl randBin
	st.w $a0, $fp, -64
# %op7 = icmp ne i32 %op6, 0
	ld.w $t0, $fp, -64
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	slt $t3, $t0, $t1
	or $t0, $t2, $t3
	st.b $t0, $fp, -65
# br i1 %op7, label %label_00000006, label %label_00000007
	ld.b $t0, $fp, -65
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .returnToZeroSteps_label_00000006
	b .returnToZeroSteps_label_00000007
.returnToZeroSteps_label_00000005:
# ret i32 20
	addi.w $a0, $zero, 20
	b returnToZeroSteps_exit
.returnToZeroSteps_label_00000006:
# %op8 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -72
# %op9 = add i32 %op8, 1
	ld.w $t0, $fp, -72
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -76
# store i32 %op9, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $fp, -76
	st.w $t1, $t0, 0
# br label %label_00000008
	b .returnToZeroSteps_label_00000008
.returnToZeroSteps_label_00000007:
# %op10 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -80
# %op11 = sub i32 %op10, 1
	ld.w $t0, $fp, -80
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -84
# store i32 %op11, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $fp, -84
	st.w $t1, $t0, 0
# br label %label_00000008
	b .returnToZeroSteps_label_00000008
.returnToZeroSteps_label_00000008:
# %op12 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -88
# %op13 = add i32 %op12, 1
	ld.w $t0, $fp, -88
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -92
# store i32 %op13, i32* %op1
	ld.d $t0, $fp, -40
	ld.w $t1, $fp, -92
	st.w $t1, $t0, 0
# %op14 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -96
# %op15 = icmp eq i32 %op14, 0
	ld.w $t0, $fp, -96
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	slt $t3, $t0, $t1
	nor $t0, $t2, $t3
	st.b $t0, $fp, -97
# %op16 = zext i1 %op15 to i32
	ld.b $t0, $fp, -97
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -104
# %op17 = icmp ne i32 %op16, 0
	ld.w $t0, $fp, -104
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	slt $t3, $t0, $t1
	or $t0, $t2, $t3
	st.b $t0, $fp, -105
# br i1 %op17, label %label_00000009, label %label_0000000a
	ld.b $t0, $fp, -105
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .returnToZeroSteps_label_00000009
	b .returnToZeroSteps_label_0000000a
.returnToZeroSteps_label_00000009:
# %op18 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -112
# ret i32 %op18
	ld.w $a0, $fp, -112
	b returnToZeroSteps_exit
.returnToZeroSteps_label_0000000a:
# br label %label_0000000b
	b .returnToZeroSteps_label_0000000b
.returnToZeroSteps_label_0000000b:
# br label %label_00000003
	b .returnToZeroSteps_label_00000003
returnToZeroSteps_exit:
	addi.d $sp, $sp, 112
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -64
.main_label_entry:
# %op0 = alloca i32
	addi.d $t1, $fp, -28
	st.d $t1, $fp, -24
# store i32 0, i32* %op0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# store i32 3407, i32* @seed
	la.local $t0, seed
	lu12i.w $t1, 0
	ori $t1, $t1, 3407
	st.w $t1, $t0, 0
# br label %label_0000000c
	b .main_label_0000000c
.main_label_0000000c:
# %op1 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -32
# %op2 = icmp slt i32 %op1, 20
	ld.w $t0, $fp, -32
	addi.w $t1, $zero, 20
	slt $t0, $t0, $t1
	st.b $t0, $fp, -33
# %op3 = zext i1 %op2 to i32
	ld.b $t0, $fp, -33
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -40
# %op4 = icmp ne i32 %op3, 0
	ld.w $t0, $fp, -40
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	slt $t3, $t0, $t1
	or $t0, $t2, $t3
	st.b $t0, $fp, -41
# br i1 %op4, label %label_0000000d, label %label_0000000e
	ld.b $t0, $fp, -41
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_0000000d
	b .main_label_0000000e
.main_label_0000000d:
# %op5 = call i32 @returnToZeroSteps()
	bl returnToZeroSteps
	st.w $a0, $fp, -48
# call void @output(i32 %op5)
	ld.w $a0, $fp, -48
	bl output
# %op6 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -52
# %op7 = add i32 %op6, 1
	ld.w $t0, $fp, -52
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -56
# store i32 %op7, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $fp, -56
	st.w $t1, $t0, 0
# br label %label_0000000c
	b .main_label_0000000c
.main_label_0000000e:
# ret i32 0
	addi.w $a0, $zero, 0
	b main_exit
main_exit:
	addi.d $sp, $sp, 64
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
