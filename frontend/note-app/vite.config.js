export default {
  root: 'src',
  build: {
    outDir: '../dist',
    rollupOptions: {
      input: {
        index: "./src/index.html",
        about: "./src/about.html",
      },
    }
  }
}