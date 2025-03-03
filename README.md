# Fully Custom Code Generators

This repo is an example of the ideas presented at [Code BEAM America](https://codebeamamerica.com/) in 2025 covering the benefits and strategies of writing custom code generators.

The generator is setup to create two schemas, a single context, a single liveview, and the related tests from a input file.

We hope to highlight some of the approaches we've found useful writing custom generators in other projects, such as:
- using Elixir files for input
- helper files to keep complex logic out of the templates and keep it reusable
- starting from "golden" source files and extracting the templates from there
- leveraging the mix formatter to avoid spacing difficulties
- and more, go check out the talk recording when it's posted! (I plan to add a link when it's available)

## How to run the generator

Run `mix gen.resource generator_inputs/quest.ex` and you can run the app & tests!
