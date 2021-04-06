; ModuleID = 'PolyWiz'
source_filename = "PolyWiz"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt.1 = private unnamed_addr constant [4 x i8] c"%g\0A\00"
@fmt.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@fmt.3 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt.4 = private unnamed_addr constant [4 x i8] c"%g\0A\00"
@fmt.5 = private unnamed_addr constant [4 x i8] c"%s\0A\00"

declare i32 @printf(i8*, ...)

declare i32 @printbig(i32)

define i32 @main() {
entry:
  %fib_result = call i32 @fib(i32 0)
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %fib_result)
  %fib_result1 = call i32 @fib(i32 1)
  %printf2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %fib_result1)
  %fib_result3 = call i32 @fib(i32 2)
  %printf4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %fib_result3)
  %fib_result5 = call i32 @fib(i32 3)
  %printf6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %fib_result5)
  %fib_result7 = call i32 @fib(i32 4)
  %printf8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %fib_result7)
  %fib_result9 = call i32 @fib(i32 5)
  %printf10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %fib_result9)
  ret i32 0
}

define i32 @fib(i32 %x) {
entry:
  %x1 = alloca i32
  store i32 %x, i32* %x1
  %x2 = load i32, i32* %x1
  %tmp = icmp slt i32 %x2, 2
  br i1 %tmp, label %then, label %else

merge:                                            ; preds = %else
  %x3 = load i32, i32* %x1
  %tmp4 = sub i32 %x3, 1
  %fib_result = call i32 @fib(i32 %tmp4)
  %x5 = load i32, i32* %x1
  %tmp6 = sub i32 %x5, 2
  %fib_result7 = call i32 @fib(i32 %tmp6)
  %tmp8 = add i32 %fib_result, %fib_result7
  ret i32 %tmp8

then:                                             ; preds = %entry
  ret i32 1

else:                                             ; preds = %entry
  br label %merge
}
