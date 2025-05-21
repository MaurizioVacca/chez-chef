# Chez-Chef demo project

Chez-Chef is a recipe finder based on [The Meal DB](https://www.themealdb.com/api.php), developed as technical assessment.
It's a single page application fully powered by Elm, using a minimal set of libraries to achieve that, in order to 
showcase:

- how far Elm can go;
- coding style;
- architectural choices.

## Installation

> [!IMPORTANT]  
> This project uses Volta to manage node and npm versions.
> Please be sure to install Volta, or check package.json to see what node and npm version should be used.

After downloading the project, from the root, just run

```bash
# Install dev dependencies
npm install

# Build CSS
npm run tailwind:build

# Start the development server
npm run dev
```

Now the application should be running at http://localhost:8000. If you prefer, you can see it live
[at Netlify](https://candid-cocada-39ab01.netlify.app/).

## Implementation choices and overall architecture

The structure of the project is heavily inspired by popular Elm frameworks such as Elm Pages and Elm Land. It uses
a page routing architecture, where the `Route.elm` module maps 1:1 the content of `Pages` directory, within an exception
for `/favourites` route, which re-uses search page template.

As mentioned previously, the project has been built with nothing but Elm (aside from a JavaScript port to access local storage).
This allows using the compiler error messages as guidelines during the development, starting from modeling data structures
and linking them together.

This kind of "type-driven" development can be achieved because Elm data structures are immutable and, like Ocaml and Haskell,
pure functional programming allows us for correctness and formal verification.

Application models and types are placed under the `src` directory, within the `Main.elm` module. These are

```
- Category.elm
- Ingredient.elm
- Recipe.elm
```

where all the endpoints, decoders, and encoders are defined. The `Ui` directory contains all
the reusable views, while `Utils.elm` module contains generic helpers and re-usable functions.

### Libraries used

For the most part, the project uses core Elm libraries which are required to fetch data (such `elm/json` and `elm/http`).
Two of those are worth-mentioning, though:

- `NoRedInk/elm-json-decode-pipeline`, which makes JSON decoding easier when dealing with big payloads with more than 8 fields;
- `elm/svg`, which makes possible to create SVG idiomatically, as we already do for HTML. By doing so, we can 
    import SVG as functions, and fully customize them (such passing `currentColor` for example).

Icons have been ported from [Feather Icons](https://feathericons.com/), aside from the logo, which is a creation of mine.

### Why not using a meta-framework?

In a real-world scenario, I **definitely** would, especially if multiple people are involved in the project. On the other hand,
meta-frameworks remove a lot of complexity, and I thought it would have been harder to judge "coding skills"
if most of the problems are solved by the framework itself (such routing and sharing state).

Still, this project is a "poor-man meta-framework" where the concepts used on more complete projects
are still applied and showcasing how some technical solutions are achieved.

## Testing strategy

I've used Cypress to grant test coverage through the application. These are not a full E2E test, since I preferred stubbing requests to ensure certain
results to be displayed and prevent flakiness as much as possible.

Tests can be executed locally by running

```bash
npm run test
```

> [!Important]
> Cypress requires the application running at localhost:8000. Please ensure your dev server is up
> and running if you want to execute the test suite.

## Area of improvements

While the project can be considered feature complete, there are several things that can be added to improve it even further:

- add area supports (e.g., being able to search for Canadian meals);
- unit test through `elm-test` to increase robustness of reusable and generic functions;
- add sections to the home page, such as "last recipes" or "popular recipes";
- a nicer "not found" page;
- a nicer generic error page.

These are the ones from the top of my head, but there are surely many others.
