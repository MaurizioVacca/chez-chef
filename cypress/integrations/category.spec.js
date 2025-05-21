import { categories, ingredients, recipesByCategory, notFoundByCategory } from "../support/interceptors";


describe('Category Page', () => {
  beforeEach(() => {
    categories();
    ingredients();
    recipesByCategory();
    notFoundByCategory();
  })

  context('When a user visits an existing category page', () => {

    it('They should see a list with all of the recipes for said category', () => {
      cy.visit('/category/beef');

      expect(cy.get('[data-cy="main-title"]').should('exist'));
      expect(cy.get('[data-cy="intro-paragraph"]').should('exist'));
      expect(cy.get('[data-cy="recipe-card"]').should('have.length', 3));
    });
  });

  context('When a user visits a not existing category page', () => {
    it('They should see a Not Found page', () => {
      cy.visit('/category/unicorns');

      expect(cy.get('[data-cy="not-found"]').should('exist'));
    });
  });
});
