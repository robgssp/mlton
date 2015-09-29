(* Copyright (C) 2012 Matthew Fluet.
 * Copyright (C) 1999-2007 Henry Cejtin, Matthew Fluet, Suresh
 *    Jagannathan, and Stephen Weeks.
 * Copyright (C) 1997-2000 NEC Research Institute.
 *
 * MLton is released under a BSD-style license.
 * See the file MLton-LICENSE for details.
 *)

functor Tyvar (S: TYVAR_STRUCTS): TYVAR =
struct

open S

structure V = Id (val noname = "x")

type t = { id: V.t, eq: bool }

val noname = V.noname

local
   fun make (f: V.t -> 'a): t -> 'a = f o #id
in
   val clear = make V.clear
   val clearPrintName = make V.clearPrintName
   val hash = make V.hash
   val originalName = make V.originalName
   val plist = make V.plist
end

fun tacks eq = if eq then "''" else "'"

fun stringEq s = String.hasPrefix (s, {prefix = "''"})
fun dropTacks s = if stringEq s
                  then String.extract (s, 2, NONE)
                  else String.extract (s, 1, NONE)

val bogus = { id = V.bogus, eq = false }
fun equals ({ id = id1, ... }: t,
            { id = id2, ... }: t) = V.equals (id1, id2)
fun fromString s = { id = V.fromString (dropTacks s), eq = stringEq s }
fun new { id, eq } = { id = V.new id, eq = eq }
fun newNoname () = { id = V.newNoname (), eq = false }
fun newString s = { id = V.newString (dropTacks s), eq = stringEq s }
val printNameAlphaNumeric = V.printNameAlphaNumeric
fun setPrintName ({ id, eq }, name) = V.setPrintName (id, name)
fun toString { id, eq } = tacks eq ^ V.toString id 
fun layout { id, eq } =
  Layout.seq [ Layout.str (tacks eq), V.layout id ]

fun isEquality _ = false
fun newNonameEq eq = { id = V.newNoname (), eq = eq }

end
