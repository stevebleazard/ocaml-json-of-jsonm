module Json_of_string : module type of Json_of_jsonm_monad.Make(struct
    type 'a t = 'a

    let return _ = failwith "error"
    let (>>=) _ _ = failwith "error"
  end)


val json_of_string : string -> (Json_of_string.json, string) result
val json_of_string_exn : string -> Json_of_string.json
val json_to_string : Json_of_string.json -> (string, string) result
val json_to_string_exn : Json_of_string.json -> string
val json_to_string_hum : Json_of_string.json -> (string, string) result

type t = Json_of_string.json

val of_string : string -> (t, string) result
val of_string_exn : string -> t
val to_string : t -> (string, string) result
val to_string_exn : t -> string
