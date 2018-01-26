type json =
  [ `Null
  | `Bool of bool
  | `Float of float
  | `String of string
  | `List of json list
  | `Assoc of (string * json) list
  ]

module type IO = sig
  type 'a t

  val return : 'a -> 'a t
  val (>>=)  : 'a t -> ('a -> 'b t) -> 'b t
end

module type Json_encoder_decoder = sig
  module IO : IO

  type nonrec json = json

  val decode : reader:(Bytes.t -> int -> int IO.t) -> (json, string) result IO.t
  val decode_exn : reader:(Bytes.t -> int -> int IO.t) -> json IO.t
  val decode_string : string -> (json, string) result IO.t
  val decode_string_exn : string -> json IO.t

  val encode : writer:(Bytes.t -> int -> unit IO.t) -> json -> (unit, string) result IO.t
  val encode_exn : writer:(Bytes.t -> int -> unit IO.t) -> json -> unit IO.t
  val encode_string : json -> (string, string) result IO.t
  val encode_string_exn : json -> string IO.t
  val encode_string_hum : json -> (string, string) result IO.t
end


module Make(IO : IO) : Json_encoder_decoder with module IO := IO
