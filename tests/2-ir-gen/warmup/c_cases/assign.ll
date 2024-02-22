; ModuleID = 'assign.c'
source_filename = "assign.c"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [10 x i32], align 4
  store i32 0, ptr %1, align 4
  %3 = getelementptr inbounds [10 x i32], ptr %2, i64 0, i64 0
  store i32 10, ptr %3, align 4
  %4 = getelementptr inbounds [10 x i32], ptr %2, i64 0, i64 0
  %5 = load i32, ptr %4, align 4
  %6 = mul nsw i32 %5, 2
  %7 = getelementptr inbounds [10 x i32], ptr %2, i64 0, i64 1
  store i32 %6, ptr %7, align 4
  %8 = getelementptr inbounds [10 x i32], ptr %2, i64 0, i64 1
  %9 = load i32, ptr %8, align 4
  ret i32 %9
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Ubuntu clang version 16.0.6 (15)"}
