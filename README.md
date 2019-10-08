# Wormwood

[![hex](https://img.shields.io/hexpm/v/wormwood.svg)](https://hex.pm/packages/wormwood)
![Actions Status](https://github.com/tinfoil/wormwood/workflows/Elixir%20CI/badge.svg)
[![license-mit](https://img.shields.io/badge/license-MIT-blue)](https://github.com/tinfoil/wormwood/blob/master/LICENSE)
![graph-ql](https://img.shields.io/badge/%E2%99%A5-graphql-ff69b4)

Wormwood is a tiny library to aid in testing GraphQL queries against an Absinthe schema. It allows you to test your query documents inside ExUnit test modules, and requires no HTTP requests to occur during testing.

#### Why Wormwood?

We believe that testing GraphQL queries should be easy. Wormwood lets you scope a test module to one single document (paired with a schema) with ease, and helps to remove any of the boilerplate code such a task would introduce.

With Wormwood, you simply load your document at the top of your module, and query it using a standard function. 

That's it!

----------

### Installation

Install from [Hex.pm](https://hex.pm/packages/wormwood):

```elixir
def deps do
  [{:wormwood, "~> 0.1.0"}]
end
```

----------

### Getting Started

1. Install Wormwood!
2. `use` the Wormwood GQLCase inside the test module...

	```elixir
	defmodule MyCoolApplication.MyTestCase do
	  use ExUnit.Case
	  use Wormwood.GQLCase
	  #...
	```	
3. Use the Wormwood `load_gql/2` macro to specify your schema and load your GraphQL document...

	```elixir
   defmodule MyCoolApplication.MyTestCase do
	  #...
	  
	  load_gql MyCoolApplication.MyAbsintheSchema, "assets/js/queries/MyQuery.gql"
	  
	  #...
	```

4. Your document and schema are ready to go, you can now call `query_gql/1` inside any of your test statements to execute the loaded document against the specified schema. You can pass `options` to this call, please refer to the [Absinthe docs](https://hexdocs.pm/absinthe/Absinthe.html#run/3-options) for more information on options.

	For Example:
	
	```elixir
	#...
	
	test "should be a valid query" do
	  result = query_gql(variables: %{}, context: %{:current_user => some_user})
	  assert {:ok, _query_data} = result
	end
	
	#...
	```


##### Full example from the above steps:

```elixir
defmodule MyCoolApplication.MyTestCase do
  use ExUnit.Case
  use Wormwood.GQLCase
	  
  load_gql MyCoolApplication.MyAbsintheSchema, "assets/js/queries/MyQuery.gql" 
	  
  test "should be a valid query" do
    result = query_gql(variables: %{}, context: %{:current_user => some_user})
    assert {:ok, _query_data} = result
  end
end
```

----------

### Examples

Check out `lib/examples/` for a very simple, static, and self contained Absinthe schema. 

You can also dig around in `test/examples/` for simple tests that query against that sample schema using Wormwood.

----------

### License

Copyright © 2019 [Tinfoil Security Inc.](https://www.tinfoilsecurity.com/go/opensource)

This project is [MIT licensed](https://github.com/tinfoil/wormwood/blob/master/LICENSE).

----------

<p align="center">
	Made with ❤️ and 🔐 by Tinfoil Security
</p>
