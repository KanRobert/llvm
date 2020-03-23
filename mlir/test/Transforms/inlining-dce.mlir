// RUN: mlir-opt %s -inline | FileCheck %s

// This file tests the callgraph dead code elimination performed by the inliner.

// Function is already dead.
// CHECK-NOT: func @dead_function
func @dead_function() attributes {sym_visibility = "private"} {
  return
}

// Function becomes dead after inlining.
// CHECK-NOT: func @dead_function_b
func @dead_function_b() attributes {sym_visibility = "private"} {
  return
}

// CHECK: func @live_function()
func @live_function() {
  call @dead_function_b() : () -> ()
  return
}

// Same as above, but a transitive example.

// CHECK: func @live_function_b
func @live_function_b() {
  return
}
// CHECK-NOT: func @dead_function_c
func @dead_function_c() attributes {sym_visibility = "private"} {
  call @live_function_b() : () -> ()
  return
}
// CHECK-NOT: func @dead_function_d
func @dead_function_d() attributes {sym_visibility = "private"} {
  call @dead_function_c() : () -> ()
  call @dead_function_c() : () -> ()
  return
}
// CHECK: func @live_function_c
func @live_function_c() {
  call @dead_function_c() : () -> ()
  call @dead_function_d() : () -> ()
  return
}

// Function is referenced by non-callable top-level user.
// CHECK: func @live_function_d
func @live_function_d() attributes {sym_visibility = "private"} {
  return
}

"live.user"() {use = @live_function_d} : () -> ()
