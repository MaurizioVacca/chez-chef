import { categories, ingredients, recipe, recipeNotFound } from "../support/interceptors";


describe('Recipe Page', () => {
    beforeEach(() => {
        categories();
        ingredients();
        recipe();
        recipeNotFound();
    })

    context('When a user visits an existing recipe page', () => {

        it('They should see a meal page with a title, ingredients and instructions', () => {
            cy.visit('/recipe/52771');

            expect(cy.get('[data-cy="main-title"]').should('exist'));
            expect(cy.get('[data-cy="recipe-instructions"]').should('exist'));
            expect(cy.get('[data-cy="recipe-ingredients"]').should('exist'));
        });
    });

    context('When a user visits a not existing category page', () => {
        it('They should see a Not Found page', () => {
            cy.visit('/recipe/99999');

            expect(cy.get('[data-cy="not-found"]').should('exist'));
        });
    });
});
