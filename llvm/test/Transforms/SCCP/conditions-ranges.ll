; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -ipsccp -S | FileCheck %s

declare void @use(i1)

define void @f1(i32 %a, i32 %b) {
; CHECK-LABEL: @f1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_255:%.*]] = and i32 [[A:%.*]], 255
; CHECK-NEXT:    [[A_2:%.*]] = add i32 [[A_255]], 20
; CHECK-NEXT:    [[BC:%.*]] = icmp ugt i32 [[B:%.*]], [[A_2]]
; CHECK-NEXT:    br i1 [[BC]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i32 [[B]], 21
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i32 [[B]], 21
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp ugt i32 [[B]], 255
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[C_4:%.*]] = icmp eq i32 [[B]], 21
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    [[C_5:%.*]] = icmp eq i32 [[B]], 275
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
;
entry:
  %a.255 = and i32 %a, 255
  %a.2 = add i32 %a.255, 20
  %bc = icmp ugt i32 %b, %a.2
  br i1 %bc, label %true, label %false

true: ; %b in [21, 0)
  ; Conditions below are false.
  %f.1 = icmp eq i32 %b, 0
  call void @use(i1 %f.1)
  %f.2 = icmp eq i32 %b, 20
  call void @use(i1 %f.2)
  %f.3 = icmp ult i32 %b, 20
  call void @use(i1 %f.3)

  ; Conditions below are true.
  %t.1 = icmp ugt i32 %b, 5
  call void @use(i1 %t.1)
  %t.2 = icmp ne i32 %b, 20
  call void @use(i1 %t.2)

  ; Conditions below cannot be simplified.
  %c.1 = icmp eq i32 %b, 21
  call void @use(i1 %c.1)
  %c.2 = icmp ugt i32 %b, 21
  call void @use(i1 %c.2)
  %c.3 = icmp ugt i32 %b, 255
  call void @use(i1 %c.3)
  ret void

false: ;%b in [0, 276)
  ; Conditions below are false;
  %f.4 = icmp eq i32 %b, 276
  call void @use(i1 %f.4)
  %f.5 = icmp ugt i32 %b, 275
  call void @use(i1 %f.5)

  ; Conditions below are true;
  %t.3 = icmp ne i32 %b, 276
  call void @use(i1 %t.3)
  %t.4 = icmp ule i32 %b, 275
  call void @use(i1 %t.4)

  ; Conditions below cannot be simplified.
  %c.4 = icmp eq i32 %b, 21
  call void @use(i1 %c.4)
  %c.5 = icmp eq i32 %b, 275
  call void @use(i1 %c.5)
  ret void
}

; TODO: Use information %a != 0 in false branch.
define void @f2_ptr(i8* %a, i8* %b) {
; CHECK-LABEL: @f2_ptr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BC:%.*]] = icmp eq i8* [[A:%.*]], null
; CHECK-NEXT:    br i1 [[BC]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i8* null, [[B:%.*]]
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    [[F_2:%.*]] = icmp eq i8* [[A]], null
; CHECK-NEXT:    call void @use(i1 [[F_2]])
; CHECK-NEXT:    [[T_2:%.*]] = icmp ne i8* [[A]], null
; CHECK-NEXT:    call void @use(i1 [[T_2]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i8* [[A]], [[B]]
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    ret void
;
entry:
  %bc = icmp eq i8* %a, null
  br i1 %bc, label %true, label %false

true: ; %a == 0
  %f.1 = icmp ne i8* %a, null
  call void @use(i1 %f.1)

  %t.1 = icmp eq i8* %a, null
  call void @use(i1 %t.1)

  %c.1 = icmp eq i8* %a, %b
  call void @use(i1 %c.1)
  ret void

false: ; %a != 0
  %f.2 = icmp eq i8* %a, null
  call void @use(i1 %f.2)

  %t.2 = icmp ne i8* %a, null
  call void @use(i1 %t.2)

  %c.2 = icmp eq i8* %a, %b
  call void @use(i1 %c.2)
  ret void
}

define i8* @f3(i8* %a, i8* %b, i1 %c) {
; CHECK-LABEL: @f3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i8* [[A:%.*]], null
; CHECK-NEXT:    br i1 [[C_1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[TRUE_2:%.*]], label [[FALSE_2:%.*]]
; CHECK:       true.2:
; CHECK-NEXT:    br label [[EXIT_2:%.*]]
; CHECK:       false.2:
; CHECK-NEXT:    br label [[EXIT_2]]
; CHECK:       exit.2:
; CHECK-NEXT:    [[P:%.*]] = phi i8* [ null, [[TRUE_2]] ], [ [[B:%.*]], [[FALSE_2]] ]
; CHECK-NEXT:    ret i8* [[P]]
; CHECK:       false:
; CHECK-NEXT:    ret i8* null
;
entry:
  %c.1 = icmp eq i8* %a, null
  br i1 %c.1, label %true, label %false

true:
  br i1 %c, label %true.2, label %false.2

true.2:
  br label %exit.2

false.2:
  br label %exit.2

exit.2:
  %p = phi i8* [ %a, %true.2 ], [ %b, %false.2 ]
  ret i8* %p

false:
  ret i8* null
}

define i32 @f5(i64 %sz) {
; CHECK-LABEL: @f5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i64 4088, [[SZ:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_TRUE:%.*]], label [[COND_END:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    [[DIV:%.*]] = udiv i64 4088, [[SZ]]
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[COND:%.*]] = phi i64 [ [[DIV]], [[COND_TRUE]] ], [ 1, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[CONV:%.*]] = trunc i64 [[COND]] to i32
; CHECK-NEXT:    ret i32 [[CONV]]
;
entry:
  %cmp = icmp ugt i64 4088, %sz
  br i1 %cmp, label %cond.true, label %cond.end

cond.true:                                        ; preds = %entry
  %div = udiv i64 4088, %sz
  br label %cond.end

cond.end:                                         ; preds = %entry, %cond.true
  %cond = phi i64 [ %div, %cond.true ], [ 1, %entry ]
  %conv = trunc i64 %cond to i32
  ret i32 %conv
}

define void @f6(i32 %b) {
; CHECK-LABEL: @f6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp ugt i32 [[B:%.*]], 20
; CHECK-NEXT:    br i1 [[C_1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    ret void
;
entry:
  %a = add i32 10, 10
  %c.1 = icmp ugt i32 %b, %a
  br i1 %c.1, label %true, label %false

true:
  %c.2 = icmp eq i32 %a, 20
  call void @use(i1 %c.2)
  ret void

false:
  ret void
}

; Test with 2 unrelated nested conditions.
define void @f7_nested_conds(i32* %a, i32 %b) {
; CHECK-LABEL: @f7_nested_conds(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_V:%.*]] = load i32, i32* [[A:%.*]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ne i32 [[A_V]], 0
; CHECK-NEXT:    br i1 [[C_1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       false:
; CHECK-NEXT:    br i1 true, label [[TRUE_2:%.*]], label [[TRUE]]
; CHECK:       true.2:
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    ret void
; CHECK:       true:
; CHECK-NEXT:    store i32 [[B:%.*]], i32* [[A]]
; CHECK-NEXT:    ret void
;
entry:
  %a.v = load i32, i32* %a
  %c.1 = icmp ne i32 %a.v, 0
  br i1 %c.1, label %true, label %false

false:
  %c.2 = icmp ult i32 %a.v, 3
  br i1 %c.2, label %true.2, label %true

true.2:
  %c.3 = icmp eq i32 %a.v, 0
  call void @use(i1 %c.3)
  ret void

true:
  store i32 %b, i32* %a
  ret void
}

; Test with 2 related nested conditions (%b > [20, 276) && %b < 255).
define void @f8_nested_conds(i32 %a, i32 %b) {
; CHECK-LABEL: @f8_nested_conds(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_255:%.*]] = and i32 [[A:%.*]], 255
; CHECK-NEXT:    [[A_2:%.*]] = add i32 [[A_255]], 20
; CHECK-NEXT:    [[BC_1:%.*]] = icmp ugt i32 [[B:%.*]], [[A_2]]
; CHECK-NEXT:    br i1 [[BC_1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    [[BC_2:%.*]] = icmp ult i32 [[B]], 255
; CHECK-NEXT:    br i1 [[BC_2]], label [[TRUE_2:%.*]], label [[FALSE_2:%.*]]
; CHECK:       true.2:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i32 [[B]], 21
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i32 [[B]], 21
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp ugt i32 [[B]], 34
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    ret void
; CHECK:       false.2:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[C_4:%.*]] = icmp eq i32 [[B]], 255
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    [[C_5:%.*]] = icmp ne i32 [[B]], 275
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    ret void
;
entry:
  %a.255 = and i32 %a, 255
  %a.2 = add i32 %a.255, 20
  %bc.1 = icmp ugt i32 %b, %a.2
  br i1 %bc.1, label %true, label %false

true: ; %b in [21, 0)
  %bc.2 = icmp ult i32 %b, 255
  br i1 %bc.2, label %true.2, label %false.2

true.2: ; %b in [21, 255)
  ; Conditions below are false.
  %f.1 = icmp eq i32 %b, 0
  call void @use(i1 %f.1)
  %f.2 = icmp eq i32 %b, 20
  call void @use(i1 %f.2)
  %f.3 = icmp ult i32 %b, 20
  call void @use(i1 %f.3)
  %f.4 = icmp eq i32 %b, 255
  call void @use(i1 %f.4)
  %f.5 = icmp ugt i32 %b, 255
  call void @use(i1 %f.5)


  ; Conditions below are true.
  %t.1 = icmp ugt i32 %b, 5
  call void @use(i1 %t.1)
  %t.2 = icmp ne i32 %b, 20
  call void @use(i1 %t.2)
  %t.3 = icmp ult i32 %b, 255
  call void @use(i1 %t.3)
  %t.4 = icmp ne i32 %b,  300
  call void @use(i1 %t.4)

  ; Conditions below cannot be simplified.
  %c.1 = icmp eq i32 %b, 21
  call void @use(i1 %c.1)
  %c.2 = icmp ugt i32 %b, 21
  call void @use(i1 %c.2)
  %c.3 = icmp ugt i32 %b, 34
  call void @use(i1 %c.3)
  ret void

false.2: ;%b in [255, 0)
  ; Conditions below are false;
  %f.6 = icmp eq i32 %b, 254
  call void @use(i1 %f.6)
  %f.7 = icmp ult i32 %b, 255
  call void @use(i1 %f.7)

  ; Conditions below are true;
  %t.5 = icmp ne i32 %b, 254
  call void @use(i1 %t.5)
  %t.6 = icmp uge i32 %b, 255
  call void @use(i1 %t.6)

  ; Conditions below cannot be simplified.
  %c.4 = icmp eq i32 %b, 255
  call void @use(i1 %c.4)
  %c.5 = icmp ne i32 %b, 275
  call void @use(i1 %c.5)
  ret void

false:
  ret void
}

; Test with with nested conditions where the second conditions is more limiting than the first one.
define void @f9_nested_conds(i32 %a, i32 %b) {
; CHECK-LABEL: @f9_nested_conds(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BC_1:%.*]] = icmp ugt i32 [[B:%.*]], 10
; CHECK-NEXT:    br i1 [[BC_1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i32 [[B]], 11
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i32 [[B]], 11
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[BC_2:%.*]] = icmp ugt i32 [[B]], 20
; CHECK-NEXT:    br i1 [[BC_2]], label [[TRUE_2:%.*]], label [[FALSE_2:%.*]]
; CHECK:       true.2:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[C_3:%.*]] = icmp eq i32 [[B]], 21
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp ugt i32 [[B]], 21
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    [[C_5:%.*]] = icmp ugt i32 [[B]], 34
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
; CHECK:       false.2:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[C_6:%.*]] = icmp eq i32 [[B]], 11
; CHECK-NEXT:    call void @use(i1 [[C_6]])
; CHECK-NEXT:    [[C_7:%.*]] = icmp ne i32 [[B]], 15
; CHECK-NEXT:    call void @use(i1 [[C_7]])
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    ret void
;
entry:
  %bc.1 = icmp ugt i32 %b, 10
  br i1 %bc.1, label %true, label %false

true: ; %b in [11, 0)
  ; Conditions below are false.
  %f.1 = icmp eq i32 %b, 0
  call void @use(i1 %f.1)
  %f.2 = icmp eq i32 %b, 10
  call void @use(i1 %f.2)

  ; Conditions below are true.
  %t.1 = icmp ugt i32 %b, 5
  call void @use(i1 %t.1)
  %t.2 = icmp ne i32 %b, 10
  call void @use(i1 %t.2)

  ; Conditions below cannot be simplified.
  %c.1 = icmp eq i32 %b, 11
  call void @use(i1 %c.1)
  %c.2 = icmp ugt i32 %b, 11
  call void @use(i1 %c.2)

  %bc.2 = icmp ugt i32 %b, 20
  br i1 %bc.2, label %true.2, label %false.2

true.2: ; %b in [21, 0)
  ; Conditions below are false.
  %f.3 = icmp eq i32 %b, 11
  call void @use(i1 %f.3)
  %f.4 = icmp eq i32 %b, 20
  call void @use(i1 %f.4)

  ; Conditions below are true.
  %t.3 = icmp ugt i32 %b, 11
  call void @use(i1 %t.3)
  %t.4 = icmp ne i32 %b, 20
  call void @use(i1 %t.4)

  ; Conditions below cannot be simplified.
  %c.3 = icmp eq i32 %b, 21
  call void @use(i1 %c.3)
  %c.4 = icmp ugt i32 %b, 21
  call void @use(i1 %c.4)
  %c.5 = icmp ugt i32 %b, 34
  call void @use(i1 %c.5)
  ret void

false.2: ;%b in [11, 21)
  ; Conditions below are false;
  %f.5 = icmp eq i32 %b, 21
  call void @use(i1 %f.5)
  %f.6 = icmp ugt i32 %b, 21
  call void @use(i1 %f.6)
  %f.7 = icmp ne i32 %b, 5
  call void @use(i1 %f.7)

  ; Conditions below are true;
  %t.5 = icmp ne i32 %b, 21
  call void @use(i1 %t.5)
  %t.6 = icmp ult i32 %b, 21
  call void @use(i1 %t.6)
  %t.7 = icmp ne i32 %b, 5
  call void @use(i1 %t.7)

  ; Conditions below cannot be simplified.
  %c.6 = icmp eq i32 %b, 11
  call void @use(i1 %c.6)
  %c.7 = icmp ne i32 %b, 15
  call void @use(i1 %c.7)
  ret void

false:
  ret void
}


; Test with with nested conditions where the second conditions is more limiting than the first one.
define void @f10_cond_does_not_restrict_range(i32 %a, i32 %b) {
; CHECK-LABEL: @f10_cond_does_not_restrict_range(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B_255:%.*]] = and i32 [[B:%.*]], 255
; CHECK-NEXT:    br label [[TRUE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i32 [[B_255]], 11
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i32 [[B_255]], 30
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    ret void
;
entry:
  %b.255 = and i32 %b, 255
  %bc.1 = icmp ult i32 %b.255, 300
  br i1 %bc.1, label %true, label %false

true: ; %b in [0, 256)
  ; Conditions below are false.
  %f.1 = icmp eq i32 %b.255, 256
  call void @use(i1 %f.1)
  %f.2 = icmp eq i32 %b.255, 300
  call void @use(i1 %f.2)

  ; Conditions below are true.
  %t.1 = icmp ult i32 %b.255, 256
  call void @use(i1 %t.1)
  %t.2 = icmp ult i32 %b.255, 300
  call void @use(i1 %t.2)
  %t.3 = icmp ne i32 %b.255, 256
  call void @use(i1 %t.3)
  %t.4 = icmp ne i32 %b.255, 300
  call void @use(i1 %t.4)

  ; Conditions below cannot be simplified.
  %c.1 = icmp eq i32 %b.255, 11
  call void @use(i1 %c.1)
  %c.2 = icmp ugt i32 %b.255, 30
  call void @use(i1 %c.2)
  ret void

false:
  ret void
}

define void @f11_contradiction(i32 %a, i32 %b) {
; CHECK-LABEL: @f11_contradiction(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BC_1:%.*]] = icmp eq i32 [[B:%.*]], 10
; CHECK-NEXT:    br i1 [[BC_1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    br label [[FALSE]]
; CHECK:       false:
; CHECK-NEXT:    ret void
;
entry:
  %bc.1 = icmp eq i32 %b, 10
  br i1 %bc.1, label %true, label %false

true: ; %b in [10, 11)
  %bc.2 = icmp eq i32 %b, 20
  br i1 %bc.2, label %true.2, label %false

true.2:
  %f.1 = icmp eq i32 %b, 256
  call void @use(i1 %f.1)
  %f.2 = icmp ne i32 %b, 300
  call void @use(i1 %f.2)
  ret void

false:
  ret void
}

define void @f12_float(float %b) {
; CHECK-LABEL: @f12_float(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BC_1:%.*]] = fcmp olt float 1.000000e+00, [[B:%.*]]
; CHECK-NEXT:    br i1 [[BC_1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    ret void
;
entry:
  %a = fadd float 0.0, 1.0
  %bc.1 = fcmp olt float %a, %b
  br i1 %bc.1, label %true, label %false

true: ; %b in [10, 11)
  %f.1 = fcmp one float %a, 1.0
  call void @use(i1 %f.1)

  %t.1 = fcmp oeq float %a, 1.0
  call void @use(i1 %t.1)
  ret void

false:
  ret void
}


@A = global i32 17
@B = global i32 17

define void @f13_constexpr1() {
; CHECK-LABEL: @f13_constexpr1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BC_1:%.*]] = icmp eq i32 add (i32 ptrtoint (i32* @A to i32), i32 10), 55
; CHECK-NEXT:    br i1 [[BC_1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    ret void
;
entry:
  %a = add i32 ptrtoint (i32* @A to i32), 10
  %bc.1 = icmp eq i32 %a, 55
  br i1 %bc.1, label %true, label %false

true: ; %b in [10, 11)
  %f.1 = icmp eq i32 %a, 10
  call void @use(i1 %f.1)
  %f.2 = icmp eq i32 %a, 55
  call void @use(i1 %f.2)

  ret void

false:
  ret void
}

; TODO: can we fold the compares in the true block?
define void @f14_constexpr2() {
; CHECK-LABEL: @f14_constexpr2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 icmp eq (i32 ptrtoint (i32* @A to i32), i32 ptrtoint (i32* @B to i32)), label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    call void @use(i1 icmp ne (i32 ptrtoint (i32* @B to i32), i32 ptrtoint (i32* @A to i32)))
; CHECK-NEXT:    call void @use(i1 icmp eq (i32 ptrtoint (i32* @B to i32), i32 ptrtoint (i32* @A to i32)))
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    ret void
;
entry:
  %a = add i32 ptrtoint (i32* @A to i32), 0
  %b = add i32 ptrtoint (i32* @B to i32), 0
  %bc.1 = icmp eq i32 %a, %b
  br i1 %bc.1, label %true, label %false

true: ; %b in [10, 11)
  %f.1 = icmp ne i32 %a, %b
  call void @use(i1 %f.1)
  %f.2 = icmp eq i32 %a,  %b
  call void @use(i1 %f.2)

  ret void

false:
  ret void
}

define void @loop_1() {
; CHECK-LABEL: @loop_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC27:%.*]], [[FOR_COND_CLEANUP13:%.*]] ]
; CHECK-NEXT:    [[CMP9:%.*]] = icmp sle i32 [[I_0]], 3
; CHECK-NEXT:    br i1 [[CMP9]], label [[FOR_BODY:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    br label [[FOR_COND11:%.*]]
; CHECK:       for.cond11:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP13]]
; CHECK:       for.cond.cleanup13:
; CHECK-NEXT:    [[INC27]] = add nsw i32 [[I_0]], 1
; CHECK-NEXT:    br label [[FOR_COND]]
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.cond.cleanup13, %if.then
  %i.0 = phi i32 [ 0, %entry ], [ %inc27, %for.cond.cleanup13 ]
  %cmp9 = icmp sle i32 %i.0, 3
  br i1 %cmp9, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  ret void

for.body:                                         ; preds = %for.cond
  br label %for.cond11

for.cond11:                                       ; preds = %arrayctor.cont21, %for.body
  br label %for.cond.cleanup13

for.cond.cleanup13:                               ; preds = %for.cond11
  %inc27 = add nsw i32 %i.0, 1
  br label %for.cond
}


define void @loop() {
; CHECK-LABEL: @loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC27:%.*]], [[FOR_COND_CLEANUP13:%.*]] ]
; CHECK-NEXT:    [[CMP9:%.*]] = icmp sle i32 [[I_0]], 3
; CHECK-NEXT:    br i1 [[CMP9]], label [[FOR_BODY:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    br label [[FOR_COND11:%.*]]
; CHECK:       for.cond11:
; CHECK-NEXT:    [[J_0:%.*]] = phi i32 [ 0, [[FOR_BODY]] ], [ [[INC:%.*]], [[FOR_BODY14:%.*]] ]
; CHECK-NEXT:    [[CMP12:%.*]] = icmp slt i32 [[J_0]], 2
; CHECK-NEXT:    br i1 [[CMP12]], label [[FOR_BODY14]], label [[FOR_COND_CLEANUP13]]
; CHECK:       for.cond.cleanup13:
; CHECK-NEXT:    [[INC27]] = add nsw i32 [[I_0]], 1
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.body14:
; CHECK-NEXT:    [[INC]] = add nsw i32 [[J_0]], 1
; CHECK-NEXT:    br label [[FOR_COND11]]
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.cond.cleanup13, %if.then
  %i.0 = phi i32 [ 0, %entry ], [ %inc27, %for.cond.cleanup13 ]
  %cmp9 = icmp sle i32 %i.0, 3
  br i1 %cmp9, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  ret void

for.body:                                         ; preds = %for.cond
  br label %for.cond11

for.cond11:                                       ; preds = %arrayctor.cont21, %for.body
  %j.0 = phi i32 [ 0, %for.body ], [ %inc, %for.body14 ]
  %cmp12 = icmp slt i32 %j.0, 2
  br i1 %cmp12, label %for.body14, label %for.cond.cleanup13

for.cond.cleanup13:                               ; preds = %for.cond11
  %inc27 = add nsw i32 %i.0, 1
  br label %for.cond

for.body14:
  %inc = add nsw i32 %j.0, 1
  br label %for.cond11
}

define i32 @udiv_1(i64 %sz) {
; CHECK-LABEL: @udiv_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i64 4088, [[SZ:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_TRUE:%.*]], label [[COND_END:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    [[DIV:%.*]] = udiv i64 4088, [[SZ]]
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[COND:%.*]] = phi i64 [ [[DIV]], [[COND_TRUE]] ], [ 1, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[CONV:%.*]] = trunc i64 [[COND]] to i32
; CHECK-NEXT:    ret i32 [[CONV]]
;
entry:
  %cmp = icmp ugt i64 4088, %sz
  br i1 %cmp, label %cond.true, label %cond.end

cond.true:                                        ; preds = %entry
  %div = udiv i64 4088, %sz
  br label %cond.end

cond.end:                                         ; preds = %entry, %cond.true
  %cond = phi i64 [ %div, %cond.true ], [ 1, %entry ]
  %conv = trunc i64 %cond to i32
  ret i32 %conv
}

; Same as @udiv_1, but with the condition switched.
define i32 @udiv_2(i64 %sz) {
; CHECK-LABEL: @udiv_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i64 [[SZ:%.*]], 4088
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_TRUE:%.*]], label [[COND_END:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[COND:%.*]] = phi i64 [ 0, [[COND_TRUE]] ], [ 1, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[CONV:%.*]] = trunc i64 [[COND]] to i32
; CHECK-NEXT:    ret i32 [[CONV]]
;
entry:
  %cmp = icmp ugt i64 %sz, 4088
  br i1 %cmp, label %cond.true, label %cond.end

cond.true:                                        ; preds = %entry
  %div = udiv i64 4088, %sz
  br label %cond.end

cond.end:                                         ; preds = %entry, %cond.true
  %cond = phi i64 [ %div, %cond.true ], [ 1, %entry ]
  %conv = trunc i64 %cond to i32
  ret i32 %conv
}

define void @f16_conditions_and(i32 %a, i32 %b) {
; CHECK-LABEL: @f16_conditions_and(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LT:%.*]] = icmp ult i32 [[A:%.*]], 100
; CHECK-NEXT:    [[GT:%.*]] = icmp ugt i32 [[A]], 20
; CHECK-NEXT:    [[BC:%.*]] = and i1 [[LT]], [[GT]]
; CHECK-NEXT:    br i1 [[BC]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    [[F_1:%.*]] = icmp eq i32 [[A]], 0
; CHECK-NEXT:    call void @use(i1 [[F_1]])
; CHECK-NEXT:    [[F_2:%.*]] = icmp eq i32 [[A]], 20
; CHECK-NEXT:    call void @use(i1 [[F_2]])
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[T_2:%.*]] = icmp ne i32 [[A]], 20
; CHECK-NEXT:    call void @use(i1 [[T_2]])
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i32 [[A]], 21
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i32 [[A]], 21
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp ugt i32 [[A]], 50
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    [[F_4:%.*]] = icmp eq i32 [[A]], 50
; CHECK-NEXT:    call void @use(i1 [[F_4]])
; CHECK-NEXT:    [[T_3:%.*]] = icmp ne i32 [[A]], 50
; CHECK-NEXT:    call void @use(i1 [[T_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp eq i32 [[A]], 10
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    [[C_5:%.*]] = icmp eq i32 [[B:%.*]], 100
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
;
entry:
  %lt = icmp ult i32 %a, 100
  %gt = icmp ugt i32 %a, 20
  %bc = and i1 %lt, %gt
  br i1 %bc, label %true, label %false

true: ; %a in [21, 100)
  ; Conditions below are false.
  %f.1 = icmp eq i32 %a, 0
  call void @use(i1 %f.1)
  %f.2 = icmp eq i32 %a, 20
  call void @use(i1 %f.2)
  %f.3 = icmp ugt i32 %a, 100
  call void @use(i1 %f.3)

  ; Conditions below are true.
  %t.1 = icmp ult i32 %a, 100
  call void @use(i1 %t.1)
  %t.2 = icmp ne i32 %a, 20
  call void @use(i1 %t.2)

  ; Conditions below cannot be simplified.
  %c.1 = icmp eq i32 %a, 21
  call void @use(i1 %c.1)
  %c.2 = icmp ugt i32 %a, 21
  call void @use(i1 %c.2)
  %c.3 = icmp ugt i32 %a, 50
  call void @use(i1 %c.3)
  ret void

false:
; TODO: Currently there is no conditional range info in the false branch for branch conditions with an AND.
;       %a should be in in [100, 21)
  ; Conditions below are false;
  %f.4 = icmp eq i32 %a, 50
  call void @use(i1 %f.4)

  ; Conditions below are true;
  %t.3 = icmp ne i32 %a, 50
  call void @use(i1 %t.3)

  ; Conditions below cannot be simplified.
  %c.4 = icmp eq i32 %a, 10
  call void @use(i1 %c.4)
  %c.5 = icmp eq i32 %b, 100
  call void @use(i1 %c.5)
  ret void
}

define void @f17_conditions_or(i32 %a, i32 %b) {
; CHECK-LABEL: @f17_conditions_or(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[GT:%.*]] = icmp uge i32 [[A:%.*]], 100
; CHECK-NEXT:    [[LT:%.*]] = icmp ule i32 [[A]], 20
; CHECK-NEXT:    [[BC:%.*]] = or i1 [[LT]], [[GT]]
; CHECK-NEXT:    br i1 [[BC]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       false:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[F_3:%.*]] = icmp ugt i32 [[A]], 100
; CHECK-NEXT:    call void @use(i1 [[F_3]])
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult i32 [[A]], 100
; CHECK-NEXT:    call void @use(i1 [[T_1]])
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i32 [[A]], 21
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i32 [[A]], 21
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp ugt i32 [[A]], 50
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    ret void
; CHECK:       true:
; CHECK-NEXT:    [[F_4:%.*]] = icmp eq i32 [[A]], 50
; CHECK-NEXT:    call void @use(i1 [[F_4]])
; CHECK-NEXT:    [[T_3:%.*]] = icmp ne i32 [[A]], 50
; CHECK-NEXT:    call void @use(i1 [[T_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp eq i32 [[A]], 10
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    [[C_5:%.*]] = icmp eq i32 [[B:%.*]], 100
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
;
entry:
  %gt = icmp uge i32 %a, 100
  %lt = icmp ule i32 %a, 20
  %bc = or i1 %lt, %gt
  br i1 %bc, label %true, label %false

false: ; %a in [21, 100)
  ; Conditions below are false.
  %f.1 = icmp eq i32 %a, 0
  call void @use(i1 %f.1)
  %f.2 = icmp eq i32 %a, 20
  call void @use(i1 %f.2)
  %f.3 = icmp ugt i32 %a, 100
  call void @use(i1 %f.3)

  ; Conditions below are true.
  %t.1 = icmp ult i32 %a, 100
  call void @use(i1 %t.1)
  %t.2 = icmp ne i32 %a, 20
  call void @use(i1 %t.2)

  ; Conditions below cannot be simplified.
  %c.1 = icmp eq i32 %a, 21
  call void @use(i1 %c.1)
  %c.2 = icmp ugt i32 %a, 21
  call void @use(i1 %c.2)
  %c.3 = icmp ugt i32 %a, 50
  call void @use(i1 %c.3)
  ret void

true:
; TODO: Currently there is no conditional range info in the false branch for branch conditions with an AND.
;       %a should be in in [100, 21)
  ; Conditions below are false;
  %f.4 = icmp eq i32 %a, 50
  call void @use(i1 %f.4)

  ; Conditions below are true;
  %t.3 = icmp ne i32 %a, 50
  call void @use(i1 %t.3)

  ; Conditions below cannot be simplified.
  %c.4 = icmp eq i32 %a, 10
  call void @use(i1 %c.4)
  %c.5 = icmp eq i32 %b, 100
  call void @use(i1 %c.5)
  ret void
}

; TODO: Currently only the information of the AND used as branch condition is
; used.
define void @f18_conditions_chained_and(i32 %a, i32 %b) {
; CHECK-LABEL: @f18_conditions_chained_and(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LT:%.*]] = icmp ult i32 [[A:%.*]], 100
; CHECK-NEXT:    [[GT:%.*]] = icmp ugt i32 [[A]], 20
; CHECK-NEXT:    [[BC:%.*]] = and i1 [[LT]], [[GT]]
; CHECK-NEXT:    [[B_LT:%.*]] = icmp ult i32 [[B:%.*]], 50
; CHECK-NEXT:    [[BC_2:%.*]] = and i1 [[BC]], [[B_LT]]
; CHECK-NEXT:    br i1 [[BC_2]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    [[F_1:%.*]] = icmp eq i32 [[A]], 0
; CHECK-NEXT:    call void @use(i1 [[F_1]])
; CHECK-NEXT:    [[F_2:%.*]] = icmp eq i32 [[A]], 20
; CHECK-NEXT:    call void @use(i1 [[F_2]])
; CHECK-NEXT:    [[F_3:%.*]] = icmp ugt i32 [[A]], 100
; CHECK-NEXT:    call void @use(i1 [[F_3]])
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult i32 [[A]], 100
; CHECK-NEXT:    call void @use(i1 [[T_1]])
; CHECK-NEXT:    [[T_2:%.*]] = icmp ne i32 [[A]], 20
; CHECK-NEXT:    call void @use(i1 [[T_2]])
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i32 [[A]], 21
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i32 [[A]], 21
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp ugt i32 [[A]], 50
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    [[F_4:%.*]] = icmp eq i32 [[A]], 50
; CHECK-NEXT:    call void @use(i1 [[F_4]])
; CHECK-NEXT:    [[T_3:%.*]] = icmp ne i32 [[A]], 50
; CHECK-NEXT:    call void @use(i1 [[T_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp eq i32 [[A]], 10
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    [[C_5:%.*]] = icmp eq i32 [[B]], 100
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
;
entry:
  %lt = icmp ult i32 %a, 100
  %gt = icmp ugt i32 %a, 20
  %bc = and i1 %lt, %gt
  %b.lt = icmp ult i32 %b, 50
  %bc.2 = and i1 %bc, %b.lt
  br i1 %bc.2, label %true, label %false

true: ; %a in [21, 100)
  ; Conditions below are false.
  %f.1 = icmp eq i32 %a, 0
  call void @use(i1 %f.1)
  %f.2 = icmp eq i32 %a, 20
  call void @use(i1 %f.2)
  %f.3 = icmp ugt i32 %a, 100
  call void @use(i1 %f.3)

  ; Conditions below are true.
  %t.1 = icmp ult i32 %a, 100
  call void @use(i1 %t.1)
  %t.2 = icmp ne i32 %a, 20
  call void @use(i1 %t.2)

  ; Conditions below cannot be simplified.
  %c.1 = icmp eq i32 %a, 21
  call void @use(i1 %c.1)
  %c.2 = icmp ugt i32 %a, 21
  call void @use(i1 %c.2)
  %c.3 = icmp ugt i32 %a, 50
  call void @use(i1 %c.3)
  ret void

false:
  ; Conditions below are false;
  %f.4 = icmp eq i32 %a, 50
  call void @use(i1 %f.4)

  ; Conditions below are true;
  %t.3 = icmp ne i32 %a, 50
  call void @use(i1 %t.3)

  ; Conditions below cannot be simplified.
  %c.4 = icmp eq i32 %a, 10
  call void @use(i1 %c.4)
  %c.5 = icmp eq i32 %b, 100
  call void @use(i1 %c.5)
  ret void
}

define void @f19_conditions_chained_and_nested_and(i32 %a, i32 %b) {
; CHECK-LABEL: @f19_conditions_chained_and_nested_and(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LT_A:%.*]] = icmp ult i32 [[A:%.*]], 100
; CHECK-NEXT:    [[LT_B:%.*]] = icmp ult i32 [[B:%.*]], 1000
; CHECK-NEXT:    [[BC:%.*]] = and i1 [[LT_A]], [[LT_B]]
; CHECK-NEXT:    br i1 [[BC]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    [[GT_A:%.*]] = icmp ugt i32 [[A]], 30
; CHECK-NEXT:    [[GT_B:%.*]] = icmp ugt i32 [[B]], 300
; CHECK-NEXT:    [[BC_2:%.*]] = and i1 [[GT_A]], [[GT_B]]
; CHECK-NEXT:    br i1 [[BC_2]], label [[TRUE_2:%.*]], label [[FALSE]]
; CHECK:       true.2:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i32 [[A]], 31
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i32 [[A]], 31
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp ugt i32 [[A]], 50
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp eq i32 [[B]], 301
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    [[C_5:%.*]] = icmp ugt i32 [[B]], 301
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    [[C_6:%.*]] = icmp ugt i32 [[B]], 500
; CHECK-NEXT:    call void @use(i1 [[C_6]])
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    ret void
;
entry:
  %lt.a = icmp ult i32 %a, 100
  %lt.b = icmp ult i32 %b, 1000
  %bc = and i1 %lt.a, %lt.b
  br i1 %bc, label %true, label %false

true:
  %gt.a = icmp ugt i32 %a, 30
  %gt.b = icmp ugt i32 %b, 300
  %bc.2 = and i1 %gt.a, %gt.b
  br i1 %bc.2, label %true.2, label %false

true.2:
  ; Conditions below are false.
  %f.1 = icmp eq i32 %a, 0
  call void @use(i1 %f.1)
  %f.2 = icmp eq i32 %a, 20
  call void @use(i1 %f.2)
  %f.3 = icmp ugt i32 %a, 100
  call void @use(i1 %f.3)
  %f.4 = icmp eq i32 %b, 0
  call void @use(i1 %f.4)
  %f.5 = icmp eq i32 %b, 300
  call void @use(i1 %f.5)
  %f.6 = icmp ugt i32 %b, 1000
  call void @use(i1 %f.6)


  ; Conditions below are true.
  %t.1 = icmp ult i32 %a, 100
  call void @use(i1 %t.1)
  %t.2 = icmp ne i32 %a, 20
  call void @use(i1 %t.2)
  %t.3 = icmp ult i32 %b, 1000
  call void @use(i1 %t.3)
  %t.4 = icmp ne i32 %b, 300
  call void @use(i1 %t.4)


  ; Conditions below cannot be simplified.
  %c.1 = icmp eq i32 %a, 31
  call void @use(i1 %c.1)
  %c.2 = icmp ugt i32 %a, 31
  call void @use(i1 %c.2)
  %c.3 = icmp ugt i32 %a, 50
  call void @use(i1 %c.3)
  %c.4 = icmp eq i32 %b, 301
  call void @use(i1 %c.4)
  %c.5 = icmp ugt i32 %b, 301
  call void @use(i1 %c.5)
  %c.6 = icmp ugt i32 %b, 500
  call void @use(i1 %c.6)

  ret void

false:
  ret void
}

declare i64 @get_i64()

declare i1 @cond()

define void @f20_ne_0_nuked_by_and(i32 %arg) local_unnamed_addr #0 {
; CHECK-LABEL: @f20_ne_0_nuked_by_and(
; CHECK-NEXT:  bb11:
; CHECK-NEXT:    br label [[BB122:%.*]]
; CHECK:       bb122:
; CHECK-NEXT:    [[TMP123:%.*]] = phi i32 [ 256, [[BB11:%.*]] ], [ [[TMP136:%.*]], [[BB135:%.*]] ]
; CHECK-NEXT:    [[TMP127:%.*]] = call i64 @get_i64()
; CHECK-NEXT:    [[TMP128:%.*]] = trunc i64 [[TMP127]] to i32
; CHECK-NEXT:    [[TMP131:%.*]] = icmp ne i32 [[TMP128]], 0
; CHECK-NEXT:    [[TMP132:%.*]] = icmp sgt i32 [[TMP123]], [[TMP128]]
; CHECK-NEXT:    [[TMP133:%.*]] = and i1 [[TMP131]], [[TMP132]]
; CHECK-NEXT:    br i1 [[TMP133]], label [[BB134:%.*]], label [[BB135]]
; CHECK:       bb134:
; CHECK-NEXT:    br label [[BB135]]
; CHECK:       bb135:
; CHECK-NEXT:    [[TMP136]] = phi i32 [ [[TMP123]], [[BB122]] ], [ [[TMP128]], [[BB134]] ]
; CHECK-NEXT:    [[BC:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[BC]], label [[BB139:%.*]], label [[BB122]]
; CHECK:       bb139:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    ret void
;
bb11:                                             ; preds = %bb1
  br label %bb122

bb122:                                            ; preds = %bb135, %bb120
  %tmp123 = phi i32 [ 256, %bb11 ], [ %tmp136, %bb135 ]
  %tmp127 = call i64 @get_i64()
  %tmp128 = trunc i64 %tmp127 to i32
  %tmp131 = icmp ne i32 %tmp128, 0
  %tmp132 = icmp sgt i32 %tmp123, %tmp128
  %tmp133 = and i1 %tmp131, %tmp132
  br i1 %tmp133, label %bb134, label %bb135

bb134:                                            ; preds = %bb122
  br label %bb135

bb135:                                            ; preds = %bb134, %bb122
  %tmp136 = phi i32 [ %tmp123, %bb122 ], [ %tmp128, %bb134 ]
  %bc = call i1 @cond()
  br i1 %bc, label %bb139, label %bb122

bb139:                                            ; preds = %bb135
  %tmp140 = icmp eq i32 %tmp136, 0
  call void @use(i1 %tmp140)
  ret void

bb142:                                            ; preds = %bb139
  ret void
}
