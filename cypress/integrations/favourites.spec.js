import {categories, chickenRecipe, ingredients} from "../support/interceptors";

describe('Favourite Page', () => {

  context('When a user wants to visit their favourite page', () => {
    beforeEach(() => {
      categories();
      ingredients();
      chickenRecipe();
    });

    it('They can access from direct url', () => {
      cy.visit('/favourites');

      cy.get('[data-cy=main-title]').contains( 'Your Favourites');
    });

    it('They can access from navbar', () => {
      cy.visit('/');

      cy.get('[data-cy=favourites-link]').click();
      cy.url().should('include', '/favourites');
    });
  });

  context('When a user visits a recipe page', () => {
    context('And the recipe is not in their favourites list', () => {
      it('They should be able to add it with a dedicated button', () => {
        cy.visit('/recipe/52765');
        cy.get('[data-cy=favourite-toggle]').click();

        cy.visit('/favourites');
        cy.get('[data-cy=recipe-card]').should('have.length', 1);
      });
    });

    context('And the recipe is in their favourites list', () => {
      beforeEach(() => {
        cy.visit('/recipe/52765');
        cy.get('[data-cy=favourite-toggle]').click();
      });

      it ('They should see it on the favourites page', () => {
        cy.visit('/favourites');

        cy.get('[data-cy=recipe-card]').should('have.length', 1);
      });

      it('They should be able to remove it with a dedicated button', () => {
        cy.visit('/recipe/52765');
        cy.get('[data-cy=favourite-toggle]').click();
        cy.get('[data-cy=recipe-card]').should('not.exist');
      });
    });
  });
});
