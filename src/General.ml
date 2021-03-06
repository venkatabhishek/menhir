(**************************************************************************)
(*                                                                        *)
(*  Menhir                                                                *)
(*                                                                        *)
(*  François Pottier, INRIA Paris-Rocquencourt                            *)
(*  Yann Régis-Gianas, PPS, Université Paris Diderot                      *)
(*                                                                        *)
(*  Copyright 2005-2015 Institut National de Recherche en Informatique    *)
(*  et en Automatique. All rights reserved. This file is distributed      *)
(*  under the terms of the GNU Library General Public License, with the   *)
(*  special exception on linking described in file LICENSE.               *)
(*                                                                        *)
(**************************************************************************)

(* --------------------------------------------------------------------------- *)

(* Lists. *)

let rec take n xs =
  match n, xs with
  | 0, _
  | _, [] ->
      []
  | _, (x :: xs as input) ->
     let xs' = take (n - 1) xs in
     if xs == xs' then
       input
     else
       x :: xs'

let rec drop n xs =
  match n, xs with
  | 0, _ ->
      xs
  | _, [] ->
      []
  | _, _ :: xs ->
      drop (n - 1) xs

let rec uniq1 cmp x ys =
  match ys with
  | [] ->
      []
  | y :: ys ->
      if cmp x y = 0 then
        uniq1 compare x ys
      else
        y :: uniq1 cmp y ys

let uniq cmp xs =
  match xs with
  | [] ->
      []
  | x :: xs ->
      x :: uniq1 cmp x xs

let weed cmp xs =
  uniq cmp (List.sort cmp xs)

(* --------------------------------------------------------------------------- *)

(* Streams. *)

type 'a stream =
    'a head Lazy.t

and 'a head =
  | Nil
  | Cons of 'a * 'a stream

(* The length of a stream. *)

let rec length xs =
  match Lazy.force xs with
  | Nil ->
      0
  | Cons (_, xs) ->
      1 + length xs

(* Folding over a stream. *)

let rec foldr f xs accu =
  match Lazy.force xs with
  | Nil ->
      accu
  | Cons (x, xs) ->
      f x (foldr f xs accu)

