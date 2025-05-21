const categories = () => cy.intercept('GET', '**/categories.php*', { fixture: 'categories.json' });

const ingredients = () => cy.intercept('GET', '**/list.php?i=list*', { fixture: 'ingredients.json' });

const recipesByCategory = () => cy.intercept('GET', '**/filter.php?c=beef', { fixture: 'recipesByCategory.json' });

const notFoundByCategory = () => cy.intercept('GET', '**/filter.php?c=unicorns', { meals: null });

const beefRecipe = () => cy.intercept('GET', '**/lookup.php?i=52771', { fixture: '52771.json' });

const chickenRecipe = () => cy.intercept('GET', '**/lookup.php?i=52765', { fixture: '52765.json' });

const recipeNotFound = () => cy.intercept('GET', '**/lookup.php?i=99999', { meals: null });

const searchRecipes = () => cy.intercept('GET', '**/search.php?s=c', { fixture: 'recipes.json' });

const searchNotFound = () => cy.intercept('GET', '**/search.php?s=unicorns', { meals: null });

const searchByIngredients = () => cy.intercept('GET', '**/filter.php?i=chicken', { fixture: 'recipes.json' });

export {
  categories,
  ingredients,
  recipesByCategory,
  notFoundByCategory,
  beefRecipe,
  chickenRecipe,
  recipeNotFound,
  searchRecipes,
  searchNotFound,
  searchByIngredients
};
