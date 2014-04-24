%------------------------------------------------------------------------------%
% File: generic_math.m
% Main author: Sebastian Godelet <sebastian.godelet+github@gmail.com>
% Created on: Thu Apr 24 18:19:24 WEST 2014
% vim: ft=mercury ff=unix ts=4 sw=4 et
%
%------------------------------------------------------------------------------%

:- module generic_math.

:- interface.

:- import_module int.
:- import_module float.

:- typeclass generic_math(T) where [
    func times(T, T) = T,
    func pow(T, T) = T,
    func add(T, T) = T
].

:- instance generic_math(int).
:- instance generic_math(float).

%------------------------------------------------------------------------------%
%------------------------------------------------------------------------------%

:- implementation.

:- use_module math.


:- instance generic_math(int) where [
    func(times/2) is int.times,
    func(divide/2) is int.(/),
    func(pow/2) is int.pow,
    func(add/2) is int.(+)
].

:- instance generic_math(float) where [
    func(times/2) is float.(*),
    func(divide/2) is float.(/),
    func(pow/2) is math.pow,
    func(add/2) is float.(+)
].

%------------------------------------------------------------------------------%

%------------------------------------------------------------------------------%
:- end_module generic_math.
%-*- Mode: Mercury; column: 80; indent-tabs-mode: nil; tabs-width: 4 -*-
%------------------------------------------------------------------------------%
