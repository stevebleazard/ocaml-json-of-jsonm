# ocaml-json-of-jsonm

json_of_jsonm_lib is built on top of jsom and converts text to and from the
type `json`. The library has the following features:
* The `json` type is compatible with and a subset of yojson's `json` type
* Provides string encoding and decoding
* A standard type `t` interface is provided in addition to the `json` type
* Both result and exception based functions are provided
* Supports encoding and decoding to and from a channel
* The Json_encoder_decoder functor allows additional IO mechanisms, including Async,
  to be defined easily. Note the Async version is not included to prevent
  dependencies on the Async libraries.

# Example usage
## Basic string
```ocaml
open Json_of_jsonm_lib

let () =
  let json = Json_string.of_string_exn "{ \"a\": 1 }" in
  let json_s = Json_string.to_string_exn json in
  Printf.printf "%s\n" json_s
```

Note that unlike the jsonm encoder the json_of_jsonm_lib encoder detects bad
floats (NaN and Inf) and returns an error, in this case the to_string_exn function
is used to generate an exception instead.

## Channel input and output
```ocaml
open Json_of_jsonm_lib

let () =
  let inp = open_in "./x" in
  let outp = open_out "./z" in
  Json_channel.json_of_channel_exn inp
  |> Json_channel.json_to_channel_exn outp
```

## Using the Jsom_encoder_decoder functor
The following is an example of implementing the Async version using the
`Jsom_encoder_decoder` functor
```ocaml
open Async
open Json_of_jsonm_lib

module Json_async = struct
  module Json_of_async = Json_of_jsonm_monad.Make(struct
      type 'a t = 'a Deferred.t

      let return = Deferred.return
      let (>>=) = Deferred.Monad_infix.(>>=)
    end)


  let reader rd buf size =
    Reader.read rd ~len:size buf
    >>= function
    | `Eof -> return 0
    | `Ok len -> return len

  let read rd =
    let reader = reader rd in
    Json_of_async.decode ~reader

  let read_exn rd =
    let reader = reader rd in
    Json_of_async.decode_exn ~reader

  let write wr =
    let writer buf size = Writer.write ~len:size wr buf |> return in
    Json_of_async.encode ~writer

  let write_exn wr =
    let writer buf size = Writer.write ~len:size wr buf |> return in
    Json_of_async.encode_exn ~writer
end
```
The following shows a sample usage of the module
```ocaml
Reader.open_file "./x"
>>= fun rd -> Json_async.read_exn rd
>>= fun json -> Writer.open_file "./z"
>>= fun wr -> Json_async.write wr json
```
