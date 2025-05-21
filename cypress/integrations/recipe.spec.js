import {beefRecipe, categories, ingredients, recipeNotFound} from "../support/interceptors";


describe('Recipe Page', () => {
    beforeEach(() => {
        categories();
        ingredients();
        beefRecipe();
        recipeNotFound();
    })

    context('When a user visits an existing recipe page', () => {

        it('They should see a meal page with a title, ingredients and instructions', () => {
            cy.visit('/recipe/52771');

            cy.get('[data-cy="main-title"]').should('exist');
            cy.get('[data-cy="recipe-instructions"]').should('exist');
            cy.get('[data-cy="recipe-ingredients"]').should('exist');
        });
    });

    context('When a user visits a not existing category page', () => {
        it('They should see a Not Found page', () => {
            cy.visit('/recipe/99999');

            cy.get('[data-cy="not-found"]').should('exist');
        });
    });
});
