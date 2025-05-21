import {
  categories,
  ingredients,
  searchByIngredients,
  searchRecipes,
  searchNotFound,
  chickenRecipe
} from "../support/interceptors";


describe('Search Page', () => {
  beforeEach(() => {
    categories();
    ingredients();
    searchByIngredients();
    searchRecipes();
  })

  context('When a user performs a search from homepage', () => {
    it('They should see a list of search hits for existing matches', () => {
      cy.visit('/');

      cy.get('[data-cy=search-box]').type('c');

      cy.get('[data-cy=recipe-hit]').should('have.length', 3);
      cy.get('[data-cy=ingredient-hit]').should('have.length', 1);

      cy.get('[data-cy=search-box]').type('cfs');

      cy.get('[data-cy=recipe-hit]').should('not.exist');
      cy.get('[data-cy=ingredient-hit]').should('not.exist');
    });

    it('They should see be able to click on a recipe and visits its page', () => {
      chickenRecipe();

      cy.visit('/');

      cy.get('[data-cy=search-box]').type('c');

      cy.get('[data-cy=recipe-hit]').first().click();

      cy.url().should('include', '/recipe/52765');
    });
  });

  context('When a user visits a search with no results', () => {
    it('They should see a Not Found page', () => {
      searchNotFound();

      cy.visit('/search/unicorns');

      expect(cy.get('[data-cy="not-found"]').should('exist'));
    });
  });
});
