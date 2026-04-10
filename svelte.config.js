import adapter from '@sveltejs/adapter-node';
import { mdsvex } from "mdsvex";
import remarkGfm from "remark-gfm";
import { resolve } from "path";

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		adapter: adapter(),
		experimental: {
			remoteFunctions: true
		}
	},
	compilerOptions: {
		experimental: {
			async: true
		}
	},
	preprocess: mdsvex({
		extensions: [".md"],
		remarkPlugins: [remarkGfm],
		layout: resolve("./src/lib/Layout.svelte")
	}),
	extensions: [".svelte", ".md"]
};

export default config;
