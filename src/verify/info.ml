open Cmdliner

let make ~name ~doc ~description =
  let man =
    [
      `S "DESCRIPTION";
      `P description;
      `S "SEE ALSO";
      `P "ocaml(1) erlang";
      `S "AUTHORS";
      `P "Leandro Ostera.";
      `S "LICENSE";
      `P "Copyright (C) 2020-present, Abstract Machines Lab Sweden AB";
      `P "Caramel is licensed under Apache License 2.0";
    ]
  in
  Term.info name ~version:"" ~doc ~man
