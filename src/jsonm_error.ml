type t = Jsonm.error

let to_string err =
  let buf = Buffer.create 64 in
  let to_b = Format.formatter_of_buffer buf in
  Format.fprintf to_b "%a" Jsonm.pp_error err;
  Format.pp_print_flush to_b ();
  Buffer.contents buf
