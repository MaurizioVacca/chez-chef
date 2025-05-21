const categories = () => cy.intercept('GET', '**/categories.php*', { fixture: 'categories.json' });

const ingredients = () => cy.intercept('GET', '**/list.php?i=list*', { fixture: 'ingredients.json' });

const recipesByCategory = () => cy.intercept('GET', '**/filter.php?c=beef', { fixture: 'recipesByCategory.json' });

const notFoundByCategory = () => cy.intercept('GET', '**/filter.php?c=unicorns', { meals: null });

const recipe = () => cy.intercept('GET', '**/lookup.php*', { fixture: 'recipe.json' });

export {
  categories,
  ingredients,
  recipesByCategory,
  notFoundByCategory
};
