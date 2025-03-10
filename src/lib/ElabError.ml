module CS = ConcreteSyntax
module D = Domain
module S = Syntax
open Basis

include ElabErrorData.Data

module Fmt = Format

let pp_connective fmt =
  function
  | `Cof ->
    Format.fprintf fmt "cof"
  | `Dim ->
    Format.fprintf fmt "dim"
  | `Pi ->
    Format.fprintf fmt "pi"
  | `Sg ->
    Format.fprintf fmt "sg"
  | `Univ ->
    Format.fprintf fmt "univ"
  | `Nat ->
    Format.fprintf fmt "nat"
  | `Circle ->
    Format.fprintf fmt "circle"
  | `Sub ->
    Format.fprintf fmt "sub"
  | `Prf ->
    Format.fprintf fmt "prf"
  | `El ->
    Format.fprintf fmt "el"
  | `ElV ->
    Format.fprintf fmt "V"
  | `ElHCom ->
    Format.fprintf fmt "hcom"

let pp fmt =
  function
  | UnboundVariable id ->
    Fmt.fprintf fmt "Unbound variable %a" Ident.pp id
  | ExpectedEqual (ppenv, tp, tm0, tm1, _) ->
    Fmt.fprintf fmt
      "Expected @[<hv>%a =@;%a@;: %a@]"
      (S.pp ppenv) tm0
      (S.pp ppenv) tm1
      (S.pp_tp ppenv) tp
  | ExpectedEqualTypes (ppenv, tp0, tp1, _) ->
    Fmt.fprintf fmt
      "Expected @[<hv>%a =@;%a@]"
      (S.pp_tp ppenv) tp0
      (S.pp_tp ppenv) tp1
  | ExpectedConnective (conn, ppenv, tp) ->
    Fmt.fprintf fmt
      "Head connective mismatch, expected %a but got %a"
      pp_connective conn
      (S.pp_tp ppenv) tp
  | ExpectedSynthesizableTerm orig ->
    Format.fprintf fmt
      "@[Type annotation required for@,@[<hv> %a@]@]"
      CS.pp_con_ orig
  | InvalidTypeExpression cs ->
    Fmt.fprintf fmt
      "Invalid type expression: %a"
      CS.pp_con cs
  | MalformedCase ->
    Fmt.fprintf fmt "Malformed case"
  | CannotEliminate (ppenv, tp) ->
    Fmt.fprintf fmt
      "Cannot eliminate element of type %a"
      (S.pp_tp ppenv) tp
  | ExpectedSimpleInductive (ppenv, tp) ->
    Fmt.fprintf fmt
      "Expected simple inductive type but found %a"
      (S.pp_tp ppenv) tp
  | ExpectedDimensionLiteral n ->
    Fmt.fprintf fmt
      "Expected dimension literal 0 or 1, but got %i" n
  | ExpectedTrue (ppenv, cof) ->
    Fmt.fprintf fmt
      "Expected true cofibration: %a"
      (S.pp ppenv) cof
  | VirtualType ->
    Fmt.fprintf fmt "Virtual type (dim, cof, etc.) cannot appear in this position"
  | HoleNotPermitted (ppenv, tp) ->
    Fmt.fprintf fmt
      "Holes of type %a are not permitted"
      (S.pp_tp ppenv) tp


exception ElabError of t * LexingUtil.span option

let _ =
  PpExn.install_printer @@ fun fmt ->
  function
  | ElabError (err, _loc) ->
    pp fmt err
  | _ ->
    raise PpExn.Unrecognized
