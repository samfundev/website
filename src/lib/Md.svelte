<script lang="ts">
	import Markdown from 'svelte-exmarkdown';
	import remarkGfm from 'remark-gfm';
	import remarkFrontmatter from 'remark-frontmatter';

	const { md } = $props();

	const plugins = [{ remarkPlugin: remarkGfm }, { remarkPlugin: remarkFrontmatter }];
</script>

<Markdown {md} {plugins} />
