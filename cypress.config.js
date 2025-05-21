const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    baseUrl: "http://localhost:8000",
    supportFile: false,
    specPattern: "cypress/integrations/**/*.spec.{js,jsx,ts,tsx}",
    viewportHeight: 800,
    viewportWidth: 1280,
    experimentalRunAllSpecs: true,
    experimentalStudio: true,
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
});
