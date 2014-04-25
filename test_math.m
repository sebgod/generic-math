%------------------------------------------------------------------------------%
% File: test_math.m
% Main author: Sebastian Godelet <sebastian.godelet+github@gmail.com>
% Created on: Fri Apr 25 19:52:07 CEST 2014
% vim: ft=mercury ff=unix ts=4 sw=4 et
%
%------------------------------------------------------------------------------%

:- module test_math.

:- interface.

:- import_module io.

:- pred main(io::di, io::uo) is det.

%------------------------------------------------------------------------------%
%------------------------------------------------------------------------------%

:- implementation.

:- import_module generic_math.

%------------------------------------------------------------------------------%

main(!IO) :-
    Four = 2 + 2,
    io.print("2 + 2 = ", !IO),
    io.write_line(Four, !IO),
    Square = det_to_integer(2.0 ** to_float(2)),
    io.print("2.0 ** 2.0 = ", !IO),
    io.write_line(Square, !IO).

%------------------------------------------------------------------------------%
% -*- Mode: Mercury; column: 80; indent-tabs-mode: nil; tabs-width: 4 -*-
%------------------------------------------------------------------------------%
