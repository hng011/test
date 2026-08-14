import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

/**
 * Inline Vite plugin that writes a minimal index.html shell into dist.
 * Because the build entry is src/App.vue (an SFC) rather than an HTML
 * file, Vite does not generate an HTML page on its own — this plugin
 * emits one that loads the built entry chunk.
 */
function emitIndexHtml() {
  return {
    name: 'emit-index-html',
    generateBundle() {
      this.emitFile({
        type: 'asset',
        fileName: 'index.html',
        source: `<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Vue Task List</title>
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/app.js"></script>
  </body>
</html>
`,
      });
    },
  };
}

export default defineConfig({
  plugins: [vue(), emitIndexHtml()],
  build: {
    rollupOptions: {
      // src/App.vue is the build entry (instead of a root index.html).
      input: 'src/App.vue',
      output: {
        // Deterministic chunk name so the emitted index.html shell can
        // reference the built entry without hashing.
        entryFileNames: 'app.js',
      },
    },
  },
});
