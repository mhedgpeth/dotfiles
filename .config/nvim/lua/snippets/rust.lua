return {
  s("test", {
    t({ "#[test]", "" }),
    t({ "fn should_" }),
    i(1, "do_something"),
    t({ "() {", "\t" }),
    i(0, "todo!()"),
    t({ "}" }),
  }),
}
