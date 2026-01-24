local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
-- key:
-- s: a snippet, the
-- i: insert node with index, a snippet variable you jump through with an order, see https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#jump-index
--    exit with i(0)
-- t: text node, for inserting text, see https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#textnode
--    multiline happens with a table of parameters t({ "one line", "and another" })
-- f: function node, pretty advanced, for parameterized behavior: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#functionnode
-- c: choice noce, for selecting among various options: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#choice_node
-- sn: snippet node, for using a snippet as a choice, see https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#snippetnode

-- Function that returns a choiceNode with visibility options
local function visibility_choice(position)
  return c(position, {
    t(""), -- private (no modifier)
    t("pub "), -- public
    t("pub(crate) "), -- crate visibility
    t("pub(super) "), -- super visibility
  })
end

return {
  -- test creates a basic test function for unit testing
  s("test", {
    t({ "#[test]", "" }),
    t({ "fn " }),
    i(1, "name"),
    t("_should_"),
    i(2, "do_what"),
    t({ "() {", "  " }),
    i(0, "todo!()"),
    t({ "", "}" }),
  }),
  -- modtest creates a test module for adding unit tests
  s("modtest", {
    t({ "#[cfg(test)]", "mod tests {" }),
    t("  "),
    i(0),
    t({ "", "}" }),
  }),
  -- take creates a take function that returns a variable
  s("take", {
    visibility_choice(1),
    t("fn take() -> ("),
    i(2),
    t({ ") {" }),
    t("  "),
    i(0),
    t({ "", "}" }),
  }),
  -- get creates a function that gets a reference type
  s("getr", {
    visibility_choice(1),
    t("fn "),
    i(2, "name"),
    t("(&self) -> &"),
    i(3),
    t({ "", "  &self." }),
    i(2),
    t({ "}" }),
    i(0),
  }),
  -- getv creates a function that gets a copy value (without a reference)
  -- TODO: fix once getr is working
  s("getv", {
    visibility_choice(1),
    t("fn get"),
    i(2),
    t("(&self) -> "),
    i(3),
    t({ "", "  self." }),
    i(4),
    t(";", "}"),
    i(0),
  }),
  -- geto creates a function that gets an option value
  -- TODO: fix once getr is working
  s("geto", {
    visibility_choice(1),
    t("fn get"),
    i(2),
    t("(&self) -> "),
    i(3),
    t({ "", "  self.as_ref()" }),
    i(4),
    t(";", "}"),
    i(0),
  }),
  -- fgetos creates a function that gets an option value
  -- TODO: fix once getr is working
  s("getos", {
    visibility_choice(1),
    t("fn get"),
    i(2),
    t({ "(&self) -> Option<&str> {" }),
    t("  self."),
    i(3),
    t(".as_ref().map(String::as_str);", "}"),
    i(0),
  }),
  -- fgetos creates a function that gets an option value
  -- TODO: fix once getr is working
  s("geti", {
    visibility_choice(1),
    t("fn get"),
    i(2),
    t("(&self) -> impl Iterator<Item = "),
    i(3),
    t({ "> {" }),
    t("  self."),
    i(3),
    t(".iter();", "}"),
    i(0),
  }),
  -- struct creates a structure
  s("struct", {
    t({ "#[derive(Debug, Clone)]" }),
    visibility_choice(1),
    t("struct "),
    i(2),
    t({ " }" }),
    t("  "),
    i(3),
    t({ "", "}", "" }),
    t("impl "),
    i(2),
    t({ "{" }),
    i(0),
    t({ "", "}" }),
  }),
  s("dern", {
    t("#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, Eq)]"),
  }),
  s("muu", {
    t("#[must_use]"),
  }),
  -- iinto allows for an impl Into<T> where T is a variable you provide
  s("iinto", {
    t("impl Into<"),
    i(1),
    t({ ">" }),
    i(0),
  }),
  s("mustuse", {
    t("#[must_use]"),
  }),
}
