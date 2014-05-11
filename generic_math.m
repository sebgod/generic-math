%------------------------------------------------------------------------------%
% vim: ft=mercury ff=unix ts=4 sw=4 et
% File: generic_math.m
% Copyright (C) 2014 Sebastian Godelet
% Main author: Sebastian Godelet <sebastian.godelet+github@gmail.com>
% Created on: Thu Apr 24 18:19:24 WEST 2014
%
%------------------------------------------------------------------------------%

:- module generic_math.

:- interface.

:- use_module int.
:- use_module float.
:- use_module integer.
:- use_module rational.

:- type bigint == integer.integer.

:- type unary_op_func(T) == (func(T) = T).

:- type bin_op_func(T) == (func(T, T) = T).
:- type bin_op_func(T1, T2) == (func(T1, T2) = T2).

:- inst bin_op_func_uo == (func(in, in) = uo is det).
:- inst bin_op_func_out == (func(in, in) = out is det).

:- typeclass scalar_generic_math(T) <= generic_math(T) where [
    func times_float `with_type` bin_op_func(T, float),
    % conversion functions
    func to_int(T) = int is semidet,
    func to_integer(T) = bigint is semidet,
    func to_float(T) = float,
    func to_rational(T) = rational.rational
].

:- func det_to_int(T) = int <= scalar_generic_math(T).
:- func det_to_integer(T) = bigint <= scalar_generic_math(T).

:- instance scalar_generic_math(int).
:- instance scalar_generic_math(float).
:- instance scalar_generic_math(bigint).
:- instance scalar_generic_math(rational.rational).

:- typeclass generic_math(T) where [
    func abs `with_type` unary_op_func(T),
    func min `with_type` bin_op_func(T),
    func max `with_type` bin_op_func(T),
    func times `with_type` bin_op_func(T),
    func divide `with_type` bin_op_func(T),
    func pow `with_type` bin_op_func(T),
    func add `with_type` bin_op_func(T),
    func substract `with_type` bin_op_func(T)
].

:- instance generic_math(int).
:- instance generic_math(float).
:- instance generic_math(bigint).
:- instance generic_math(rational.rational).

:- func T *  T = T <= generic_math(T).
:- func T /  T = T <= generic_math(T).
:- func T // T = T <= generic_math(T).
:- func T ** T = T <= generic_math(T).
:- func T +  T = T <= generic_math(T).
:- func T -  T = T <= generic_math(T).

%------------------------------------------------------------------------------%
%------------------------------------------------------------------------------%

:- implementation.

:- use_module math.
:- use_module std_util.
:- import_module exception.
:- import_module string.

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

%------------------------------------------------------------------------------%
% Instances for ints
%------------------------------------------------------------------------------%

:- instance scalar_generic_math(int) where [
    func(times_float/2) is int_times_float,
    func(to_int/1) is std_util.id,
    func(to_integer/1) is integer.integer,
    func(to_float/1) is float.float,
    func(to_rational/1) is rational.rational
].

:- func int_times_float
    `with_type` bin_op_func(int, float) `with_inst` bin_op_func_uo.

int_times_float(Int, Float) = float.'*'(float.float(Int), Float).

%------------------------------------------------------------------------------%

:- instance generic_math(int) where [
    func(abs/1) is int.abs,
    func(min/2) is int.min,
    func(max/2) is int.max,
    func(times/2) is int.(*),
    func(divide/2) is int.(//),
    func(pow/2) is int.pow,
    func(add/2) is int.(+),
    func(substract/2) is int.(-)
].

%------------------------------------------------------------------------------%
% Instances for floats
%------------------------------------------------------------------------------%

:- instance scalar_generic_math(float) where [
    func(times_float/2) is float.(*),
    func(to_int/1) is float_to_int,
    (to_integer(Float) = integer.integer(float_to_int(Float))),
    func(to_float/1) is std_util.id,
    (to_rational(_F) =
        throw(math.domain_error($pred ++ ": cannot cast to rational")))
].

:- func float_to_int(float) = int is semidet.

float_to_int(Float) = Floor :-
    Floor = float.floor_to_int(Float),
    Ceil = float.ceiling_to_int(Float),
    Floor = Ceil.

%------------------------------------------------------------------------------%

:- instance generic_math(float) where [
    func(abs/1) is float.abs,
    func(min/2) is float.min,
    func(max/2) is float.max,
    func(times/2) is float.(*),
    func(divide/2) is float.(/),
    func(pow/2) is math.pow,
    func(add/2) is float.(+),
    func(substract/2) is float.(-)
].

%------------------------------------------------------------------------------%
% Instances for scaled integers
%------------------------------------------------------------------------------%

:- instance scalar_generic_math(bigint) where [
    func(times_float/2) is integer_times_float,
    func(to_int/1) is integer.int,
    func(to_integer/1) is std_util.id,
    func(to_float/1) is integer.float,
    func(to_rational/1) is rational.from_integer
].

:- func integer_times_float
    `with_type` bin_op_func(bigint, float) `with_inst` bin_op_func_uo.

integer_times_float(Integer, Float) = float.'*'(integer.float(Integer), Float).

:- instance generic_math(bigint) where [
    func(abs/1) is integer.abs,
    func(min/2) is integer_min,
    func(max/2) is integer_max,
    func(times/2) is integer.(*),
    func(divide/2) is integer.(//),
    func(pow/2) is integer.pow,
    func(add/2) is integer.(+),
    func(substract/2) is integer.(-)
].

:- func integer_min
    `with_type` bin_op_func(bigint) `with_inst` bin_op_func_out.

integer_min(A, B) = Min :-
    ( integer.'=<'(A, B) -> Min = A ; Min = B ).

:- func integer_max
    `with_type` bin_op_func(bigint) `with_inst` bin_op_func_out.

integer_max(A, B) = Max :-
    ( integer.'>='(A, B) -> Max = A ; Max = B ).

%------------------------------------------------------------------------------%
% Instances for rationals
%------------------------------------------------------------------------------%
:- instance scalar_generic_math(rational.rational) where [
    (times_float(_R, _F) =
        throw(math.domain_error($pred ++ ": cannot cast to float"))),
    (to_int(_R) = throw(math.domain_error($pred ++ ": cannot cast to int"))),
    (to_integer(_R) =
        throw(math.domain_error($pred ++ ": cannot cast to integer"))),
        % XXX As in the rational library itself, this code can overflow
        % Although it might not need to.
    (to_float(Rational) =
        float.'/'(integer.float(rational.numer(Rational)),
                  integer.float(rational.denom(Rational)))),
    (func(to_rational/1)) is std_util.id
].

:- instance generic_math(rational.rational) where [
    func(abs/1) is rational.abs,
    func(min/2) is rational_min,
    func(max/2) is rational_max,
    func(times/2) is rational.(*),
    func(divide/2) is rational.(/),
    (pow(_R, _Exp) = throw(math.domain_error($pred ++ ": not implemented"))),
    func(add/2) is rational.(+),
    func(substract/2) is rational.(-)
].

:- func rational_min
    `with_type` bin_op_func(rational.rational) `with_inst` bin_op_func_out.

rational_min(A, B) = Min :-
    ( rational.'=<'(A, B) -> Min = A ; Min = B ).

:- func rational_max
    `with_type` bin_op_func(rational.rational) `with_inst` bin_op_func_out.

rational_max(A, B) = Max :-
    ( rational.'>='(A, B) -> Max = A ; Max = B ).

%------------------------------------------------------------------------------%
:- end_module generic_math.
%-*- Mode: Mercury; column: 80; indent-tabs-mode: nil; tabs-width: 4 -*-
%------------------------------------------------------------------------------%
