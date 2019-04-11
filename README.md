# Stone Tech Challenge - Financial System

Financial System made in elixir for the [Stone Tech Challenge](https://github.com/stone-payments/tech-challenge).

## Project

The project is made to complete a challenge of creating a Financial System in compliance with [ISO 4217](https://pt.wikipedia.org/wiki/ISO_4217) that is able to perform basic functions like transfers between accounts(with possibility to split) and exchange currency. 

Due to Floats having arithmetic problems, this project uses Integers to deal with money, always using the two last digits as cents. 

Also, to deal with money and stay in compliance with [ISO 4217](https://pt.wikipedia.org/wiki/ISO_4217), the library [Money](https://github.com/elixirmoney/money) was used.

## Dependencies

[Credo](https://github.com/rrrene/credo) - For code consistency through static code analysis.
[ExCoveralls](https://github.com/parroty/excoveralls) - Reports test coverage statistics, showing wich lines of code are actually being tested.
[Money](linhttps://github.com/elixirmoney/moneyk) - To help us deal with money in diferent currencies.
[ExDoc](https://github.com/elixir-lang/ex_doc) - Produces HTML documentation.
[Earmark](https://github.com/pragdave/earmark) - Markdown parser for Elixir, used by ExDoc to convert the documentation inside `@moduledoc` and `@doc`.

## Usage

You'll need to have [Elixir Installation](https://elixir-lang.org/install.html) completed on your computer.

After that, you can clone this project and run the following command to install all the dependencies.
`mix deps.get`

Then, you'll be ready run to all these commands:
`iex -S mix` to run your application.
`mix test` to perform unitary tests.
`MIX_ENV=test mix coveralls` to show coverage information.
`MIX_ENV=test mix coveralls.detail` displays your coverage test in each file and highlighting the lines that are executed(green) and those that aren't(red).

## Documentation
For documentation, run `mix docs` to generate an HTML page with all the documentation of the project.

## Continuous Integration
This project also uses [Travis CI](www.travis-ci.com) for continuous integration.

## Useful links
As a fresh beginner in Elixir, I've crossed with many useful pages that helped me understand the language and create this project.
* [Elixir School](https://elixirschool.com/pt/)
* [O Guia de Estilo Elixir](https://elixirschool.com/pt/)
* [Boas Práticas na Stone](https://github.com/stone-payments/stoneco-best-practices/blob/master/README_pt.md)
* [Why Elixir in Banking](https://medium.com/margobank/why-elixir-546427542c)
* [How to Read Specification in Elixir](https://stackoverflow.com/questions/54969816/how-to-read-specification-in-elixir)
* [What Does Type T Mean in Elixir](https://stackoverflow.com/questions/29977776/what-does-type-t-module-mean-in-elixir)
* [Typespecs and Behaviours](https://elixir-lang.org/getting-started/typespecs-and-behaviours.html)
* [Struct para Encomenda](https://medium.com/@alvaroaze/elixir-structs-para-encomenda-e8949bd7df90)
* [Why is Useful to Have an Atom Type Like in Elixir-Erlang](https://stackoverflow.com/questions/32261500/why-is-useful-to-have-a-atom-type-like-in-elixir-erlang)
* [Errors and Exceptions](https://learnyousomeerlang.com/errors-and-exceptions)
* [Money Library Documentation](https://hexdocs.pm/money/Money.html)
* [Building an Elixir Project in Travis-CI](https://docs.travis-ci.com/user/languages/elixir/)
