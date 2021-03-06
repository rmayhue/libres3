(*
 * Copyright (c) 2014 marklrh <marklrh@gmail.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

(** Async DNS resolution logic *)

open Core.Std
open Async.Std

type commfn = {
  txfn : Dns.Buf.t -> unit Deferred.t;
  rxfn : (Dns.Buf.t -> Dns.Packet.t option) -> Dns.Packet.t Deferred.t;
  timerfn : unit -> unit Deferred.t;
  cleanfn : unit -> unit Deferred.t;
}

val resolve :
  (module Dns.Protocol.CLIENT) ->
  ?dnssec:bool ->
  commfn ->
  Dns.Packet.q_class ->
  Dns.Packet.q_type ->
  Dns.Name.domain_name -> Dns.Packet.t Deferred.t

val gethostbyname :
  ?q_class:Dns.Packet.q_class ->
  ?q_type:Dns.Packet.q_type ->
  commfn ->
  string ->
  Ipaddr.t list Deferred.t
