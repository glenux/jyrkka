open Core.Std

type cli_action_t = 
  | CliNone
  | CliBuild
  | CliLoad 

type cli_config_t = {
  input_file: string ;
  verbose : bool ;
}

type error =
  | Unknown of string
  | Wrong of string * string * string  (* option, actual, expected *)
  | Missing of string
  | Message of string

exception Stop of error;; (* used internally *)

let parse_cmdline () = 
  let open Arg in

  (* default values *)
  let conf_verbose    = ref false
  and conf_input_file = ref ""
  and conf_help       = ref false
  in

  let usage = "Usage: " ^ Sys.argv.(0) ^ " [options...]\n\nOptions:\n"
  and speclist = [
    ("-v"    , Set conf_verbose          , "\t\tSet somebool to true");
    ("-i"    , Set_string conf_input_file, "FILE\tInput configuration FILE") ;
  ]
  and error_fn arg = raise (Bad ("Bad argument : " ^ arg)) 
  in 

  (* Read the arguments *)
  parse speclist error_fn usage ;

  (* Return a value *)
  { 
    input_file = !conf_input_file ;
    verbose    = !conf_verbose
  }

let run_cmdline config =
  Printf.printf "input_file: %s\n" config.input_file ;
  ()

let _ = 
  parse_cmdline ()
  |> run_cmdline ;
  exit 0

