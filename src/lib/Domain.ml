module S = Syntax

open CoolBasis
open Bwd 
open TLNat

type env = {locals : con bwd}


and ('n, 't, 'o, 'sp) clo = 
  | Clo : {bdy : 't; env : env; spine : 'sp}  -> ('n, 't, 'o, 'sp) clo
  | ElClo : ('n, S.t, con, frm list) clo -> ('n, S.tp, tp, unit) clo
  | ConstClo : 'o -> ('n, 't, 'o, 'sp) clo

and 'n tm_clo = ('n, S.t, con, frm list) clo
and 'n tp_clo = ('n, S.tp, tp, unit) clo


and con =
  | Lam of ze su tm_clo
  | Cut of {tp : tp; cut : cut * lazy_con ref option}
  | Zero
  | Suc of con
  | Pair of con * con
  | Refl of con
  | CodeNat

and lazy_con = [`Do of con * frm list | `Done of con]

and cut = hd * frm list 

and tp =
  | Nat
  | Id of tp * con * con
  | Pi of tp * ze su tp_clo
  | Sg of tp * ze su tp_clo
  | Univ
  | El of cut 

and hd =
  | Global of Symbol.t 
  | Var of int (* De Bruijn level *)

and frm = 
  | KAp of nf
  | KFst 
  | KSnd
  | KNatElim of ze su tp_clo * con * ze su su tm_clo
  | KIdElim of ze su su su tp_clo * ze su tm_clo * tp * con * con

and nf = Nf of {tp : tp; con : con}


let pp_tp fmt _ = Format.fprintf fmt "<tp>"
let pp_con fmt _ = Format.fprintf fmt "<con>"

let push frm (hd, sp) = 
  hd, sp @ [frm]

let mk_var tp lev = Cut {tp; cut = (Var lev, []), None}