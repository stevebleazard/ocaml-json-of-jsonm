module Json_of_channel : module type of Json_of_jsonm_monad.Make(struct
    type 'a t = 'a

    let return _ = failwith "error"
    let (>>=) _ _ = failwith "error"
  end)


val json_of_channel : in_channel -> (Json_of_channel.json, string) result
val json_of_channel_exn : in_channel -> Json_of_channel.json
val json_to_channel : out_channel -> Json_of_channel.json -> (unit, string) result
val json_to_channel_exn : out_channel -> Json_of_channel.json -> unit

