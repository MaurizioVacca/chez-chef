const categories = () => cy.intercept('GET', '**/categories.php*', { fixture: 'categories.json' });

const ingredients = () => cy.intercept('GET', '**/list.php?i=list*', { fixture: 'ingredients.json' });

export { categories, ingredients}
