import { categories, ingredients } from "../support/interceptors";


describe('Home Page', () => {
  beforeEach(() => {
    categories();
    ingredients();

    cy.visit('/');
  })

  context('When a user visits the homepage', () => {
    it('They should see a list with all of the categories', () => {
      expect(cy.get('[data-cy="category-card"]').should('have.length', 14));
    });
  });
});
