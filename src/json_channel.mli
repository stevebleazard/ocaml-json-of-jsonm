module Json_of_channel : Json_of_jsonm_monad.Json_encoder_decoder
  with type 'a IO.t = 'a

type json = Json_of_channel.json

(** [json_of_channel] - decode a text stream from [in_channel] to a [json] type *)
val json_of_channel : in_channel -> (json, string) result

(** [json_of_channel_exn] - the same as [json_of_channel] but raises on error *)
val json_of_channel_exn : in_channel -> json

(** [json_to_channel] - encode a [json] type to channel [out_channel] *)
val json_to_channel : out_channel -> json -> (unit, string) result

(** [json_to_channel_exn] - the same as [json_to_channel] but raises on error *)
val json_to_channel_exn : out_channel -> json -> unit
