type atom = string

and guard = unit

and name =
  | Var_name of atom
  | Atom_name of atom
  | Macro_name of atom
  | Qualified_name of { n_mod : atom; n_name : atom }

and map_field = { mf_name : atom; mf_value : expr }

and case_branch = { cb_pattern : pattern; cb_expr : expr }

and let_binding = { lb_lhs : pattern; lb_rhs : expr }

and literal =
  | Lit_integer of string
  | Lit_char of string
  | Lit_binary of string
  | Lit_float of string
  | Lit_atom of string

and expr =
  | Expr_let of let_binding * expr
  | Expr_name of name
  | Expr_literal of literal
  | Expr_fun_ref of atom
  | Expr_apply of fun_apply
  | Expr_map of map_field list
  | Expr_list of expr list
  | Expr_case of expr * case_branch list
  | Expr_tuple of expr list
  | Expr_fun of fun_decl

and pattern =
  | Pattern_ignore
  | Pattern_binding of atom
  | Pattern_tuple of pattern list
  | Pattern_list of pattern list
  | Pattern_map of (atom * pattern) list
  | Pattern_match of literal

and fun_apply = { fa_name : expr; fa_args : expr list }

and fun_case = { fc_lhs : pattern list; fc_guards : guard list; fc_rhs : expr }

and fun_decl = { fd_name : atom; fd_arity : int; fd_cases : fun_case list }

and record_field = { rf_name : atom; rf_type : type_kind }

and variant_constructor =
  | Constructor of { vc_name : atom; vc_args : type_kind list }
  | Extension of type_kind

and type_constr = { tc_name : name; tc_args : type_kind list }

and type_kind =
  | Type_function of type_kind list
  | Type_constr of type_constr
  | Type_variable of atom
  | Type_tuple of type_kind list
  | Type_record of { fields : record_field list }
  | Type_variant of { constructors : variant_constructor list }

and type_visibility = Opaque | Visible

and type_decl = {
  typ_kind : type_kind;
  typ_visibility : type_visibility;
  typ_name : atom;
  typ_params : atom list;
}

(** An exported symbol in an Erlang module. This could be a function or a type.
    See:
      http://erlang.org/doc/reference_manual/modules.html for missing fields.
      http://erlang.org/doc/reference_manual/typespec.html
 *)
and export_type = Export_function | Export_type

and export = { exp_type : export_type; exp_name : atom; exp_arity : int }

and t = {
  file_name : string;
  behaviour : atom option;
  module_name : atom;
  ocaml_name : atom;
  exports : export list;
  types : type_decl list;
  functions : fun_decl list;
}

val make :
  name:string ->
  ocaml_name:string ->
  exports:export list ->
  types:type_decl list ->
  functions:fun_decl list ->
  t

val make_fn_export : atom -> int -> export

val make_type_export : atom -> int -> export

val make_named_type :
  atom -> atom list -> type_kind -> type_visibility -> type_decl

val type_any : type_kind

val find_fun_by_name : module_:t -> string -> fun_decl option