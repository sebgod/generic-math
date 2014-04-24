%------------------------------------------------------------------------------%
% File: generic_math.m
% Main author: Sebastian Godelet <sebastian.godelet+github@generic_mathail.com>
% Created on: Thu Apr 24 18:19:24 WEST 2014
% vim: ft=mercury ff=unix ts=4 sw=4 et
%
%------------------------------------------------------------------------------%

:- module generic_math.

:- interface.

:- use_module int.
:- use_module float.
:- use_module integer.

:- type bigint == integer.integer.

:- type unary_op_func(T) == (func(T) = T).

:- type binary_op_func(T) == (func(T, T) = T).
:- inst binary_op_func_uo == (func(in, in) = uo is det).
:- inst binary_op_func_out == (func(in, in) = out is det).

:- typeclass generic_math(T) where [
    func abs `with_type` unary_op_func(T),
    func min `with_type` binary_op_func(T),
    func max `with_type` binary_op_func(T),
    func times `with_type` binary_op_func(T),
    func divide `with_type` binary_op_func(T),
    func pow `with_type` binary_op_func(T),
    func add `with_type` binary_op_func(T),
    func substract `with_type` binary_op_func(T),
    % conversion functions
    func to_int(T) = int is semidet,
    func to_integer(T) = bigint is semidet,
    func to_float(T) = float
].

:- instance generic_math(int).
:- instance generic_math(float).
:- instance generic_math(integer.integer).

:- func T * T = T <= generic_math(T).
:- func T / T = T <= generic_math(T).
:- func T // T = T <= generic_math(T).
:- func T ** T = T <= generic_math(T).
:- func T + T = T <= generic_math(T).
:- func T - T = T <= generic_math(T).

:- func det_to_int(T) = int <= generic_math(T).
:- func det_to_integer(T) = bigint <= generic_math(T).

%------------------------------------------------------------------------------%
%------------------------------------------------------------------------------%

:- implementation.

:- use_module math, std_util.
:- import_module exception, string.

Multiplicand * Multiplier = times(Multiplicand, Multiplier).
Dividend / Divisor = divide(Dividend, Divisor).
Dividend // Divisor = divide(Dividend, Divisor).
Base ** Exponent = pow(Base, Exponent).
Augend + Addend = add(Augend, Addend).
Minuend - Subtrahend = substract(Minuend, Subtrahend).

det_to_int(Number) = Int :-
    (   Int0 = to_int(Number) -> Int = Int0
    ;   throw(math.domain_error($pred ++ ": cannot cast to int"))
    ).

det_to_integer(Number) = Integer :-
    (   Integer0 = to_integer(Number) -> Integer = Integer0
    ;   throw(math.domain_error($pred ++ ": cannot cast to integer"))
    ).

:- instance generic_math(int) where [
    func(abs/1) is int.abs,
    func(min/2) is int.min,
    func(max/2) is int.max,
    func(times/2) is int.(*),
    func(divide/2) is int.(//),
    func(pow/2) is int.pow,
    func(add/2) is int.(+),
    func(substract/2) is int.(-),
    func(to_int/1) is std_util.id,
    func(to_integer/1) is integer.integer,
    func(to_float/1) is float.float
].

:- func float_to_int(float) = int is semidet.

float_to_int(Float) = Floor :-
    Floor = float.floor_to_int(Float),
    Ceil = float.ceiling_to_int(Float),
    Floor = Ceil.

:- func float_to_integer(float) = bigint is semidet.

float_to_integer(Float) = integer.integer(float_to_int(Float)).

:- instance generic_math(float) where [
    func(abs/1) is float.abs,
    func(min/2) is float.min,
    func(max/2) is float.max,
    func(times/2) is float.(*),
    func(divide/2) is float.(/),
    func(pow/2) is math.pow,
    func(add/2) is float.(+),
    func(substract/2) is float.(-),
    func(to_int/1) is float_to_int,
    func(to_integer/1) is float_to_integer,
    func(to_float/1) is std_util.id
].

:- func integer_min
    `with_type` binary_op_func(bigint)
    `with_inst` binary_op_func_out.

integer_min(A, B) = Min :-
    ( integer.'=<'(A, B) -> Min = A ; Min = B ).

:- func integer_max
    `with_type` binary_op_func(bigint)
    `with_inst` binary_op_func_out.

integer_max(A, B) = Max :-
    ( integer.'>='(A, B) -> Max = A ; Max = B ).

:- instance generic_math(integer.integer) where [
    func(abs/1) is integer.abs,
    func(min/2) is integer_min,
    func(max/2) is integer_max,
    func(times/2) is integer.(*),
    func(divide/2) is integer.(//),
    func(pow/2) is integer.pow,
    func(add/2) is integer.(+),
    func(substract/2) is integer.(-),
    func(to_int/1) is integer.int,
    func(to_integer/1) is std_util.id,
    func(to_float/1) is integer.float
].

%------------------------------------------------------------------------------%

%------------------------------------------------------------------------------%
:- end_module generic_math.
%-*- Mode: Mercury; column: 80; indent-tabs-mode: nil; tabs-width: 4 -*-
%------------------------------------------------------------------------------%
